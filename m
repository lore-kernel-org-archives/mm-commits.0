Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390EA2DA74C;
	Tue, 12 Aug 2025 01:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754963812; cv=none; b=R3fCIipoOMvrZOm33BJMEUK4MN1hC6E119Fxn4bDT5Ifbry9pv+OyNEa2ZRDg++d6uxxeQl4p3aKTupS85vp7KFhJ3fI1wrhRLk/1NCJ64LRxN4xQDBUuETv0e51xvOjYMY9ilmosotqMEt4MJi5RR2QVEp5sK+YXc4IcSE99Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754963812; c=relaxed/simple;
	bh=nPJ+D6VLQgNOGB9tKlzv1fe8eZuGbvLOxXcRWR8mwpc=;
	h=Date:To:From:Subject:Message-Id; b=HU80uuMZkEr47xG4Vu12ztwp0AWu1QkorG0YRcT4tMMnaCqQ31C99kMGP5uo9EJbn7QVacjjcdiBbqKGhVzFtH+VGuVfWK2ZoEchEmH3y6Lw10fZWN1rYjQreCVuMef/yiT6JQJ0AY8i4XBlLv3RdI+PtyfF2vFlbKXCqFbzyss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2cb1cXuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2cb1cXuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19DBC4CEED;
	Tue, 12 Aug 2025 01:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754963811;
	bh=nPJ+D6VLQgNOGB9tKlzv1fe8eZuGbvLOxXcRWR8mwpc=;
	h=Date:To:From:Subject:From;
	b=2cb1cXuwXKrdV7nQB9lswz10mSyab7KQNaPI0tQmbMKhT+pdqAVvV0WhkMy2YkKEj
	 YG/Sy+evVDwry2VVdTL0EUoIKDKJscDciSKje8fZZ+0X/smubln1BSMjZKkZu3Z9JO
	 EunOOYvcRDxhT8+zHaLluee5ITT+XG3PeeWJoQeM=
Date: Mon, 11 Aug 2025 18:56:51 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,jack@suse.cz,brauner@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-handle-bootloader-identifier-in-kernel-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20250812015651.B19DBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: handle bootloader identifier in kernel parameters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-handle-bootloader-identifier-in-kernel-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-handle-bootloader-identifier-in-kernel-parameters.patch

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
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: init: handle bootloader identifier in kernel parameters
Date: Mon, 21 Jul 2025 18:13:43 +0800

BootLoader (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
/boot/vmlinuz-x.y.z" to kernel parameters.  But these identifiers are not
recognized by the kernel itself so will be passed to user space.  However
user space init program also doesn't recognized it.

KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" on
some architectures.

We cannot change BootLoader's behavior, because this behavior exists for
many years, and there are already user space programs search BOOT_IMAGE=
in /proc/cmdline to obtain the kernel image locations:

https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
(search getBootOptions)
https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
(search getKernelReleaseWithBootOption)

So the the best way is handle (ignore) it by the kernel itself, which can
avoid such boot warnings (if we use something like init=/bin/bash,
bootloader identifier can even cause a crash):

Kernel command line: BOOT_IMAGE=(hd0,1)/vmlinuz-6.x root=/dev/sda3 ro console=tty
Unknown kernel command line parameters "BOOT_IMAGE=(hd0,1)/vmlinuz-6.x", will be passed to user space.

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
+		if (!strncmp(param, bootloader[i], strlen(bootloader[i])))
+			return 0;
+	}
+
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
 		return 0;
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

init-handle-bootloader-identifier-in-kernel-parameters.patch

