From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 initrdmem=-option-to-specify-initrd-physical-address.patch added to -mm
 tree
Date: Mon, 20 Apr 2020 20:58:09 -0700
Message-ID: <20200421035809.V-kZk5iEO%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDUD6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 23:58:11 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, hpa@zytor.com, mingo@redhat.com, mjg59@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, rminnich@gmail.com, tglx@linutronix.de


The patch titled
     Subject: initrdmem= option to specify initrd physical address
has been added to the -mm tree.  Its filename is
     initrdmem=-option-to-specify-initrd-physical-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initrdmem%3D-option-to-specify-initrd-physical-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initrdmem%3D-option-to-specify-initrd-physical-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ron minnich <rminnich@gmail.com>
Subject: initrdmem= option to specify initrd physical address

This patch adds the initrdmem option:

initrdmem=ss[KMG],nn[KMG]

which is used to specify the physical address of the initrd, almost always
an address in FLASH.  It also adds code for x86 to use the existing
phys_init_start and phys_init_size variables in the kernel.  This is
useful in cases where we wish to place a kernel and initrd in FLASH, but
there is no firmware file system structure in the FLASH.

One such situation occurs when we have reclaimed unused FLASH space on
UEFI systems by, e.g., taking it from the Management Engine.  For example,
on many systems, the ME is given half the FLASH part; not only is 2.75M of
an 8M part unused; but 10.75M of a 16M part is unused.  We can use this
space to contain an initrd, but need to tell Linux where it is.

This space is "raw": due to, e.g., UEFI limitations: it can not be added
to UEFI firmware volumes without rebuilding UEFI from source or writing a
UEFI device driver.  We can reference it only as a physical address and
size.

At the same time, should we netboot a kernel or load it from GRUB or
syslinux, we want to have the option of not using the physical address
specification.  Then, should we wish, it is easy to boot the kernel and
provide an initrd; or boot the the kernel and let it use the initrd in
FLASH.  In practice this has proven to be very helpful as we integrate
Linux into FLASH on x86.

Hence, the most flexible and convenient path is to enable the initrdmem
command line flag in a way that it is the last choice tried.

For example, on the DigitalLoggers Atomic Pi, we burn an image into FLASH
with a built-in command line which includes:

initrdmem=0xff968000,0x200000
which specifies a location and size.

Link: http://lkml.kernel.org/r/CAP6exYLK11rhreX=6QPyDQmW7wPHsKNEFtXE47pjx41xS6O7-A@mail.gmail.com
Signed-off-by: Ronald G. Minnich <rminnich@gmail.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 +++++++
 arch/x86/kernel/setup.c                         |    6 ++++++
 init/do_mounts_initrd.c                         |   13 ++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c~initrdmem=-option-to-specify-initrd-physical-address
+++ a/arch/x86/kernel/setup.c
@@ -237,6 +237,9 @@ static u64 __init get_ramdisk_image(void
 
 	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
 
+    if (ramdisk_image == 0) {
+        ramdisk_image = phys_initrd_start;
+    }
 	return ramdisk_image;
 }
 static u64 __init get_ramdisk_size(void)
@@ -245,6 +248,9 @@ static u64 __init get_ramdisk_size(void)
 
 	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
 
+    if (ramdisk_size == 0) {
+        ramdisk_size = phys_initrd_size;
+    }
 	return ramdisk_size;
 }
 
--- a/Documentation/admin-guide/kernel-parameters.txt~initrdmem=-option-to-specify-initrd-physical-address
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1762,6 +1762,13 @@
 
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
+    initrdmem=    [KNL] Specify a physical adddress and size from which
+            to load the initrd. If an initrd is compiled in or
+            specified in the bootparams, it takes priority
+            over this setting.
+            Format: ss[KMG],nn[KMG]
+            Default is 0, 0
+
 	init_on_alloc=	[MM] Fill newly allocated pages and heap objects with
 			zeroes.
 			Format: 0 | 1
--- a/init/do_mounts_initrd.c~initrdmem=-option-to-specify-initrd-physical-address
+++ a/init/do_mounts_initrd.c
@@ -28,7 +28,7 @@ static int __init no_initrd(char *str)
 
 __setup("noinitrd", no_initrd);
 
-static int __init early_initrd(char *p)
+static int __init early_initrdmem(char *p)
 {
 	phys_addr_t start;
 	unsigned long size;
@@ -43,6 +43,17 @@ static int __init early_initrd(char *p)
 	}
 	return 0;
 }
+early_param("initrdmem", early_initrdmem);
+
+/*
+ * This is here as the initrd keyword has been in use since 11/2018
+ * on ARM, PowerPC, and MIPS.
+ * It should not be; it is reserved for bootloaders.
+ */
+static int __init early_initrd(char *p)
+{
+    return early_initrdmem(p);
+}
 early_param("initrd", early_initrd);
 
 static int init_linuxrc(struct subprocess_info *info, struct cred *new)
_

Patches currently in -mm which might be from rminnich@gmail.com are

initrdmem=-option-to-specify-initrd-physical-address.patch
