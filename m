Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC51142640
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484679; cv=none; b=WZ0lzWs3z4mJYX4pCNDLrI7kFfpFmQ3sHGGkTWdRyAINQ0b3Vm+c9VO4n3ImCYiPhXkeVjTw+Rber8hLSyXZr9aQD8DNrP5JKrXXGvhwwWeYlS7ZD3G0qMO+f45Ffo/webky2FsFCQJInrZhPCvWckxKH/YUyWDLBXeYRg2wxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484679; c=relaxed/simple;
	bh=rtc6VxEP3tuxTSRI6SCHfhL8eggZtWhjesCJZV+KpZ4=;
	h=Date:To:From:Subject:Message-Id; b=O30UU5dgnaH/u4tRkjtYMIj3ikKP+06hNehKblVZ3IoRteGneO0yJPWTyzG/QlZQXtV44miE83lpiO65Ie2V0xese2czi8r72csBOymRGex/0vzqHGx4M0MyFHG5/x1knK30QBQrooXiTE6YdqJA6iKcwKT2w6gWkdUeExHzsbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v9Xqghg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v9Xqghg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29F9C433B2;
	Tue, 26 Mar 2024 20:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711484678;
	bh=rtc6VxEP3tuxTSRI6SCHfhL8eggZtWhjesCJZV+KpZ4=;
	h=Date:To:From:Subject:From;
	b=v9Xqghg8PYmhvYnsXNHmPB7du1jDhFyoDjsxp2cSoa3XyCq+uQzo1Vp9iT8WFw2gr
	 5IGvZ5PeLk1v54Ep2nF2AePRud3Defej/3so1SgDvtosm4ycnR4fMG0ke09iH1yIPm
	 H5sUZn6VAZYemmjAqrqkFKA8HKckGvP1sKkCVIPc=
Date: Tue, 26 Mar 2024 13:24:38 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rdunlap@infradead.org,peterz@infradead.org,ndesaulniers@google.com,axboe@kernel.dk,jsperbeck@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-open-output-files-from-cpio-unpacking-with-o_largefile.patch added to mm-hotfixes-unstable branch
Message-Id: <20240326202438.A29F9C433B2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: open output files from cpio unpacking with O_LARGEFILE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-open-output-files-from-cpio-unpacking-with-o_largefile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-open-output-files-from-cpio-unpacking-with-o_largefile.patch

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

init-open-output-files-from-cpio-unpacking-with-o_largefile.patch

