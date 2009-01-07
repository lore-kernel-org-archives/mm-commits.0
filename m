From: akpm@linux-foundation.org
Subject: - hugetlb-unsigned-ret-cannot-be-negative.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:17 -0800
Message-ID: <200901072214.n07MEHd6014206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760731AbZAGWOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, agl@us.ibm.com, clameter@sgi.com, david@gibson.dropbear.id.au, hugh@veritas.com, kenchen@google.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     hugetlb: unsigned ret cannot be negative
has been removed from the -mm tree.  Its filename was
     hugetlb-unsigned-ret-cannot-be-negative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: unsigned ret cannot be negative
From: Roel Kluin <roel.kluin@gmail.com>

unsigned long ret cannot be negative, but ret can get -EFAULT.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-unsigned-ret-cannot-be-negative fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-unsigned-ret-cannot-be-negative
+++ a/fs/hugetlbfs/inode.c
@@ -252,6 +252,7 @@ static ssize_t hugetlbfs_read(struct fil
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
+		int ra;
 
 		/* nr is the maximum number of bytes to copy from this page */
 		nr = huge_page_size(h);
@@ -274,16 +275,19 @@ static ssize_t hugetlbfs_read(struct fil
 			 */
 			ret = len < nr ? len : nr;
 			if (clear_user(buf, ret))
-				ret = -EFAULT;
+				ra = -EFAULT;
+			else
+				ra = 0;
 		} else {
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
-			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
+			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
+			ret = ra;
 		}
-		if (ret < 0) {
+		if (ra < 0) {
 			if (retval == 0)
-				retval = ret;
+				retval = ra;
 			if (page)
 				page_cache_release(page);
 			goto out;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
ufs-sector_t-cannot-be-negative.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
make-various-things-static.patch

