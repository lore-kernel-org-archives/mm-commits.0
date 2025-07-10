Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474754A0C;
	Thu, 10 Jul 2025 21:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184281; cv=none; b=twoLUh3kwl4305CecBQsfawUHYtzwfOkJaII0rtxiRmjwXDJtcoFdlm8rRMGnvf2VrX7kcVrpWF/YyGpr/mTK0UcNuyFcIKOF4B1DHvcJrKl5bI9DIQ5PZrAUh0BybIXf3ZIGx4SYWDwULBiB8+MhsUX08NHUtlZC4hgky7hV2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184281; c=relaxed/simple;
	bh=5m6qJ9eZoJPjAGXkbNfPJq6weZQQsBSwKfU7jVBaEaQ=;
	h=Date:To:From:Subject:Message-Id; b=VDeEXL8a+sMgoB3WulgHVf3zH/7CzE+VNDiFVyi4L/U+VlpJwytUGxAeiyOXg6a05oheQrYhR7LoIZKZqYPVcmii985OjDwIJrbg/LDbkCQa/5E+1Sw+Hd8ep08lnMLR9bp+QlHCC0oZqm0kn/ukPck2mKUIDiA1up96jYPkMDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VhG4pzoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VhG4pzoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2973C4CEE3;
	Thu, 10 Jul 2025 21:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184280;
	bh=5m6qJ9eZoJPjAGXkbNfPJq6weZQQsBSwKfU7jVBaEaQ=;
	h=Date:To:From:Subject:From;
	b=VhG4pzoG026nII0MShiZCaEVymN1/dg3yvsKP+bqq6wEy6Gp7mfVtU/p8NOY+197z
	 OK8ExSnkp8yjp98ZTA/pG/twGcbAcmIe6kae0W0LpPFL4F4LeqckdhknE7J0jm4X3o
	 aBGRW6A0Pe3oaM7qxIg0df+ANlnOkoT/tAoSQal8=
Date: Thu, 10 Jul 2025 14:51:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-reject-invalid-file-types-when-reading-inodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20250710215120.B2973C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: reject invalid file types when reading inodes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-reject-invalid-file-types-when-reading-inodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-reject-invalid-file-types-when-reading-inodes.patch

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
Subject: nilfs2: reject invalid file types when reading inodes
Date: Thu, 10 Jul 2025 22:49:08 +0900

To prevent inodes with invalid file types from tripping through the vfs
and causing malfunctions or assertion failures, add a missing sanity check
when reading an inode from a block device.  If the file type is not valid,
treat it as a filesystem error.

Link: https://lkml.kernel.org/r/20250710134952.29862-1-konishi.ryusuke@gmail.com
Fixes: 05fe58fdc10d ("nilfs2: inode operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c~nilfs2-reject-invalid-file-types-when-reading-inodes
+++ a/fs/nilfs2/inode.c
@@ -472,11 +472,18 @@ static int __nilfs_read_inode(struct sup
 		inode->i_op = &nilfs_symlink_inode_operations;
 		inode_nohighmem(inode);
 		inode->i_mapping->a_ops = &nilfs_aops;
-	} else {
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &nilfs_special_inode_operations;
 		init_special_inode(
 			inode, inode->i_mode,
 			huge_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
+	} else {
+		nilfs_error(sb,
+			    "invalid file type bits in mode 0%o for inode %lu",
+			    inode->i_mode, ino);
+		err = -EIO;
+		goto failed_unmap;
 	}
 	nilfs_ifile_unmap_inode(raw_inode);
 	brelse(bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-reject-invalid-file-types-when-reading-inodes.patch

