Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A413ACF1D
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757197; cv=none; b=LRxe040bE08TDQDYWuPP5edBChocDvZcLlma6sn8sO2YIrFFVll6L+sS5VyO9jU3YsHQLZc+ZMXuiqa8+OqxPngkd1Y9/I6oZLZxs/cGfs+Jt4cN3yEEOJfZfKdq3SNh1hxJoEHoN+SwOPWl6W76zea2awDaJz6mz72+BeD2gdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757197; c=relaxed/simple;
	bh=SCxPQRmClmGoeonRn3IItMemxg72qRahoo2QGW8Vel4=;
	h=Date:To:From:Subject:Message-Id; b=R0s2eklH1b4U89++LC7VXZfkev5EcRSynopQYiuPgda6bxKrdmPwtZi4Gz+GSb9vL44EGceLyrHPQdwcwY9hzrx4xQaGCxjleRjS6P3U/yqQS0u9mK6r11RPdF8Bb3hPc4N8I686rk8Bho62eCLbXAIMs9PIAF4GKcd8Cnb4dcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtHc+CDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtHc+CDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5EE1F0089C;
	Sun, 11 Oct 2026 22:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757196;
	bh=iWJ+jEqWmzdZLZlbwuqPuEQIcW/+tzhMWqbFH9vhlSM=;
	h=Date:To:From:Subject;
	b=rtHc+CDepIa1aeMjxqxo5KmTuHVVI1WHp+MgkKCu9rlXaCKyYv0qx7TNkYjiHr8HW
	 dBNzAc6CHzJJnKBeEsRXffdF5tSYfnGZvd7xVj9PeB78T+uPwWI2q36dNiY2EDu0d5
	 JqLjnXMJJQMzvgtahuPMmyZa9TSnQcTQ0ezbLYh4=
Date: Sun, 11 Oct 2026 15:19:55 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch removed from -mm tree
Message-Id: <20261011221956.0E5EE1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: restore -ERANGE check in ocfs2_xattr_tree_list_index_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4526,7 +4526,8 @@ static int ocfs2_xattr_tree_list_index_b
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

ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch
ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch
ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch
ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch
ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

