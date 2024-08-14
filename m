Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1D14A0A2;
	Wed, 14 Aug 2024 23:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723679964; cv=none; b=WGMJdRjuMWFy0wfplJ0W283OWh0+2DAPIw+wScmyZwsZOzJIrEfukLL5XhkInHPSPNhp9tlfOO8+u1c++45XzAN78sJMIxdM/VAwru7xwBGmeUuesqXY7LYRZNkDsOa6gfdEEYp0azqRN1DzB08VFfkOfV7b9at5nJXI0avExJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723679964; c=relaxed/simple;
	bh=dUC1bR7QL/6MoFiSYyvO/LOosrydNb3/D3g1AnYEQTQ=;
	h=Date:To:From:Subject:Message-Id; b=QCkRaegvsKq3zGxpUOL5GqHWwdsgoaOrk/rcYVHHMD1PwNt7MqC/rmtYsKonkNLKrjO8WlJdZMc8B/L4VHE2XNi+Dla1ZQzIEjO1ooFFjoaVtZG+xV1/2nZdDbc0gjf88nFZ1C3HA/9qnQH763Ot6UcQMFAJXeN6IOnlnU2P5SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A6JnqTNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A6JnqTNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9E9C116B1;
	Wed, 14 Aug 2024 23:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723679963;
	bh=dUC1bR7QL/6MoFiSYyvO/LOosrydNb3/D3g1AnYEQTQ=;
	h=Date:To:From:Subject:From;
	b=A6JnqTNKFf8vFB7jhl3hsnd7mlspi3NWDQdFCJgNI/AsEGKT9xS9u9gBckqHZr4hj
	 KV+GDgC4z60M89JA4kFPEEIMg87EwynJWZ19Zhmg+9xowH3memvUfZM83ITomp8TR/
	 XHPQzFfcTCal7438QtTjexQmmU2j6WZHzEWgWb9E=
Date: Wed, 14 Aug 2024 16:59:22 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,lizhi.xu@windriver.com,jack@suse.cz,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] squashfs-sanity-check-symbolic-link-size.patch removed from -mm tree
Message-Id: <20240814235923.7E9E9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: sanity check symbolic link size
has been removed from the -mm tree.  Its filename was
     squashfs-sanity-check-symbolic-link-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: sanity check symbolic link size
Date: Sun, 11 Aug 2024 21:13:01 +0100

Syzkiller reports a "KMSAN: uninit-value in pick_link" bug.

This is caused by an uninitialised page, which is ultimately caused
by a corrupted symbolic link size read from disk.

The reason why the corrupted symlink size causes an uninitialised
page is due to the following sequence of events:

1. squashfs_read_inode() is called to read the symbolic
   link from disk.  This assigns the corrupted value
   3875536935 to inode->i_size.

2. Later squashfs_symlink_read_folio() is called, which assigns
   this corrupted value to the length variable, which being a
   signed int, overflows producing a negative number.

3. The following loop that fills in the page contents checks that
   the copied bytes is less than length, which being negative means
   the loop is skipped, producing an unitialised page.

This patch adds a sanity check which checks that the symbolic
link size is not larger than expected.

Link: https://lkml.kernel.org/r/20240811201301.13076-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Lizhi Xu <lizhi.xu@windriver.com>
Reported-by: syzbot+24ac24ff58dc5b0d26b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000a90e8c061e86a76b@google.com/
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/squashfs/inode.c~squashfs-sanity-check-symbolic-link-size
+++ a/fs/squashfs/inode.c
@@ -279,8 +279,13 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
+		if (inode->i_size > PAGE_SIZE) {
+			ERROR("Corrupted symlink\n");
+			return -EINVAL;
+		}
+
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_symlink_inode_ops;
 		inode_nohighmem(inode);
 		inode->i_data.a_ops = &squashfs_symlink_aops;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


