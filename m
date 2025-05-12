Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE562EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011355; cv=none; b=plPWgLzqScrIljjHugZpn8qQzxfwIsvyZGmnmelZEZQ475hMLl/V2f4NlF+F3p+Yy4lChG9LX23laLYg28MwMrtdDTXTpf8RBLR7yCEJVno3SKmcITfhnPbhu6ud2AJwGfZh5dQSPLkXFvGFf8SEFdelAeoFSMr1Myx8y0JEye4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011355; c=relaxed/simple;
	bh=J4Ni0Jdt/xH+ftj+o+bUxW9lrz/lSIpbEH2Hz/2xTXE=;
	h=Date:To:From:Subject:Message-Id; b=EIcvACLZf7eDOJ9GcIbyzkDXXNna3dN44zRb7QmZvNgy4UYbUvQGFsqSbvOb3jdhWQnJoi5F0+Druwg4jAI0Id1w/2peGJdcF6zMaUXW8tw6ZMwU6gABdXRDqCIHuW8St0rDsfZ0io0CUx8xy92iyRV3bA2J2wi9DqyJnwzYhnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SggDog84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SggDog84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA820C4CEE4;
	Mon, 12 May 2025 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011355;
	bh=J4Ni0Jdt/xH+ftj+o+bUxW9lrz/lSIpbEH2Hz/2xTXE=;
	h=Date:To:From:Subject:From;
	b=SggDog847vixSpf0MqFRUKdPFHpFTCTNWmL+YgmCMp74EdFEcALp0UwEiW4Bmb4Ce
	 H4VrtmVsu4EfQMnT6OqvPXCvPdhC03KB0Qq/29sVUCx27YSkMqMBqfI5iSbMdKMSRq
	 En1BYCuuZop1puGSuc4S/j5lrDhv6KZJCWqSvTk4=
Date: Sun, 11 May 2025 17:55:54 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-check-return-result-of-sb_min_blocksize.patch removed from -mm tree
Message-Id: <20250512005554.EA820C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: check return result of sb_min_blocksize
has been removed from the -mm tree.  Its filename was
     squashfs-check-return-result-of-sb_min_blocksize.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check return result of sb_min_blocksize
Date: Wed, 9 Apr 2025 03:47:47 +0100

Syzkaller reports an "UBSAN: shift-out-of-bounds in squashfs_bio_read" bug.

Syzkaller forks multiple processes which after mounting the Squashfs
filesystem, issues an ioctl("/dev/loop0", LOOP_SET_BLOCK_SIZE, 0x8000). 
Now if this ioctl occurs at the same time another process is in the
process of mounting a Squashfs filesystem on /dev/loop0, the failure
occurs.  When this happens the following code in squashfs_fill_super()
fails.

----
msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
msblk->devblksize_log2 = ffz(~msblk->devblksize);
----

sb_min_blocksize() returns 0, which means msblk->devblksize is set to 0.

As a result, ffz(~msblk->devblksize) returns 64, and msblk->devblksize_log2
is set to 64.

This subsequently causes the

UBSAN: shift-out-of-bounds in fs/squashfs/block.c:195:36
shift exponent 64 is too large for 64-bit type 'u64' (aka
'unsigned long long')

This commit adds a check for a 0 return by sb_min_blocksize().

Link: https://lkml.kernel.org/r/20250409024747.876480-1-phillip@squashfs.org.uk
Fixes: 0aa666190509 ("Squashfs: super block operations")
Reported-by: syzbot+65761fc25a137b9c8c6e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67f0dd7a.050a0220.0a13.0230.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/squashfs/super.c~squashfs-check-return-result-of-sb_min_blocksize
+++ a/fs/squashfs/super.c
@@ -202,6 +202,11 @@ static int squashfs_fill_super(struct su
 	msblk->panic_on_errors = (opts->errors == Opt_errors_panic);
 
 	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
+	if (!msblk->devblksize) {
+		errorf(fc, "squashfs: unable to set blocksize\n");
+		return -EINVAL;
+	}
+
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->meta_index_mutex);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


