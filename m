From: akpm@linux-foundation.org
Subject: + init-wait-for-asynchronously-scanned-block-devices.patch added to -mm tree
Date: Thu, 31 May 2007 23:41:37 -0700
Message-ID: <200706010641.l516fa8D004373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376AbXFAGlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 02:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drzeus-list@drzeus.cx, drzeus@drzeus.cx, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     init: wait for asynchronously scanned block devices
has been added to the -mm tree.  Its filename is
     init-wait-for-asynchronously-scanned-block-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~init-wait-for-asynchronously-scanned-block-devices init/do_mounts.c
--- a/init/do_mounts.c~init-wait-for-asynchronously-scanned-block-devices
+++ a/init/do_mounts.c
@@ -25,6 +25,7 @@ int __initdata rd_doload;	/* 1 = load RA
 int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
+int __initdata root_wait;
 
 dev_t ROOT_DEV;
 
@@ -216,6 +217,14 @@ static int __init root_dev_setup(char *l
 
 __setup("root=", root_dev_setup);
 
+static int __init rootwait_setup(char *line)
+{
+	root_wait = simple_strtol(line,NULL,0);
+	return 1;
+}
+
+__setup("rootwait=", rootwait_setup);
+
 static char * __initdata root_mount_data;
 static int __init root_data_setup(char *str)
 {
@@ -438,11 +447,20 @@ void __init prepare_namespace(void)
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

init-wait-for-asynchronously-scanned-block-devices.patch
