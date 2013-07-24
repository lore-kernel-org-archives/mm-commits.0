From: akpm@linux-foundation.org
Subject: + mm-fix-negative-left-shift-count-when-page_shift-20.patch added to -mm tree
Date: Wed, 24 Jul 2013 12:51:49 -0700
Message-ID: <51f03055.aCP3qVLJcYsV8tlb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3GXTvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 15:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, uulinux@gmail.com

Subject: + mm-fix-negative-left-shift-count-when-page_shift-20.patch added to -mm tree
To: uulinux@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 12:51:49 -0700


The patch titled
     Subject: mm: fix negative left shift count when PAGE_SHIFT > 20
has been added to the -mm tree.  Its filename is
     mm-fix-negative-left-shift-count-when-page_shift-20.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-negative-left-shift-count-when-page_shift-20.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-negative-left-shift-count-when-page_shift-20.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerry Zhou <uulinux@gmail.com>
Subject: mm: fix negative left shift count when PAGE_SHIFT > 20

When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
previous calculating here will generate an unexpected result. In
addition, if PAGE_SIZE >= 1MB, The memory size of "numentries" was
already integral multiple of 1MB.

Signed-off-by: Jerry Zhou <uulinux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-negative-left-shift-count-when-page_shift-20 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-negative-left-shift-count-when-page_shift-20
+++ a/mm/page_alloc.c
@@ -5745,9 +5745,10 @@ void *__init alloc_large_system_hash(con
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
-		numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
-		numentries >>= 20 - PAGE_SHIFT;
-		numentries <<= 20 - PAGE_SHIFT;
+
+		/* It isn't necessary when PAGE_SIZE >= 1MB */
+		if (PAGE_SHIFT < 20)
+			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
 		/* limit to 1 bucket per 2^scale bytes of low memory */
 		if (scale > PAGE_SHIFT)
_

Patches currently in -mm which might be from uulinux@gmail.com are

mm-fix-negative-left-shift-count-when-page_shift-20.patch

