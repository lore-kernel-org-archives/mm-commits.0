From: akpm@linux-foundation.org
Subject: + frv-flash-mappings-for-the-mb93090-mb00-motherboard.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:13:04 -0700
Message-ID: <200909242213.n8OMD4xf022173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbZIXWNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dwmw2@infradead.org


The patch titled
     frv: flash mappings for the MB93090-MB00 motherboard
has been added to the -mm tree.  Its filename is
     frv-flash-mappings-for-the-mb93090-mb00-motherboard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: flash mappings for the MB93090-MB00 motherboard
From: David Howells <dhowells@redhat.com>

Flash mappings for the MB93090-MB00 evaluation motherboard.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/Makefile |    2 
 arch/frv/mb93090-mb00/flash.c  |   90 +++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff -puN arch/frv/mb93090-mb00/Makefile~frv-flash-mappings-for-the-mb93090-mb00-motherboard arch/frv/mb93090-mb00/Makefile
--- a/arch/frv/mb93090-mb00/Makefile~frv-flash-mappings-for-the-mb93090-mb00-motherboard
+++ a/arch/frv/mb93090-mb00/Makefile
@@ -11,3 +11,5 @@ else
 obj-y += pci-dma-nommu.o
 endif
 endif
+
+obj-$(CONFIG_MTD) += flash.o
diff -puN /dev/null arch/frv/mb93090-mb00/flash.c
--- /dev/null
+++ a/arch/frv/mb93090-mb00/flash.c
@@ -0,0 +1,90 @@
+/* Flash mappings for the MB93090-MB00 motherboard
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+
+#define MB93090_BOOTROM_ADDR	0xFF000000	/* Boot ROM */
+#define MB93090_BOOTROM_SIZE	(2 * 1024 * 1024)
+#define MB93090_USERROM_ADDR	0xFF200000	/* User ROM */
+#define MB93090_USERROM_SIZE	(2 * 1024 * 1024)
+
+/*
+ * default MTD partition table for both main flash devices, expected to be
+ * overridden by RedBoot
+ */
+static struct mtd_partition mb93090_partitions[] = {
+	{
+		.name		= "Filesystem",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= 0,
+	}
+};
+
+/*
+ * Definition of the MB93090 Boot ROM (on the CPU card)
+ */
+static struct physmap_flash_data mb93090_bootrom_data = {
+	.width		= 2,
+	.nr_parts	= 2,
+	.parts		= mb93090_partitions,
+};
+
+static struct resource mb93090_bootrom_resource = {
+	.start		= MB93090_BOOTROM_ADDR,
+	.end		= MB93090_BOOTROM_ADDR + MB93090_BOOTROM_SIZE - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device mb93090_bootrom = {
+	.name		= "physmap-flash",
+	.id		= 0,
+	.dev.platform_data = &mb93090_bootrom_data,
+	.num_resources	= 1,
+	.resource	= &mb93090_bootrom_resource,
+};
+
+/*
+ * Definition of the MB93090 User ROM definition (on the motherboard)
+ */
+static struct physmap_flash_data mb93090_userrom_data = {
+	.width		= 2,
+	.nr_parts	= 2,
+	.parts		= mb93090_partitions,
+};
+
+static struct resource mb93090_userrom_resource = {
+	.start		= MB93090_USERROM_ADDR,
+	.end		= MB93090_USERROM_ADDR + MB93090_USERROM_SIZE - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device mb93090_userrom = {
+	.name		= "physmap-flash",
+	.id		= 1,
+	.dev.platform_data = &mb93090_userrom_data,
+	.num_resources	= 1,
+	.resource	= &mb93090_userrom_resource,
+};
+
+/*
+ * register the MB93090 flashes
+ */
+static int __init mb93090_mtd_init(void)
+{
+	platform_device_register(&mb93090_bootrom);
+	platform_device_register(&mb93090_userrom);
+	return 0;
+}
+
+module_init(mb93090_mtd_init);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly.patch
frv-flash-mappings-for-the-mb93090-mb00-motherboard.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch

