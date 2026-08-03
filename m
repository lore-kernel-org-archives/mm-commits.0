Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F392AD2E;
	Mon,  3 Aug 2026 19:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785784370; cv=none; b=tyjkTKNSePnaMqJhds8T9mBZ2XHtxLiXc2g8Y/PpHdXhkHIuqBphcxcOBlBtOUUhYQicjvjF2BA1iq6niM85oNhqoqN3wT4xqSblb2DxVSrkLyfT98XdwrZlXhXQ/7XYjcd2hQBKBx5tA3JacglYYjo4uipyzAX/ESi578ZV0Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785784370; c=relaxed/simple;
	bh=sDWYuRIXpUIXQf4esRiK8ldvZMiot7yDH632UHvGfy4=;
	h=Date:To:From:Subject:Message-Id; b=cSZJfuCMrAVB6e/dIqlWUMpAa06F6CJvJ6iQi7Kc4EdTRUa+09vMdDNGQGWsaAJ3hdxIwi1G/Gmc+/wAiu9XNGc8rDGz4iB34CSGXUcYtoFwtp9/nxxxbQxDNQQVNit2OkTezuSAh+DHKaWZwQOqzW1co8vQBEFrDb7Sx/xG6vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgHynVzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgHynVzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17571F000E9;
	Mon,  3 Aug 2026 19:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785784369;
	bh=rA+2H2GMANWQ5HD6HnzxVnOSMh0XvfaxGrpJZ5eG/WM=;
	h=Date:To:From:Subject;
	b=IgHynVzdoO0SYMJassefiUM4psqm0+2dVrJ1H+vQWIFPcSFKwT/VJIhKudF4DL5sY
	 HHECf6eBm/U6jJnGMJ8KCbuXrBcVrytQxcdc3wRAInIbGPolb1UoNEKuM+9X0sLS3D
	 angdF30EMQIK2ilGXeghH5sKZ1jAPOiQ6hETLASE=
Date: Mon, 03 Aug 2026 12:12:48 -0700
To: mm-commits@vger.kernel.org,usama.anjum@arm.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch added to mm-unstable branch
Message-Id: <20260803191248.E17571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: reject swapon() on filesystem-level encrypted files
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -3662,6 +3662,13 @@ SYSCALL_DEFINE2(swapon, const char __use
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

mm-swap-reject-swapon-on-filesystem-level-encrypted-files.patch

