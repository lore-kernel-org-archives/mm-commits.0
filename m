Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042E8363090
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127856; cv=none; b=bxMpRNl1a5EmvZzhQLbevVUjlQvj2X8VMnCZ1EgJvzqxSKxZNVFmlrkBWA7shJzkhL+rjb/thYw++/jGpBSU4iMzqMNPtpVTNd/0UKGoMQguN13BCqylZ3pWYefuEE6cGOmq5pNzq3zRQ6Nmoaok1M6SiFd1duiA0/LvnUfLYIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127856; c=relaxed/simple;
	bh=4FARncHApOSDojRJP1Jj1Pnr4ZC2GG2dfdFuwSo5hGA=;
	h=Date:To:From:Subject:Message-Id; b=BkQckJtObgnI0K5vsWZszVHUMrFsodCRSj17AVz4hej8hOtXdRsdRkYKJxbYebT+QXKnJqXFJE1GQ3ox6540QbPK/LqXMjA/9fNDekLSuPiCPvdH7KJ1HrIL7LUueHp8oOssuxOJY265tdHNl37sCkNqCyxYV3ybYn1mICBliik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kKmU1jEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kKmU1jEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787311F000FF;
	Wed, 23 Sep 2026 01:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127850;
	bh=3Wrlafwbehvoy+zkZmmmjx3ONqDBU672klsZXCVGY2g=;
	h=Date:To:From:Subject;
	b=kKmU1jEnfxrcLIQ3gQ5yldkgjVYJbB9pJdnfdUn3vvvHzzVJg+LSroZhgSTEq9W9v
	 rkvWJikHHMLtYum3Nl+rTWZdtEIXwDbMWNg5osAW/EDXboXm4X/6E5qPwQ92aGviaj
	 chItlByRv4ZHvSXt4rtdqhxsC/L4uu22tdVFRXmU=
Date: Tue, 22 Sep 2026 18:44:10 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch added to mm-nonmm-unstable branch
Message-Id: <20260923014410.787311F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: restore -ERANGE check in ocfs2_xattr_tree_list_index_block()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: restore -ERANGE check in ocfs2_xattr_tree_list_index_block()
Date: Tue, 22 Sep 2026 17:42:52 +0800

ocfs2_xattr_list_entry() returns -ERANGE when the buffer handed in by the
caller is too small to hold the whole xattr name list.  That is the normal
listxattr(2) protocol, userspace simply retries with a larger buffer, so
it is not an ocfs2 error and must not be logged as one.

Commit a46fa684fcb700 ("ocfs2: Don't printk the error when listing too
many xattrs.") already knew this and silenced two sites, quoting

  (27738,0):ocfs2_iterate_xattr_buckets:3158 ERROR: status = -34
  (27738,0):ocfs2_xattr_tree_list_index_block:3264 ERROR: status = -34

The refactoring in commit 47bca4950bc40f ("ocfs2: Abstract ocfs2 xattr
tree extend rec iteration process.") then rewrote
ocfs2_xattr_tree_list_index_block() around the new
ocfs2_iterate_xattr_index_block() helper and dropped that guard, so the
second message has been emitted ever since:

  ocfs2_xattr_tree_list_index_block:4513 ERROR: status = -34

The exemption in ocfs2_iterate_xattr_buckets() survived because that
function was left alone, and the new helper does check for -ERANGE itself,
which is why only the outermost caller still logs it.

Restore the missing check.  Only the log line changes: -ERANGE is still
returned to the VFS untouched, so listxattr(2) behaves exactly as before.

Link: https://lore.kernel.org/20260922094252.971631-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
---

 fs/ocfs2/xattr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block
+++ a/fs/ocfs2/xattr.c
@@ -4502,7 +4502,8 @@ static int ocfs2_xattr_tree_list_index_b
 	ret = ocfs2_iterate_xattr_index_block(inode, blk_bh,
 					      ocfs2_list_xattr_tree_rec, &xl);
 	if (ret) {
-		mlog_errno(ret);
+		if (ret != -ERANGE)
+			mlog_errno(ret);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch

