Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113CC35E53D
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676304; cv=none; b=McwEC9nnnXKGVNt4abvnlGyRwTpgxI/a9oV0xkD2DA0y1tIFz2GvZhVGz7YHXKvg79w2hkPYQbayMZBQDWT/WLevb9Py8JvYo9i5aUFWo4aBPInFjPqjvFEazTi2WIwwxgBbbckPGfv/SIr/WadBm7/WwujgNSjhjwmQHFYxsq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676304; c=relaxed/simple;
	bh=S/cBF3iUn9nbdXSKv6zv+ZSa+Upi4imcWlAxxQzoL8A=;
	h=Date:To:From:Subject:Message-Id; b=ZNQ3vso98aQvNcdkdcIAB8tCcULUamAxEPfmZ9H9w+Ftpt00IK70UiUgOt+ZB3kH4lZXxpwsnu/QjSrcMRX4UnZIgub7DGOFu54BtKiffH+xATKeLTtjO1ka5DSaw/o+CRUGzqwuMJZN9zrbP7GEKik0ec+oWMiIaBH0/Hzu3yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vlbegB53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vlbegB53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5863C4CEF1;
	Thu, 20 Nov 2025 22:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676303;
	bh=S/cBF3iUn9nbdXSKv6zv+ZSa+Upi4imcWlAxxQzoL8A=;
	h=Date:To:From:Subject:From;
	b=vlbegB53SA3IF0uHuc/gYRC0jcWlI3ooajN8JtmqLRLFlbmwks7UsLoZKlka00ux0
	 JS7HJO1+LOmnmT57Fn2pwQ9DnuTGsUJ0hprk27M1JiT2/D8fbL9AIpev+4yv6arv/E
	 au+hPFx1KjPTe9GQ+pMHw23YF/3xfxOi8yl73YAQ=
Date: Thu, 20 Nov 2025 14:05:03 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,david.hunter.linux@gmail.com,albinbabuvarghese20@gmail.com,eraykrdg1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-mark-inode-bad-upon-validation-failure-during-read.patch removed from -mm tree
Message-Id: <20251120220503.D5863C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: mark inode bad upon validation failure during read
has been removed from the -mm tree.  Its filename was
     ocfs2-mark-inode-bad-upon-validation-failure-during-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: ocfs2: mark inode bad upon validation failure during read
Date: Tue, 18 Nov 2025 03:18:34 +0300

A VFS cache inconsistency, potentially triggered by sequences like
buffered writes followed by open(O_DIRECT), can result in an invalid
on-disk inode block (e.g., bad signature).  OCFS2 detects this corruption
when reading the inode block via ocfs2_validate_inode_block(), logs
"Invalid dinode", and often switches the filesystem to read-only mode.

The VFS open(O_DIRECT) operation appears to incorrectly clear the inode's
I_DIRTY flag without ensuring the dirty metadata (reflecting the earlier
buffered write, e.g., an updated i_size) is flushed to disk.  This leaves
the in-memory VFS inode object "in limbo" with an updated size (e.g.,
38639 from the write) but marked clean, while its on-disk counterpart
remains stale (e.g., size 0) or invalid.

Currently, the function reading the inode block
(ocfs2_read_inode_block_full()) fails to call make_bad_inode() upon
detecting the validation error.  Because the in-memory inode is not marked
bad, subsequent operations (like ftruncate) proceed erroneously.  They
eventually reach code (e.g., ocfs2_truncate_file()) that compares the
inconsistent in-memory size (38639) against the invalid/stale on-disk size
(0), leading to kernel crashes via BUG_ON.

Fix this by calling make_bad_inode(inode) within the error handling path
of ocfs2_read_inode_block_full() immediately after a block read or
validation error occurs.  This ensures VFS is properly notified about the
corrupt inode at the point of detection.  Marking the inode bad allows VFS
to correctly fail subsequent operations targeting this inode early,
preventing kernel panics caused by operating on known inconsistent inode
states.

Link: https://lkml.kernel.org/r/20251118001833.423470-2-eraykrdg1@gmail.com
Link: https://lore.kernel.org/all/20251029225748.11361-2-eraykrdg1@gmail.com/T/
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-mark-inode-bad-upon-validation-failure-during-read
+++ a/fs/ocfs2/inode.c
@@ -1727,6 +1727,8 @@ int ocfs2_read_inode_block_full(struct i
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
+	if (rc < 0)
+		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
_

Patches currently in -mm which might be from eraykrdg1@gmail.com are


