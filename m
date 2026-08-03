Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57DE433BD4
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 19:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785784296; cv=none; b=Vc0/eQeWwFzPCLQa5OU8HTamUeS60/To+DIHWbg5FfBhqch8NkokqPlZJ9sthsZcjN1RUn4ixd2VHTXncwgf03dOcNCZXYg9rBoxJOeL0bmrz2DUmUC8ObmB7UXXBtmvo8RG0q0/rerKpU3W+sRz4ASX+3AygA71VKIctuPS638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785784296; c=relaxed/simple;
	bh=JGUi8pAeJOWO2LGBFTnzdeDrbLV0B7tsMvv9bLb41Ik=;
	h=Date:To:From:Subject:Message-Id; b=JgxeH7RvX6I76bBbn/EMGLHxkhmg+tzJHcLPE4IDHicC8wyiCiRGaxa8HQgLz4aKVovVKCb/qEhOO8xBdv1qK+ZIEibS7dh5CUcb8DO9PojaznFvGtyqBwjsyWQTMDgPlb+roC0+66oq6QO/hFizi97yTySvBMy/2H/1Yv18f54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pVuUIl89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pVuUIl89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6AB1F000E9;
	Mon,  3 Aug 2026 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785784294;
	bh=ZaeON9K0F1m75lYDNpLmyqm9AV1XfBfa3jYio7WGHo4=;
	h=Date:To:From:Subject;
	b=pVuUIl892HZ53XREteQ4JFhmItDOwcnqIVikeRo1GXN7qFBms8MsHZbrgpzDRqTkO
	 OB7PsZQ4a9PDni2OowigpDTw6ckKkGbh1286BQfkc+4OUiu0q+BxE88obeRTKB/mjZ
	 VMOENqC0vLzDqZksgQTArY+eteoWUGgZKqQNxBgw=
Date: Mon, 03 Aug 2026 12:11:33 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch removed from -mm tree
Message-Id: <20260803191134.0E6AB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: reject swapon() on filesystem-level encrypted files
has been removed from the -mm tree.  Its filename was
     mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Eric Biggers <ebiggers@kernel.org>
Subject: mm/swap: reject swapon() on filesystem-level encrypted files
Date: Thu, 30 Jul 2026 11:48:53 -0700

ext4 and f2fs don't prevent filesystem-level encrypted files from being
set up directly as swap files.  In this case, encryption is bypassed.

No one should be doing this, vs.  the methods of encrypted swap that
actually do work (such as swapping to a dm-crypt device, or swapping to a
loopback device on top of a filesystem-level encrypted file).

Nevertheless, to prevent user error, make swapon() explicitly reject this
case.  Document this behavior in fscrypt.rst as well.

Link: https://lore.kernel.org/20260730184853.48347-1-ebiggers@kernel.org
Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/fscrypt.rst |    4 ++++
 mm/swapfile.c                         |    4 ++++
 2 files changed, 8 insertions(+)

--- a/Documentation/filesystems/fscrypt.rst~mm-swap-reject-swapon-on-filesystem-level-encrypted-files
+++ a/Documentation/filesystems/fscrypt.rst
@@ -1238,6 +1238,10 @@ astute users may notice some differences
 
 - DAX (Direct Access) is not supported on encrypted files.
 
+- Encrypted files cannot be used directly as swap files.  To swap to
+  an encrypted file, set up a loopback device on top of it.
+  Alternatively, encrypted swap can use a dm-crypt device instead.
+
 - The maximum length of an encrypted symlink is 2 bytes shorter than
   the maximum length of an unencrypted symlink.  For example, on an
   EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
--- a/mm/swapfile.c~mm-swap-reject-swapon-on-filesystem-level-encrypted-files
+++ a/mm/swapfile.c
@@ -3662,6 +3662,10 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
 	}
+	if (IS_ENCRYPTED(inode)) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 
 	/*
 	 * The swap subsystem needs a major overhaul to support this.
_

Patches currently in -mm which might be from ebiggers@kernel.org are


