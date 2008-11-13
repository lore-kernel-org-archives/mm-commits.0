From: akpm@linux-foundation.org
Subject: + mm-vmalloc-search-restart-fix.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:16:00 -0800
Message-ID: <200811130016.mAD0G12c014348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYKMAQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@redhat.com, npiggin@suse.de


The patch titled
     mm: vmalloc search restart fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-search-restart-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc search restart fix
From: Glauber Costa <glommer@redhat.com>

Current vmalloc restart search for a free area in case we can't find one. 
The reason is there are areas which are lazily freed, and could be
possibly freed now.  However, current implementation start searching the
tree from the last failing address, which is pretty much by definition at
the end of address space.  So, we fail.

The proposal of this patch is to restart the search from the beginning of
the requested vstart address.  This fixes the regression in running KVM
virtual machines for me, described in http://lkml.org/lkml/2008/10/28/349,
caused by commit db64fe02258f1507e13fe5212a989922323685ce.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-search-restart-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-search-restart-fix
+++ a/mm/vmalloc.c
@@ -324,14 +324,14 @@ static struct vmap_area *alloc_vmap_area
 
 	BUG_ON(size & ~PAGE_MASK);
 
-	addr = ALIGN(vstart, align);
