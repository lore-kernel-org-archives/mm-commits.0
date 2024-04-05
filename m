Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4466B171072
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341329; cv=none; b=nkMYpMEeIdxobgZIpYPbTUFuX0mjFyTnGxmXP6/l9BueGeFDbPjWQH2bBhyuoYDyGlPga2pr5RTFtj6gJkWCPRN9i8B2FLsY3alMANkzUJuNWjQ9nV5k6GdzQ8LZDIAAQd0X9LKWbbgEMiACzLSYRqlAbCTKHJGJB7Yn11UGSaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341329; c=relaxed/simple;
	bh=ufvOWmmu02zYIJ7dIIW5UwG4fQGmtYzr+AZLxlQDT3Q=;
	h=Date:To:From:Subject:Message-Id; b=s423mt6LAtzgf+342zGFtix5SNXlgbNf0pDCXxYcWvpnbCnfrZPft4yjTJvckjiBsSQaKPVp3ttXNmZeAImYsChCVSDVvea1sfvdqZ1btmvaX6H8a/nApXlw7iaC2ft2TckPnQS+G5zQhRpTPgtRpvWAB3bGa8TjnS9KYk5n5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=npxBnyvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="npxBnyvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF37EC433C7;
	Fri,  5 Apr 2024 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341328;
	bh=ufvOWmmu02zYIJ7dIIW5UwG4fQGmtYzr+AZLxlQDT3Q=;
	h=Date:To:From:Subject:From;
	b=npxBnyvxhLP/c0dPeTRA7EjQDe0qGhuIfFnQcn87BHuCv6n5bDTMe/XT3d2d4i2uH
	 JOrc0dxRw8nFY9fgY15DQ0I40lgI76ioRMdMmYGmKYi5X+rBy4qU4B+VwPST/obRFQ
	 e63T+H8zHSgfR2ddtL0TXQ39zhDG8W7JdGhSkmwg=
Date: Fri, 05 Apr 2024 11:22:08 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rdunlap@infradead.org,peterz@infradead.org,ndesaulniers@google.com,axboe@kernel.dk,jsperbeck@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-open-output-files-from-cpio-unpacking-with-o_largefile.patch removed from -mm tree
Message-Id: <20240405182208.BF37EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: open output files from cpio unpacking with O_LARGEFILE
has been removed from the -mm tree.  Its filename was
     init-open-output-files-from-cpio-unpacking-with-o_largefile.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Sperbeck <jsperbeck@google.com>
Subject: init: open output files from cpio unpacking with O_LARGEFILE
Date: Sat, 23 Mar 2024 08:29:34 -0700

If a member of a cpio archive for an initrd or initrams is larger than
2Gb, we'll eventually fail to write to that file when we get to that
limit, unless O_LARGEFILE is set.

The problem can be seen with this recipe, assuming that BLK_DEV_RAM
is not configured:

cd /tmp
dd if=/dev/zero of=BIGFILE bs=1048576 count=2200
echo BIGFILE | cpio -o -H newc -R root:root > initrd.img
kexec -l /boot/vmlinuz-$(uname -r) --initrd=initrd.img --reuse-cmdline
kexec -e

The console will show 'Initramfs unpacking failed: write error'.  With
the patch, the error is gone.

Link: https://lkml.kernel.org/r/20240323152934.3307391-1-jsperbeck@google.com
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c~init-open-output-files-from-cpio-unpacking-with-o_largefile
+++ a/init/initramfs.c
@@ -367,7 +367,7 @@ static int __init do_name(void)
 	if (S_ISREG(mode)) {
 		int ml = maybe_link();
 		if (ml >= 0) {
-			int openflags = O_WRONLY|O_CREAT;
+			int openflags = O_WRONLY|O_CREAT|O_LARGEFILE;
 			if (ml != 1)
 				openflags |= O_TRUNC;
 			wfile = filp_open(collected, openflags, mode);
_

Patches currently in -mm which might be from jsperbeck@google.com are


