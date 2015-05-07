From: akpm@linux-foundation.org
Subject: + mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch added to
 -mm tree
Date: Thu, 07 May 2015 16:54:15 -0700
Message-ID: <554bfb27.xdWYZn1y6+GlIu8C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbEGXyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2015 19:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: reesefaucette@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix off-by-one in mmap overflow check 
has been added to the -mm tree.  Its filename is
     mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Reese Faucette" <reesefaucette@gmail.com>
Subject: mm/mmap.c: fix off-by-one in mmap overflow check 

When checking for overflow, the code in mm/mmap.c compares the first byte
*after* the end of mapped region to the start of the region instead of the
last byte of the mapped region.

This prevents mapping a region which abuts the end of physical space, as
mmap() incorrectly rejects the region with -EOVERFLOW, because pgoff +
(len >> PAGE_SHIFT) will be 0, which is < pgoff.  -reese



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-fix-off-by-one-in-mmap-overflow-check mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-fix-off-by-one-in-mmap-overflow-check
+++ a/mm/mmap.c
@@ -1280,7 +1280,7 @@ unsigned long do_mmap_pgoff(struct file
 		return -ENOMEM;
 
 	/* offset overflow? */
-	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
+	if ((pgoff + (len >> PAGE_SHIFT) - 1) < pgoff)
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
_

Patches currently in -mm which might be from reesefaucette@gmail.com are

mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch

