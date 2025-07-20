Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592013595E;
	Sun, 20 Jul 2025 02:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978412; cv=none; b=SMX2EnuhSgHwHv3jjvsewAVDD7D5f7iHG18oWalNZeZqQjlykdenKpg0MxmnQBYtJeeZH6y+vrAv10bI+uXdmbB9tvvrQ86wtaSJp6XVxaUkKcmVAQ6ruK4p9NrKZCOsjuITXaVd8f0O+9W5y7V59qhTGxIn0oxFHOcnJcm6I4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978412; c=relaxed/simple;
	bh=QPx2P5dcLI/KB3QDIiw5Z1kkzHAL2l/Dk6NLH5o1Qik=;
	h=Date:To:From:Subject:Message-Id; b=FP58up7WsemEb5ogCtsGj0nGGTVne7W2vb/U4nc3yZNW37zMm+IgB/+nUmXtoqz5lzlrJ04GYfswrz/Ly6DdhwS/Q5nWwak0o3568YMq7jFCgJJd0O0Fb/u19pATR7FtUHdzMGKIRbkAbjJ+Y2VLhZGqspwTymtWmkmnFKeEhDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baH0D6Pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baH0D6Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC90C4CEF5;
	Sun, 20 Jul 2025 02:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978411;
	bh=QPx2P5dcLI/KB3QDIiw5Z1kkzHAL2l/Dk6NLH5o1Qik=;
	h=Date:To:From:Subject:From;
	b=baH0D6PzVcBBb4lpB+I+EJvfA1Vo4Ti3nsxt6x9RGdXzkEyhyT8LRX8bxgY63oZe9
	 sIzGtp94Y8sv6fYXReVHCXI2Rt+p4IPNBX6BmhQoJ94+z5WSa6TRWI2ZYa9wx0UBOm
	 Fl8jCVZHBacSDavWGB+1YvLnxN7WpoiirVGBlogc=
Date: Sat, 19 Jul 2025 19:26:51 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-reject-invalid-file-types-when-reading-inodes.patch removed from -mm tree
Message-Id: <20250720022651.BDC90C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: reject invalid file types when reading inodes
has been removed from the -mm tree.  Its filename was
     nilfs2-reject-invalid-file-types-when-reading-inodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


