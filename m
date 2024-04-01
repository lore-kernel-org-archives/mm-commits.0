Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF2A482DF
	for <mm-commits@vger.kernel.org>; Mon,  1 Apr 2024 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991792; cv=none; b=X8aDfsIpg4rcz3MF+CGJW6T5UCuF47Fo2rLhdtjSlwCMuxP0t1agJCvcxQodswRb3hpXETm+b5HPfI83Egv/4nUjKW+uxi4O/GH28FLxEhEvOjRRQzUSOoQbTxdk51gXroc5ONNVcNaYGYq5kDDRG2A+8a6oHSXvNp+fna7DseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991792; c=relaxed/simple;
	bh=dj1Zi1X2rSIZ6uuL8yhpvAf+S+r1QR87Pumeg1rTQ3U=;
	h=Date:To:From:Subject:Message-Id; b=EfZU0VN9OdY8XC6NmRyz72IBTbNp3eOBfEvlr5tuv9hGX/gTk73UlXfYMdNi3VOuULzsYxLijzG22S3JB9d51MXFPwwNYEB6VaXJVT4S9T6O4ivM28ZeXrgFvdpB7COMGqDHwUt5n/HoYusDbwePDsYBMuUF2sRfpUzDaLpVeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qpw9R1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qpw9R1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0679AC433F1;
	Mon,  1 Apr 2024 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711991792;
	bh=dj1Zi1X2rSIZ6uuL8yhpvAf+S+r1QR87Pumeg1rTQ3U=;
	h=Date:To:From:Subject:From;
	b=0qpw9R1qo4cLVwIi4ZZAQCb8Nsxn9AYsRJr2UtXhqt4UP2hH/DcPXMc+cAcmIMYNu
	 wiIA/O8SXPOB8RAQ6hJD4vzesrIJIW/br3VWGvyEUMgJE6PRlby0QOFxVQiGwui3g3
	 vkh0IwRTI/x606MtliHwN9Ef9YRybe1qkB054Xu8=
Date: Mon, 01 Apr 2024 10:16:31 -0700
To: mm-commits@vger.kernel.org,j.granados@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch added to mm-nonmm-unstable branch
Message-Id: <20240401171632.0679AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: initrd: remove the now superfluous sentinel element from ctl_table array
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

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
From: Joel Granados <j.granados@samsung.com>
Subject: initrd: remove the now superfluous sentinel element from ctl_table array
Date: Thu, 28 Mar 2024 16:57:51 +0100

This commit comes at the tail end of a greater effort to remove the empty
elements at the end of the ctl_table arrays (sentinels) which will reduce
the overall build time size of the kernel and run time memory bloat by ~64
bytes per sentinel (further information Link :
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)

Remove sentinel from kern_do_mounts_initrd_table.

Link: https://lkml.kernel.org/r/20240328-jag-sysctl_remset_misc-v1-4-47c1463b3af2@samsung.com
Signed-off-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_initrd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/init/do_mounts_initrd.c~initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/init/do_mounts_initrd.c
@@ -29,7 +29,6 @@ static struct ctl_table kern_do_mounts_i
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
-	{ }
 };
 
 static __init int kernel_do_mounts_initrd_sysctls_init(void)
_

Patches currently in -mm which might be from j.granados@samsung.com are

memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch
initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

