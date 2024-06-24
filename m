Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7D1A256A;
	Mon, 24 Jun 2024 23:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719270192; cv=none; b=bP9OzYd/a8Roqju9fgf9pGPxJEvdo7Lvtol+wvY2rSThC5LJMx8zPf+gGQ2TPAwCgXQsc5voXvFgrIAtACS6n4HTz4JwZHMLGH7/R+jATkWAQzvbB/eP9NGPuDhVDiKx1CM47NrrmOT/l7v8rTzAZ4b8oGwaoLBGa21+PV2Cl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719270192; c=relaxed/simple;
	bh=ZJyysTIMxWSKQeITd/lJ3Oj3oUC7p/FBe8w489TSImo=;
	h=Date:To:From:Subject:Message-Id; b=Tx+qMPi4RJWjZsdvwWRSITm3BGFwfqGwx69Xk+jItLg0PQN68huG3As6wZlJ5ldnFSAs4FBWuV3wwRrZUOtA6HqfqjRPb8huDM5fZnup6b2r6TF4VK01wkiT9VLKjhYViPfcYVjcJz5u0rNhZ8GLZ1Rmw9vr7gnmH5Wn7lOpdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=na9Owsrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="na9Owsrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB3AC2BBFC;
	Mon, 24 Jun 2024 23:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719270192;
	bh=ZJyysTIMxWSKQeITd/lJ3Oj3oUC7p/FBe8w489TSImo=;
	h=Date:To:From:Subject:From;
	b=na9OwsrnXd2I7cUTO6cm0zbFOHiaicB8Y18C5jesseyzjPc0dqhaM8btaaAUKJPMA
	 XQXc/CLcmNMn/B2Wszfmb9CJO897UyD8MmBP2Q4E4CWYEAgdRz0ejOKwW6pSpgC8cp
	 RHW9CqGYwtqQfutvABWWvlmeEAJVtCJirnC5Liu0=
Date: Mon, 24 Jun 2024 16:03:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jack@suse.cz,hdanton@sina.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20240624230312.2EB3AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix incorrect inode allocation from reserved inodes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix incorrect inode allocation from reserved inodes
Date: Sun, 23 Jun 2024 14:11:35 +0900

If the bitmap block that manages the inode allocation status is corrupted,
nilfs_ifile_create_inode() may allocate a new inode from the reserved
inode area where it should not be allocated.

Previous fix commit d325dc6eb763 ("nilfs2: fix use-after-free bug of
struct nilfs_root"), fixed the problem that reserved inodes with inode
numbers less than NILFS_USER_INO (=11) were incorrectly reallocated due to
bitmap corruption, but since the start number of non-reserved inodes is
read from the super block and may change, in which case inode allocation
may occur from the extended reserved inode area.

If that happens, access to that inode will cause an IO error, causing the
file system to degrade to an error state.

Fix this potential issue by adding a wraparound option to the common
metadata object allocation routine and by modifying
nilfs_ifile_create_inode() to disable the option so that it only allocates
inodes with inode numbers greater than or equal to the inode number read
in "nilfs->ns_first_ino", regardless of the bitmap status of reserved
inodes.

Link: https://lkml.kernel.org/r/20240623051135.4180-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   19 +++++++++++++++----
 fs/nilfs2/alloc.h |    4 ++--
 fs/nilfs2/dat.c   |    2 +-
 fs/nilfs2/ifile.c |    7 ++-----
 4 files changed, 20 insertions(+), 12 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes
+++ a/fs/nilfs2/alloc.c
@@ -377,11 +377,12 @@ void *nilfs_palloc_block_get_entry(const
  * @target: offset number of an entry in the group (start point)
  * @bsize: size in bits
  * @lock: spin lock protecting @bitmap
+ * @wrap: whether to wrap around
  */
 static int nilfs_palloc_find_available_slot(unsigned char *bitmap,
 					    unsigned long target,
 					    unsigned int bsize,
-					    spinlock_t *lock)
+					    spinlock_t *lock, bool wrap)
 {
 	int pos, end = bsize;
 
@@ -397,6 +398,8 @@ static int nilfs_palloc_find_available_s
 
 		end = target;
 	}
+	if (!wrap)
+		return -ENOSPC;
 
 	/* wrap around */
 	for (pos = 0; pos < end; pos++) {
@@ -495,9 +498,10 @@ int nilfs_palloc_count_max_entries(struc
  * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
+ * @wrap: whether to wrap around
  */
 int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
-				     struct nilfs_palloc_req *req)
+				     struct nilfs_palloc_req *req, bool wrap)
 {
 	struct buffer_head *desc_bh, *bitmap_bh;
 	struct nilfs_palloc_group_desc *desc;
@@ -516,7 +520,7 @@ int nilfs_palloc_prepare_alloc_entry(str
 	entries_per_group = nilfs_palloc_entries_per_group(inode);
 
 	for (i = 0; i < ngroups; i += n) {
-		if (group >= ngroups) {
+		if (group >= ngroups && wrap) {
 			/* wrap around */
 			group = 0;
 			maxgroup = nilfs_palloc_group(inode, req->pr_entry_nr,
@@ -550,7 +554,14 @@ int nilfs_palloc_prepare_alloc_entry(str
 			bitmap_kaddr = kmap_local_page(bitmap_bh->b_page);
 			bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 			pos = nilfs_palloc_find_available_slot(
-				bitmap, group_offset, entries_per_group, lock);
+				bitmap, group_offset, entries_per_group, lock,
+				wrap);
+			/*
+			 * Since the search for a free slot in the second and
+			 * subsequent bitmap blocks always starts from the
+			 * beginning, the wrap flag only has an effect on the
+			 * first search.
+			 */
 			kunmap_local(bitmap_kaddr);
 			if (pos >= 0)
 				goto found;
--- a/fs/nilfs2/alloc.h~nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes
+++ a/fs/nilfs2/alloc.h
@@ -50,8 +50,8 @@ struct nilfs_palloc_req {
 	struct buffer_head *pr_entry_bh;
 };
 
-int nilfs_palloc_prepare_alloc_entry(struct inode *,
-				     struct nilfs_palloc_req *);
+int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
+				     struct nilfs_palloc_req *req, bool wrap);
 void nilfs_palloc_commit_alloc_entry(struct inode *,
 				     struct nilfs_palloc_req *);
 void nilfs_palloc_abort_alloc_entry(struct inode *, struct nilfs_palloc_req *);
--- a/fs/nilfs2/dat.c~nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes
+++ a/fs/nilfs2/dat.c
@@ -75,7 +75,7 @@ int nilfs_dat_prepare_alloc(struct inode
 {
 	int ret;
 
-	ret = nilfs_palloc_prepare_alloc_entry(dat, req);
+	ret = nilfs_palloc_prepare_alloc_entry(dat, req, true);
 	if (ret < 0)
 		return ret;
 
--- a/fs/nilfs2/ifile.c~nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes
+++ a/fs/nilfs2/ifile.c
@@ -56,13 +56,10 @@ int nilfs_ifile_create_inode(struct inod
 	struct nilfs_palloc_req req;
 	int ret;
 
-	req.pr_entry_nr = 0;  /*
-			       * 0 says find free inode from beginning
-			       * of a group. dull code!!
-			       */
+	req.pr_entry_nr = NILFS_FIRST_INO(ifile->i_sb);
 	req.pr_entry_bh = NULL;
 
-	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req, false);
 	if (!ret) {
 		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 1,
 						   &req.pr_entry_bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-inode-number-range-checks.patch
nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch
nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch
nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch
nilfs2-do-not-call-inode_attach_wb-directly.patch

