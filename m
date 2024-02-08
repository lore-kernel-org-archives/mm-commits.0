Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C87667C44;
	Thu,  8 Feb 2024 05:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369690; cv=none; b=i2x89QNU5QQ55Z6QhjzMQ5M53hFknay0Au8I+ZfSFc44nxMFbK766hbsE5jfQ5+WuQkUAScRfcj448Vw2rpJm29ZltTwjlvDURms7qRb0mqREU78aGmDWQjy1mj4ttBco9iU0yD/NpE7Q8suwqPg5Pxc6Oadfg/4Of0SBocaUTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369690; c=relaxed/simple;
	bh=VLTvi2Cl7EYdXm/LKue3t/mQxJtYbVZwxtZqXIUEugo=;
	h=Date:To:From:Subject:Message-Id; b=lLKVcxfiMsBoD3Ee4gDc4CZIuLXfxD9wX3HuWLA7KYDOZOcCxt5qZoTQSSPjNKpSABiNybTbIZPsPd/N5H7b4vsAY/ewVITE2tZLBXFsNiusUGI47TTR655Xj663hyA57K1WZj2uqE26rk1urmdCs/u4iwGqhJ74mNqtCN/j204=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHDazOV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHDazOV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE45FC433F1;
	Thu,  8 Feb 2024 05:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369690;
	bh=VLTvi2Cl7EYdXm/LKue3t/mQxJtYbVZwxtZqXIUEugo=;
	h=Date:To:From:Subject:From;
	b=XHDazOV06abBSaE+k4QpLKYeaMSGLEWvF2KCefmJS/0AjxNUsXEbyAIQbaHfBr7ER
	 HSdWjNfkaXqeVFHrJ90dEG0nZPTbXeD4ikgzOOEcDr9kr14axBqnkLf7nkCa146eEW
	 3ZavY9mNAwVuNmzkq+UWAXk99Wyafe61qkbiyYvU=
Date: Wed, 07 Feb 2024 21:21:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers.patch removed from -mm tree
Message-Id: <20240208052129.DE45FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
Date: Wed, 31 Jan 2024 23:56:57 +0900

Syzbot reported a hang issue in migrate_pages_batch() called by mbind()
and nilfs_lookup_dirty_data_buffers() called in the log writer of nilfs2.

While migrate_pages_batch() locks a folio and waits for the writeback to
complete, the log writer thread that should bring the writeback to
completion picks up the folio being written back in
nilfs_lookup_dirty_data_buffers() that it calls for subsequent log
creation and was trying to lock the folio.  Thus causing a deadlock.

In the first place, it is unexpected that folios/pages in the middle of
writeback will be updated and become dirty.  Nilfs2 adds a checksum to
verify the validity of the log being written and uses it for recovery at
mount, so data changes during writeback are suppressed.  Since this is
broken, an unclean shutdown could potentially cause recovery to fail.

Investigation revealed that the root cause is that the wait for writeback
completion in nilfs_page_mkwrite() is conditional, and if the backing
device does not require stable writes, data may be modified without
waiting.

Fix these issues by making nilfs_page_mkwrite() wait for writeback to
finish regardless of the stable write requirement of the backing device.

Link: https://lkml.kernel.org/r/20240131145657.4209-1-konishi.ryusuke@gmail.com
Fixes: 1d1d1a767206 ("mm: only enforce stable page writes if the backing device requires it")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+ee2ae68da3b22d04cd8d@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000047d819061004ad6c@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/file.c~nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers
+++ a/fs/nilfs2/file.c
@@ -107,7 +107,13 @@ static vm_fault_t nilfs_page_mkwrite(str
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
-	folio_wait_stable(folio);
+	/*
+	 * Since checksumming including data blocks is performed to determine
+	 * the validity of the log to be written and used for recovery, it is
+	 * necessary to wait for writeback to finish here, regardless of the
+	 * stable write requirement of the backing device.
+	 */
+	folio_wait_writeback(folio);
  out:
 	sb_end_pagefault(inode->i_sb);
 	return vmf_fs_error(ret);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

