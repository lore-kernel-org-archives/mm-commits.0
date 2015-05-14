From: akpm@linux-foundation.org
Subject: [withdrawn] mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch
 removed from -mm tree
Date: Thu, 14 May 2015 11:19:45 -0700
Message-ID: <5554e741.RJ33U1LeWnGbhGry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbENSTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 14:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: reesefaucette@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix off-by-one in mmap overflow check 
has been removed from the -mm tree.  Its filename was
     mm-mmapc-fix-off-by-one-in-mmap-overflow-check.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Reese Faucette <reesefaucette@gmail.com>
Subject: mm/mmap.c: fix off-by-one in mmap overflow check 

When checking for overflow, the code in mm/mmap.c compares the first byte
*after* the end of mapped region to the start of the region instead of the
last byte of the mapped region.

This prevents mapping a region which abuts the end of physical space, as
mmap() incorrectly rejects the region with -EOVERFLOW, because pgoff +
(len >> PAGE_SHIFT) will be 0, which is < pgoff.  -reese

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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


