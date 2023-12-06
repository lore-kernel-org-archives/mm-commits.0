Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462FDC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 20:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379448AbjLFUAt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 15:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379442AbjLFUAs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 15:00:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7471FA
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 12:00:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526EAC433C7;
        Wed,  6 Dec 2023 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701892854;
        bh=0wM7fUj/3k71WAUpFtnz5GKFTKcpSfwvXaIxhgIlmT0=;
        h=Date:To:From:Subject:From;
        b=1KcBwktEYuHWFr9dbTCmnvpiXZLxfh/P6wenoZeOB+UKGelAdZ3s6wSJiqod7Sn8j
         LMUm9WWFSZ+wdkBYvLo5LDKGd5KA4ArYlmTVIZ67nKzyQL3A3363aDu4JYxNdin0Pz
         LsR1JZAB9fdtvA+Qj9SZ966npjici1sT+pOGhZx8=
Date:   Wed, 06 Dec 2023 12:00:53 -0800
To:     mm-commits@vger.kernel.org, jschoenh@amazon.de, jgowans@amazon.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, graf@amazon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-expose-retained-initrd-as-sysfs-file.patch added to mm-nonmm-unstable branch
Message-Id: <20231206200054.526EAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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
Date: Wed, 6 Dec 2023 14:16:27 +0000

When the kernel command line option "retain_initrd" is set, we do not
free the initrd memory. However, we also don't expose it to anyone for
consumption. That leaves us in a weird situation where the only user of
this feature is ppc64 and arm64 specific kexec tooling.

To make it more generally useful, this patch adds a kobject to the
firmware object that contains the initrd context when "retain_initrd"
is set. That way, we can access the initrd any time after boot from
user space and for example hand it into kexec as --initrd parameter
if we want to reboot the same initrd. Or inspect it directly locally.

Link: https://lkml.kernel.org/r/20231206141627.91659-1-graf@amazon.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jan H. Schönherr <jschoenh@amazon.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 ++-
 init/initramfs.c                                |   18 +++++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

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

initramfs-expose-retained-initrd-as-sysfs-file.patch

