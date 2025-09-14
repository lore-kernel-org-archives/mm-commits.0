Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF67428E0F;
	Sun, 14 Sep 2025 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810106; cv=none; b=a8jQzD1+NRo2yDPj+lteOoBh9KWTvXuX6VNqKpN/457376uKR32/QUGVCPO/ZH3ZOFp59xkbE8v+BF1088++AHvQcZvCP1635nAcEgluUa/HA3aMZOZUAM7aoCC05hEMaMsXlTmdzncFADMZOYpvxHo4sewvpgpxuhsrswVgbnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810106; c=relaxed/simple;
	bh=RfmBBnEUZX/mtqQMRZhsAJQ9NmUpgNJo5cG9xMSUOBo=;
	h=Date:To:From:Subject:Message-Id; b=b9GMhbSbcg/cqD6SPa1wbw+17FftmrBWdxN1eTMGHnyUE+BsceFS9bNdSaUrYM9ISZJlMR/3Kj10Qg29q4HRrctujceNlD7htMr106PzwIzWTLaihPERsGVxDdmU7ogvfmVt44bASbO51V7YeUAsXi57mN5WZPA5nLzUyImV0ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rcGVanUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rcGVanUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40A1C4CEF7;
	Sun, 14 Sep 2025 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810105;
	bh=RfmBBnEUZX/mtqQMRZhsAJQ9NmUpgNJo5cG9xMSUOBo=;
	h=Date:To:From:Subject:From;
	b=rcGVanUcG//Ev7L64JrPshiFQimUf021c3LmEnYLyCHMH/PuBpdJFWwIAq7Ow0r4C
	 lXD60YKpRLXy00cCtDlGWzJVl9OgBKAaqdVAuuTLC8GaozcyWIlAWauvGn7ctXRtyA
	 WuYQnluFMpywxb4ujrrSpwcdiV+ZQYuL25id+5Aw=
Date: Sat, 13 Sep 2025 17:35:05 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,jack@suse.cz,brauner@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-handle-bootloader-identifier-in-kernel-parameters.patch removed from -mm tree
Message-Id: <20250914003505.B40A1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: handle bootloader identifier in kernel parameters
has been removed from the -mm tree.  Its filename was
     init-handle-bootloader-identifier-in-kernel-parameters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: init: handle bootloader identifier in kernel parameters
Date: Mon, 21 Jul 2025 18:13:43 +0800

BootLoaders (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
/boot/vmlinuz-x.y.z" to kernel parameters.  But these identifiers are not
recognized by the kernel itself so will be passed to userspace.  However
user space init program also don't recognize it.

KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" on
some architectures.

We cannot change BootLoader's behavior, because this behavior exists for
many years, and there are already user space programs search BOOT_IMAGE=
in /proc/cmdline to obtain the kernel image locations:

https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
(search getBootOptions)
https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
(search getKernelReleaseWithBootOption) So the the best way is handle
(ignore) it by the kernel itself, which can avoid such boot warnings (if
we use something like init=/bin/bash, bootloader identifier can even cause
a crash):

Kernel command line: BOOT_IMAGE=(hd0,1)/vmlinuz-6.x root=/dev/sda3 ro console=tty
Unknown kernel command line parameters "BOOT_IMAGE=(hd0,1)/vmlinuz-6.x", will be passed to user space.

[chenhuacai@loongson.cn: use strstarts()]
  Link: https://lkml.kernel.org/r/20250815090120.1569947-1-chenhuacai@loongson.cn
Link: https://lkml.kernel.org/r/20250721101343.3283480-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/init/main.c~init-handle-bootloader-identifier-in-kernel-parameters
+++ a/init/main.c
@@ -544,6 +544,12 @@ static int __init unknown_bootoption(cha
 				     const char *unused, void *arg)
 {
 	size_t len = strlen(param);
+	/*
+	 * Well-known bootloader identifiers:
+	 * 1. LILO/Grub pass "BOOT_IMAGE=...";
+	 * 2. kexec/kdump (kexec-tools) pass "kexec".
+	 */
+	const char *bootloader[] = { "BOOT_IMAGE=", "kexec", NULL };
 
 	/* Handle params aliased to sysctls */
 	if (sysctl_is_alias(param))
@@ -551,6 +557,12 @@ static int __init unknown_bootoption(cha
 
 	repair_env_string(param, val);
 
+	/* Handle bootloader identifier */
+	for (int i = 0; bootloader[i]; i++) {
+		if (strstarts(param, bootloader[i]))
+			return 0;
+	}
+
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
 		return 0;
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are


