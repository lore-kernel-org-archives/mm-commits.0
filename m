Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E7541C78
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 20:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i3moxSez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7716EC433C8;
	Fri,  8 Dec 2023 20:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702066149;
	bh=YXa0UuKVwRKcPAI4JproqfrcSrj+T7g3YMOgjqeAUNc=;
	h=Date:To:From:Subject:From;
	b=i3moxSezF4AIFCDWR2iK80tIG33xfvds1Va666J+O+BJv870LPSB78mqmsJIZFzh4
	 m7bZADEKfrmXHywgxagW0/OVXOceu2crwNgIhNTer/SuIRvCLbEKCzSVMkD0PkyoAZ
	 jXToXF58lzYVaGunwYl1piI1vP+SBQkmCJ84y28w=
Date: Fri, 08 Dec 2023 12:09:08 -0800
To: mm-commits@vger.kernel.org,jschoenh@amazon.de,jgowans@amazon.com,gregkh@linuxfoundation.org,corbet@lwn.net,bagasdotme@gmail.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-expose-retained-initrd-as-sysfs-file.patch added to mm-nonmm-unstable branch
Message-Id: <20231208200909.7716EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: initramfs: expose retained initrd as sysfs file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     initramfs-expose-retained-initrd-as-sysfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/initramfs-expose-retained-initrd-as-sysfs-file.patch

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
From: Alexander Graf <graf@amazon.com>
Subject: initramfs: expose retained initrd as sysfs file
Date: Thu, 7 Dec 2023 23:56:54 +0000

When the kernel command line option "retain_initrd" is set, we do not free
the initrd memory.  However, we also don't expose it to anyone for
consumption.  That leaves us in a weird situation where the only user of
this feature is ppc64 and arm64 specific kexec tooling.

To make it more generally useful, this patch adds a kobject to the
firmware object that contains the initrd context when "retain_initrd" is
set.  That way, we can access the initrd any time after boot from user
space and for example hand it into kexec as --initrd parameter if we want
to reboot the same initrd.  Or inspect it directly locally.

With this patch applied, there is a new /sys/firmware/initrd file when the
kernel was booted with an initrd and "retain_initrd" command line option
is set.

Link: https://lkml.kernel.org/r/20231207235654.16622-1-graf@amazon.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jan H. Schönherr <jschoenh@amazon.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-firmware-initrd |    8 ++++++
 Documentation/admin-guide/kernel-parameters.txt |    5 ++-
 init/initramfs.c                                |   18 +++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-firmware-initrd
@@ -0,0 +1,8 @@
+What:		/sys/firmware/initrd
+Date:		December 2023
+Contact:	Alexander Graf <graf@amazon.com>
+Description:
+		When the kernel was booted with an initrd and the
+		"retain_initrd" option is set on the kernel command
+		line, /sys/firmware/initrd contains the contents of the
+		initrd that the kernel was booted with.
--- a/Documentation/admin-guide/kernel-parameters.txt~initramfs-expose-retained-initrd-as-sysfs-file
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2438,7 +2438,7 @@
 			between unregistering the boot console and initializing
 			the real console.
 
-	keepinitrd	[HW,ARM]
+	keepinitrd	[HW,ARM] See retain_initrd.
 
 	kernelcore=	[KNL,X86,IA-64,PPC]
 			Format: nn[KMGTPE] | nn% | "mirror"
@@ -5580,7 +5580,8 @@
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
 
-	retain_initrd	[RAM] Keep initrd memory after extraction
+	retain_initrd	[RAM] Keep initrd memory after extraction. After boot, it will
+			be accessible via /sys/firmware/initrd.
 
 	retbleed=	[X86] Control mitigation of RETBleed (Arbitrary
 			Speculative Code Execution with Return Instructions)
--- a/init/initramfs.c~initramfs-expose-retained-initrd-as-sysfs-file
+++ a/init/initramfs.c
@@ -574,6 +574,16 @@ extern unsigned long __initramfs_size;
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
+static ssize_t raw_read(struct file *file, struct kobject *kobj,
+			struct bin_attribute *attr, char *buf,
+			loff_t pos, size_t count)
+{
+	memcpy(buf, attr->private + pos, count);
+	return count;
+}
+
+static BIN_ATTR(initrd, 0440, raw_read, NULL, 0);
+
 void __init reserve_initrd_mem(void)
 {
 	phys_addr_t start;
@@ -715,8 +725,14 @@ done:
 	 * If the initrd region is overlapped with crashkernel reserved region,
 	 * free only memory that is not part of crashkernel region.
 	 */
-	if (!do_retain_initrd && initrd_start && !kexec_free_initrd())
+	if (!do_retain_initrd && initrd_start && !kexec_free_initrd()) {
 		free_initrd_mem(initrd_start, initrd_end);
+	} else if (do_retain_initrd && initrd_start) {
+		bin_attr_initrd.size = initrd_end - initrd_start;
+		bin_attr_initrd.private = (void *)initrd_start;
+		if (sysfs_create_bin_file(firmware_kobj, &bin_attr_initrd))
+			pr_err("Failed to create initrd sysfs file");
+	}
 	initrd_start = 0;
 	initrd_end = 0;
 
_

Patches currently in -mm which might be from graf@amazon.com are

initramfs-expose-retained-initrd-as-sysfs-file.patch

