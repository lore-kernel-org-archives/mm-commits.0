Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE49131E38;
	Thu, 31 Oct 2024 03:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344515; cv=none; b=WQtbdVKFOaCkwMzO5jmN/RLtdX3rSGeLl/uD0Gz1c7hz5hO1uFJvHS5XPSeEwy73632aWQCC9SHMjTWiikl00C+lqPznCeFrx8TM9MaOf/b1qbc7RZJ9s6rTADrXZ//0UYO64ynVTps55pG+gS0nzZc2mXe912MnYNxQNCyzXS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344515; c=relaxed/simple;
	bh=9G7gNuGaj+raeXNNjzIAVcro2qPUBNJS7Ui5DfQc7tw=;
	h=Date:To:From:Subject:Message-Id; b=Ojwy/jK4OBJsyIHt4leSQ+uV5ycHoUqUpfcrM7rEIapLFgo6brvG1GWt1OfbX120YxRtsOBOez63qV/UybZdZBEo8SoHT3Zzk5N+M46ivHVcaF3jjtnda6etDv6Iw3zoKulPetrx5mYdiy/wZjytQRdHcB8RoMUXdnF8F0xf6oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RIGbVIBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RIGbVIBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C7AC4CECE;
	Thu, 31 Oct 2024 03:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344513;
	bh=9G7gNuGaj+raeXNNjzIAVcro2qPUBNJS7Ui5DfQc7tw=;
	h=Date:To:From:Subject:From;
	b=RIGbVIBeSWyqdmLK6212Ozzb9WXiAtixlRFaNmaLr+GCP5l5wpp20QVKTCXe7/R4B
	 BnevrWFzB+4ieY61jwr/jwviFv1M2114+Zpzx+D8Ehgb4n/gev8nuRe5RtPmGsqG7z
	 FeX0OnCAK2XSNTHImDkianzOXHx8XrIBomhk9yjk=
Date: Wed, 30 Oct 2024 20:15:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch removed from -mm tree
Message-Id: <20241031031513.60C7AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix potential deadlock with newly created symlinks
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix potential deadlock with newly created symlinks
Date: Sun, 20 Oct 2024 13:51:28 +0900

Syzbot reported that page_symlink(), called by nilfs_symlink(), triggers
memory reclamation involving the filesystem layer, which can result in
circular lock dependencies among the reader/writer semaphore
nilfs->ns_segctor_sem, s_writers percpu_rwsem (intwrite) and the
fs_reclaim pseudo lock.

This is because after commit 21fc61c73c39 ("don't put symlink bodies in
pagecache into highmem"), the gfp flags of the page cache for symbolic
links are overwritten to GFP_KERNEL via inode_nohighmem().

This is not a problem for symlinks read from the backing device, because
the __GFP_FS flag is dropped after inode_nohighmem() is called.  However,
when a new symlink is created with nilfs_symlink(), the gfp flags remain
overwritten to GFP_KERNEL.  Then, memory allocation called from
page_symlink() etc.  triggers memory reclamation including the FS layer,
which may call nilfs_evict_inode() or nilfs_dirty_inode().  And these can
cause a deadlock if they are called while nilfs->ns_segctor_sem is held:

Fix this issue by dropping the __GFP_FS flag from the page cache GFP flags
of newly created symlinks in the same way that nilfs_new_inode() and
__nilfs_read_inode() do, as a workaround until we adopt nofs allocation
scope consistently or improve the locking constraints.

Link: https://lkml.kernel.org/r/20241020050003.4308-1-konishi.ryusuke@gmail.com
Fixes: 21fc61c73c39 ("don't put symlink bodies in pagecache into highmem")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ef37ac20608f4836256
Tested-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/namei.c~nilfs2-fix-potential-deadlock-with-newly-created-symlinks
+++ a/fs/nilfs2/namei.c
@@ -157,6 +157,9 @@ static int nilfs_symlink(struct mnt_idma
 	/* slow symlink */
 	inode->i_op = &nilfs_symlink_inode_operations;
 	inode_nohighmem(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_constraint(inode->i_mapping,
+						    ~__GFP_FS));
 	inode->i_mapping->a_ops = &nilfs_aops;
 	err = page_symlink(inode, symname, l);
 	if (err)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-segment-buffer-to-be-folio-based.patch
nilfs2-convert-common-metadata-file-code-to-be-folio-based.patch
nilfs2-convert-segment-usage-file-to-be-folio-based.patch
nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch
nilfs2-convert-inode-file-to-be-folio-based.patch
nilfs2-convert-dat-file-to-be-folio-based.patch
nilfs2-remove-nilfs_palloc_block_get_entry.patch
nilfs2-convert-checkpoint-file-to-be-folio-based.patch

