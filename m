Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3A15624D
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 02:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744252013; cv=none; b=na6A/7ZcHJsUYFOmcPKrySVKQfxZg/SBTxLo5nu+UxzsdZY68NbkaiHSrlTlW27IKO2lTGvwgyb00p8Pgp1DoufT99H5n564HltEe2Uhnj3hyOTeM6Bm7VFnXhr3jcwSN87jzcz+8W+2+vuqYQWEDTr7OEUJ2p0vgDJi4xv9a6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744252013; c=relaxed/simple;
	bh=qXEW3qobDs/gu+m2o/DJho10sAlvsr72gr76mXRqgFA=;
	h=Date:To:From:Subject:Message-Id; b=FUOi2W7vRgfn47CZokmYxyXJlOB8cCzbSG2HNAEKX5oImPwn6p1f/wME+vfVC8EkQDdU7R47AjCeMZicsglatwahmVSBnP9o1B8Do5NKncw8SDWa5VIwZ2Zpqc2DjSM8tgjmosi/7ESk5ZrqpHoeVr6FZFpR/2VNknSZz5Ejsx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFZxgHRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFZxgHRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7DFC4CEE2;
	Thu, 10 Apr 2025 02:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744252012;
	bh=qXEW3qobDs/gu+m2o/DJho10sAlvsr72gr76mXRqgFA=;
	h=Date:To:From:Subject:From;
	b=IFZxgHRe2wrlI3nRX9Yg/nqqXQ2Z76cwOnG+cNiX5Imkp9d5O4mn0/TI+8mld0jG6
	 vS5lHdqOEeUhLbS4l3dVJgZDjL3c6199A29kfH1iQj85XZQYDr5sPmwpB3UMbWONIZ
	 mtg+nbIim4HjyhcINWkhbv+GGecVne8MGfP5pgcQ=
Date: Wed, 09 Apr 2025 19:26:52 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-return-result-of-sb_min_blocksize.patch added to mm-nonmm-unstable branch
Message-Id: <20250410022652.DC7DFC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: check return result of sb_min_blocksize
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-check-return-result-of-sb_min_blocksize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-return-result-of-sb_min_blocksize.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

squashfs-check-return-result-of-sb_min_blocksize.patch

