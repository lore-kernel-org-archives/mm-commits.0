Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2436153587;
	Tue,  9 Apr 2024 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712689917; cv=none; b=OVhmwvlaJJTQzKMyWMunJogDD0v1OMARSQzyfjG0DufaxqgWXgrFVEx7dDM0/YdSmx6nfjCZCZYnrkl/jKWSVnKW1yxxrbBfA4MCDcL8PrZrRpoXPBlSGCBNu+GvaanHFWnlIPAc3Ff8MnIizFq5yDxwW7N+xOqziiTZ81gCpZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712689917; c=relaxed/simple;
	bh=R1nSz58tf2v/T5b/9sE+VidpxPictCXJf+alYVGWDVA=;
	h=Date:To:From:Subject:Message-Id; b=KOzzESQgnoj6Rrc/sO5pmd3hHZfuHXYfqXcthhuY9qfSiFu73pBI42yb69gPGtzMy8FAoye1J//diP9G+V+ci3Bm1sk2V7VpECxNfDlZUFD74E/y5YZ+knEgYWKJjPfANCQ7vC1/I54e9WNpFJESVDZhGui8ZXEOqSyKrQMqpzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iLVIzVdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iLVIzVdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22265C433C7;
	Tue,  9 Apr 2024 19:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712689917;
	bh=R1nSz58tf2v/T5b/9sE+VidpxPictCXJf+alYVGWDVA=;
	h=Date:To:From:Subject:From;
	b=iLVIzVdir8JdegVXrtD4D01ZHWgU3zRpDoyy1JG65upw+FysQNK4RwAWzbc1y7xzH
	 MFFe0bR1OzuhlIoUmTG7DAofIrxlm1K2WC7Nbvpw3m+6KmTMt2xj0/LzW9GAHr5UbB
	 KautthX7SQDyXAjnRf+ZfzqmJ+f/e3dUIuGLZTOE=
Date: Tue, 09 Apr 2024 12:11:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,bugreport@ubisectech.com,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch added to mm-hotfixes-unstable branch
Message-Id: <20240409191157.22265C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: check the inode number is not the invalid value of zero
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch

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
+	if(inode->i_ino == 0)
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

squashfs-check-the-inode-number-is-not-the-invalid-value-of-zero.patch
squashfs-remove-deprecated-strncpy-by-not-copying-the-string.patch

