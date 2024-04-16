Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFB91E511;
	Tue, 16 Apr 2024 22:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307230; cv=none; b=K9Bstu/pAMz4F4PcF9Mh66r8fe08wFe5QwYiBrACR3RSZ9NMc+zOGHiWGofuYFb7j4bf9XrX1u4Q0NxslEfurn15YlvZNDkNzdoQO7+8nf2+jZQBTRv2g04LoDABpE4eQIulb2w4WS5ivpVKZOY4svtM5w2O1welTEUevANt2zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307230; c=relaxed/simple;
	bh=t+jMpNmECFKlhD0J7TS0k+ybKzz7fE8W0bhykhgU75Y=;
	h=Date:To:From:Subject:Message-Id; b=T47P7HMPtge1jTsketvajtDuJ666pYNe4e31B15Uqjp2//mxgr/IZ075aIELVIDxz3sJso/wX3qtZieneH0/USdPLDO9LgCNr8zSLwzUPy/BrmCEkfYZuAqWtFwGuLnPaoTIINIoPrNaEc+7SwqmjSkV/ZNAuCNGviDbhhMnMe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KjOmauOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KjOmauOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D816C113CE;
	Tue, 16 Apr 2024 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307229;
	bh=t+jMpNmECFKlhD0J7TS0k+ybKzz7fE8W0bhykhgU75Y=;
	h=Date:To:From:Subject:From;
	b=KjOmauOYp+h7l5SbzaoRv38pHDtZAFbW6NcWgMVYEJoa38dOx5mAVOFMB0hbqzg48
	 DweSHY8I2aZ8PeEatVMtHkXJICAp1j42wGExuGqro+LDuTTAZX1yB0Zd0G1mpnrrZ3
	 pLjh3hNpDqvcxI4J8v/1c3Z26ZLNq8kq6L/rFh9A=
Date: Tue, 16 Apr 2024 15:40:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,bugreport@ubisectech.com,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch removed from -mm tree
Message-Id: <20240416224029.5D816C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: check the inode number is not the invalid value of zero
has been removed from the -mm tree.  Its filename was
     squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check the inode number is not the invalid value of zero
Date: Mon, 8 Apr 2024 23:02:06 +0100

Syskiller has produced an out of bounds access in fill_meta_index().

That out of bounds access is ultimately caused because the inode
has an inode number with the invalid value of zero, which was not checked.

The reason this causes the out of bounds access is due to following
sequence of events:

1. Fill_meta_index() is called to allocate (via empty_meta_index())
   and fill a metadata index.  It however suffers a data read error
   and aborts, invalidating the newly returned empty metadata index.
   It does this by setting the inode number of the index to zero,
   which means unused (zero is not a valid inode number).

2. When fill_meta_index() is subsequently called again on another
   read operation, locate_meta_index() returns the previous index
   because it matches the inode number of 0.  Because this index
   has been returned it is expected to have been filled, and because
   it hasn't been, an out of bounds access is performed.

This patch adds a sanity check which checks that the inode number
is not zero when the inode is created and returns -EINVAL if it is.

[phillip@squashfs.org.uk: whitespace fix]
  Link: https://lkml.kernel.org/r/20240409204723.446925-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20240408220206.435788-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: "Ubisectech Sirius" <bugreport@ubisectech.com>
Closes: https://lore.kernel.org/lkml/87f5c007-b8a5-41ae-8b57-431e924c5915.bugreport@ubisectech.com/
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/squashfs/inode.c~squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero
+++ a/fs/squashfs/inode.c
@@ -48,6 +48,10 @@ static int squashfs_new_inode(struct sup
 	gid_t i_gid;
 	int err;
 
+	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
+	if (inode->i_ino == 0)
+		return -EINVAL;
+
 	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &i_uid);
 	if (err)
 		return err;
@@ -58,7 +62,6 @@ static int squashfs_new_inode(struct sup
 
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
-	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
 	inode_set_mtime(inode, le32_to_cpu(sqsh_ino->mtime), 0);
 	inode_set_atime(inode, inode_get_mtime_sec(inode), 0);
 	inode_set_ctime(inode, inode_get_mtime_sec(inode), 0);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

