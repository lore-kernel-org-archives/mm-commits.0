Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C01C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjLGW0D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjLGW0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:26:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E806D4A
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:26:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3880C433C8;
        Thu,  7 Dec 2023 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701987968;
        bh=TMXrEkN4qPzha81vTTBMnAOj7kU5SYYjcsaccaqitc0=;
        h=Date:To:From:Subject:From;
        b=W78hVJUPCQ8iJh94oNxBwUvtd/vpuEf2hSVUwxdhXXP6H/lIWbNukPRszU3Zsx4C6
         dPv+E33N77hATNTv8ULRrkvEu6SYjELxZO6xdQNcbBO/X+IVer//ivTW2VuW+ETdQQ
         DosE1NdEfriKCaenarVLLnnNlY9NTibzvgCOL3as=
Date:   Thu, 07 Dec 2023 14:26:07 -0800
To:     mm-commits@vger.kernel.org, jschoenh@amazon.de, jgowans@amazon.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, graf@amazon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] initramfs-expose-retained-initrd-as-sysfs-file.patch removed from -mm tree
Message-Id: <20231207222608.A3880C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: expose retained initrd as sysfs file
has been removed from the -mm tree.  Its filename was
     initramfs-expose-retained-initrd-as-sysfs-file.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alexander Graf <graf@amazon.com>
Subject: initramfs: expose retained initrd as sysfs file
Date: Wed, 6 Dec 2023 21:33:23 +0000

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

Link: https://lkml.kernel.org/r/20231206213323.78233-1-graf@amazon.com
Signed-off-by: Alexander Graf <graf@amazon.com>
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
+	} else if (do_retain_initrd) {
+		bin_attr_initrd.size = initrd_end - initrd_start;
+		bin_attr_initrd.private = (void *)initrd_start;
+		if (sysfs_create_bin_file(firmware_kobj, &bin_attr_initrd))
+			pr_err("Failed to create initrd sysfs file");
+	}
 	initrd_start = 0;
 	initrd_end = 0;
 
_

Patches currently in -mm which might be from graf@amazon.com are


