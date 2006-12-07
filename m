From: akpm@osdl.org
Subject: + add-retain_initrd-boot-option.patch added to -mm tree
Date: Wed, 06 Dec 2006 23:18:09 -0800
Message-ID: <200612070718.kB77I96p002039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031761AbWLGHSR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 02:18:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikey@neuling.org, rdunlap@xenotime.net


The patch titled
     Add retain_initrd boot option
has been added to the -mm tree.  Its filename is
     add-retain_initrd-boot-option.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add retain_initrd boot option
From: Michael Neuling <mikey@neuling.org>

Add retain_initrd option to control freeing of initrd memory after
extraction.  By default, free memory as previously.

The first boot will need to hold a copy of the in memory fs for the second
boot.  This image can be large (much larger than the kernel), hence we can
save time when the memory loader is slow.  Also, it reduces the memory
footprint while extracting the first boot since you don't need another copy
of the fs.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    2 ++
 init/initramfs.c                    |   17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~add-retain_initrd-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-retain_initrd-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -1394,6 +1394,8 @@ and is between 256 and 4096 characters. 
 			in <PAGE_SIZE> units (needed only for swap files).
 			See  Documentation/power/swsusp-and-swap-files.txt
 
+	retain_initrd	[RAM] Keep initrd memory after extraction
+
 	rhash_entries=	[KNL,NET]
 			Set number of hash buckets for route cache
 
diff -puN init/initramfs.c~add-retain_initrd-boot-option init/initramfs.c
--- a/init/initramfs.c~add-retain_initrd-boot-option
+++ a/init/initramfs.c
@@ -491,6 +491,17 @@ static char * __init unpack_to_rootfs(ch
 	return message;
 }
 
+static int do_retain_initrd;
+
+static int __init retain_initrd_param(char *str)
+{
+	if (*str)
+		return 0;
+	do_retain_initrd = 1;
+	return 1;
+}
+__setup("retain_initrd", retain_initrd_param);
+
 extern char __initramfs_start[], __initramfs_end[];
 #ifdef CONFIG_BLK_DEV_INITRD
 #include <linux/initrd.h>
@@ -501,7 +512,11 @@ static void __init free_initrd(void)
 #ifdef CONFIG_KEXEC
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);
+#endif
+	if (do_retain_initrd)
+		goto skip;
 
+#ifdef CONFIG_KEXEC
 	/*
 	 * If the initrd region is overlapped with crashkernel reserved region,
 	 * free only memory that is not part of crashkernel region.
@@ -519,7 +534,7 @@ static void __init free_initrd(void)
 	} else
 #endif
 		free_initrd_mem(initrd_start, initrd_end);
-
+skip:
 	initrd_start = 0;
 	initrd_end = 0;
 }
_

Patches currently in -mm which might be from mikey@neuling.org are

add-retain_initrd-boot-option.patch
add-retain_initrd-boot-option-tweak.patch

