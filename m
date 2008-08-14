From: akpm@linux-foundation.org
Subject: + bootmem-allocator-alloc_bootmem_core-page-align-the-end-offset.patch added to -mm tree
Date: Thu, 14 Aug 2008 16:58:54 -0700
Message-ID: <200808142358.m7ENws2c004160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYHNX73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpatocka@redhat.com, davem@davemloft.net, hannes@saeurebad.de


The patch titled
     bootmem allocator: alloc_bootmem_core(): page-align the end offset
has been added to the -mm tree.  Its filename is
     bootmem-allocator-alloc_bootmem_core-page-align-the-end-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem allocator: alloc_bootmem_core(): page-align the end offset
From: Mikulas Patocka <mpatocka@redhat.com>

This is the minimal sequence that jams the allocator:

void *p, *q, *r;
p = alloc_bootmem(PAGE_SIZE);
q = alloc_bootmem(64);
free_bootmem(p, PAGE_SIZE);
p = alloc_bootmem(PAGE_SIZE);
r = alloc_bootmem(64);

after this sequence (assuming that the allocator was empty or page-aligned
before), pointer "q" will be equal to pointer "r".

What's hapenning inside the allocator:
p = alloc_bootmem(PAGE_SIZE);
in allocator: last_end_off == PAGE_SIZE, bitmap contains bits 10000...
q = alloc_bootmem(64);
in allocator: last_end_off == PAGE_SIZE + 64, bitmap contains 11000...
free_bootmem(p, PAGE_SIZE);
in allocator: last_end_off == PAGE_SIZE + 64, bitmap contains 01000...
p = alloc_bootmem(PAGE_SIZE);
in allocator: last_end_off == PAGE_SIZE, bitmap contains 11000...
r = alloc_bootmem(64);

and now:

it finds bit "2", as a place where to allocate (sidx)

it hits the condition

if (bdata->last_end_off && PFN_DOWN(bdata->last_end_off) + 1 == sidx))
start_off = ALIGN(bdata->last_end_off, align);

-you can see that the condition is true, so it assigns start_off = 
ALIGN(bdata->last_end_off, align); (that is PAGE_SIZE) and allocates 
over already allocated block.

With the patch it tries to continue at the end of previous allocation only 
if the previous allocation ended in the middle of the page.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Johannes Weiner <hannes@saeurebad.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bootmem.c~bootmem-allocator-alloc_bootmem_core-page-align-the-end-offset mm/bootmem.c
--- a/mm/bootmem.c~bootmem-allocator-alloc_bootmem_core-page-align-the-end-offset
+++ a/mm/bootmem.c
@@ -473,7 +473,7 @@ find_block:
 				goto find_block;
 			}
 
-		if (bdata->last_end_off &&
+		if (bdata->last_end_off & (PAGE_SIZE - 1) &&
 				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
 			start_off = ALIGN(bdata->last_end_off, align);
 		else
_

Patches currently in -mm which might be from mpatocka@redhat.com are

bootmem-allocator-alloc_bootmem_core-page-align-the-end-offset.patch
linux-next.patch

