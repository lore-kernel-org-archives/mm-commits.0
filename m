Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6079A3438A7;
	Tue, 25 Aug 2026 01:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622821; cv=none; b=ceHubpyo9wWy6tOnDaqcl7RrhHKDuQvdHvG23fnLML9NSQpB0ZU+MGuF2X6Nw/INKSCH5b3Wu+mXV3XS1hqscAlm22HNwQfGo9PUxJJWLAMaGqI4vZLoT4YyxH8gD9OM3StiNOCcPaGz6wudgTXGcwPEcUH9oB6oZLTYZwPKUg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622821; c=relaxed/simple;
	bh=b9N/1SBhzI+GuXKGQ3aGVU4RU/IUCdRRr1qtdQBLLdU=;
	h=Date:To:From:Subject:Message-Id; b=n0/Y3ZJtwBQkNzlxo8aa91fMEOWhBC7erKdHqSx9JYc2yA5HGLUUMtEo+6nKRME0mnUYnmldRkTKaDynFRBcvCVO46Ia/1CRcvBbvZE6FmiQkcJPsNsl2AETrcOFPjtv3e4D3MfCLBX5wX4hQU05VdB+3+J9k/URUj0grWKhNEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ohWIIpS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohWIIpS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2957E1F000E9;
	Tue, 25 Aug 2026 01:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622820;
	bh=RM20fX2f429nnCNrsg7cC8ZTwJicC4yqz4F4M3rQM/s=;
	h=Date:To:From:Subject;
	b=ohWIIpS020pMM30wbmv7J54M8C5piCiLz5GRSMrY/O/Gwz4rWYXyRIiX60ri+CcgG
	 PtjOLVlF78LnEtIFy010iXHSmP7nJuoGC2fy7K6ZYB1h3riWHFHUuZWtweCK41/3lt
	 shfyTe6myM8TMnSb03Urb1R3LJGhbL9ZFvabBoPg=
Date: Mon, 24 Aug 2026 18:53:39 -0700
To: mm-commits@vger.kernel.org,usama.anjum@arm.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,djwong@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch removed from -mm tree
Message-Id: <20260825015340.2957E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: reject swapon() on filesystem-level encrypted files
has been removed from the -mm tree.  Its filename was
     mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Biggers <ebiggers@kernel.org>
Subject: mm/swap: reject swapon() on filesystem-level encrypted files
Date: Mon, 3 Aug 2026 11:04:26 -0700

ext4 and f2fs don't prevent filesystem-level encrypted files from being
set up directly as swap files.  In this case, encryption is bypassed.

No one should be doing this, vs.  the methods of encrypted swap that
actually do work (such as swapping to a dm-crypt device, or swapping to a
loopback device on top of a filesystem-level encrypted file).

Nevertheless, to prevent user error, make swapon() explicitly reject this
case.  Document this behavior in fscrypt.rst as well.

Link: https://lore.kernel.org/20260803180426.3123-1-ebiggers@kernel.org
Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/fscrypt.rst |    4 ++++
 mm/swapfile.c                         |    7 +++++++
 2 files changed, 11 insertions(+)

--- a/Documentation/filesystems/fscrypt.rst~mm-swap-reject-swapon-on-filesystem-level-encrypted-files
+++ a/Documentation/filesystems/fscrypt.rst
@@ -1238,6 +1238,10 @@ astute users may notice some differences
 
 - DAX (Direct Access) is not supported on encrypted files.
 
+- Encrypted files cannot be used directly as swap files.  To swap to
+  an encrypted file, set up a loopback device on top of it.
+  Alternatively, encrypted swap can use a dm-crypt device.
+
 - The maximum length of an encrypted symlink is 2 bytes shorter than
   the maximum length of an unencrypted symlink.  For example, on an
   EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
--- a/mm/swapfile.c~mm-swap-reject-swapon-on-filesystem-level-encrypted-files
+++ a/mm/swapfile.c
@@ -3668,6 +3668,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
 	}
+	if (IS_ENCRYPTED(inode)) {
+		pr_warn_once(
+			"Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n",
+			name->name);
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 
 	/*
 	 * The swap subsystem needs a major overhaul to support this.
_

Patches currently in -mm which might be from ebiggers@kernel.org are


