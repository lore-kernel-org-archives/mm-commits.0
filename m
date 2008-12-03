From: akpm@linux-foundation.org
Subject: + hugetlb-unsigned-ret-cannot-be-negative.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:35:29 -0800
Message-ID: <200812030835.mB38ZTUE019317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYLCIfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:35:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, agl@us.ibm.com, clameter@sgi.com, david@gibson.dropbear.id.au, hugh@veritas.com, kenchen@google.com, npiggin@suse.de


The patch titled
     hugetlb: unsigned ret cannot be negative
has been added to the -mm tree.  Its filename is
     hugetlb-unsigned-ret-cannot-be-negative.patch

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

linux-next.patch
libsas-fix-test-for-negative-unsigned-and-typos.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch
sm501-unsigned-ptr-cannot-be-negative.patch
ufs-sector_t-cannot-be-negative.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
make-various-things-static.patch

