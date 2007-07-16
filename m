From: akpm@linux-foundation.org
Subject: - init-wait-for-asynchronously-scanned-block-devices.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:39 -0700
Message-ID: <200707162055.l6GKtdIK001950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751AbXGPV1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drzeus-list@drzeus.cx, bunk@stusta.de, drzeus@drzeus.cx, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     init: wait for asynchronously scanned block devices
has been removed from the -mm tree.  Its filename was
     init-wait-for-asynchronously-scanned-block-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: init: wait for asynchronously scanned block devices
From: Pierre Ossman <drzeus-list@drzeus.cx>

Some buses (e.g.  USB and MMC) do their scanning of devices in the
background, causing a race between them and prepare_namespace().  In order
to be able to use these buses without an initrd, we now wait for the device
specified in root= to actually show up.

If the device never shows up than we will hang in an infinite loop.  In
order to not mess with setups that reboot on panic, the feature must be
turned on via the command line option "rootwait".

[bunk@stusta.de: root_wait can become static]
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++++
 init/do_mounts.c                    |   24 ++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~init-wait-for-asynchronously-scanned-block-devices Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~init-wait-for-asynchronously-scanned-block-devices
+++ a/Documentation/kernel-parameters.txt
@@ -1504,6 +1504,10 @@ and is between 256 and 4096 characters. 
 
 	rootfstype=	[KNL] Set root filesystem type
 
+	rootwait	[KNL] Wait (indefinitely) for root device to show up.
+			Useful for devices that are detected asynchronously
+			(e.g. USB and MMC devices).
+
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
diff -puN init/do_mounts.c~init-wait-for-asynchronously-scanned-block-devices init/do_mounts.c
--- a/init/do_mounts.c~init-wait-for-asynchronously-scanned-block-devices
+++ a/init/do_mounts.c
@@ -25,6 +25,7 @@ int __initdata rd_doload;	/* 1 = load RA
 int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
+static int __initdata root_wait;
 
 dev_t ROOT_DEV;
 
@@ -216,6 +217,16 @@ static int __init root_dev_setup(char *l
 
 __setup("root=", root_dev_setup);
 
+static int __init rootwait_setup(char *str)
+{
+	if (*str)
+		return 0;
+	root_wait = 1;
+	return 1;
+}
+
+__setup("rootwait", rootwait_setup);
+
 static char * __initdata root_mount_data;
 static int __init root_data_setup(char *str)
 {
@@ -438,11 +449,20 @@ void __init prepare_namespace(void)
 			root_device_name += 5;
 	}
 
-	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
-
 	if (initrd_load())
 		goto out;
 
+	/* wait for any asynchronous scanning to complete */
+	if ((ROOT_DEV == 0) && root_wait) {
+		printk(KERN_INFO "Waiting for root device %s...\n",
+			saved_root_name);
+		while (driver_probe_done() != 0 ||
+			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
+			msleep(100);
+	}
+
+	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
+
 	if (is_floppy && rd_doload && rd_load_disk(0))
 		ROOT_DEV = Root_RAM0;
 
_

Patches currently in -mm which might be from drzeus-list@drzeus.cx are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
