From: akpm@linux-foundation.org
Subject: + blackfin-Documentation.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:24:31 -0800
Message-ID: <200702142124.l1ELOVAK009591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625AbXBNVYk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:24:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin: documentation
has been added to the -mm tree.  Its filename is
     blackfin-Documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin: documentation
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blackfin/00-INDEX          |   11 +
 Documentation/blackfin/Filesystems       |  169 +++++++++++++++++++++
 Documentation/blackfin/cache-lock.txt    |   48 +++++
 Documentation/blackfin/cachefeatures.txt |   65 ++++++++
 MAINTAINERS                              |   38 ++++
 5 files changed, 331 insertions(+)

diff -puN /dev/null Documentation/blackfin/00-INDEX
--- /dev/null
+++ a/Documentation/blackfin/00-INDEX
@@ -0,0 +1,11 @@
+00-INDEX
+	- This file
+
+cache-lock.txt
+	- HOWTO for blackfin cache locking.
+
+cachefeatures.txt
+	- Supported cache features.
+
+Filesystems
+	- Requirements for mounting the root file system.
diff -puN /dev/null Documentation/blackfin/Filesystems
--- /dev/null
+++ a/Documentation/blackfin/Filesystems
@@ -0,0 +1,169 @@
+/*
+ * File:         Documentation/blackfin/Filesystems
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for Blackfin
+ *
+ * Rev:          $Id: Filesystems 2384 2006-11-01 04:12:43Z magicyang $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ */
+
+		How to mount the root file system in uClinux/Blackfin
+		-----------------------------------------------------
+
+1	Mounting EXT3 File system.
+	------------------------
+
+	Creating an EXT3 File system for uClinux/Blackfin:
+
+
+Please follow the steps to form the EXT3 File system and mount the same as root
+file system.
+
+a	Make an ext3 file system as large as you want the final root file
+	system.
+
+		mkfs.ext3  /dev/ram0 <your-rootfs-size-in-1k-blocks>
+
+b	Mount this Empty file system on a free directory as:
+
+		mount -t ext3 /dev/ram0  ./test
+			where ./test is the empty directory.
+
+c	Copy your root fs directory that you have so carefully made over.
+
+		cp -af  /tmp/my_final_rootfs_files/* ./test
+
+		(For ex: cp -af uClinux-dist/romfs/* ./test)
+
+d	If you have done everything right till now you should be able to see
+	the required "root" dir's (that's etc, root, bin, lib, sbin...)
+
+e	Now unmount the file system
+
+		umount  ./test
+
+f	Create the root file system image.
+
+		dd if=/dev/ram0 bs=1k count=<your-rootfs-size-in-1k-blocks> \
+		> ext3fs.img
+
+
+Now you have to tell the kernel that will be mounting this file system as
+rootfs.
+So do a make menuconfig under kernel and select the Ext3 journaling file system
+support under File system --> submenu.
+
+
+2.	Mounting EXT2 File system.
+	-------------------------
+
+By default the ext2 file system image will be created if you invoke make from
+the top uClinux-dist directory.
+
+
+3.	Mounting CRAMFS File System
+	----------------------------
+
+To create a CRAMFS file system image execute the command
+
+	mkfs.cramfs ./test cramfs.img
+
+	where ./test is the target directory.
+
+
+4.	Mounting ROMFS File System
+	--------------------------
+
+To create a ROMFS file system image execute the command
+
+	genromfs -v -V "ROMdisk" -f romfs.img -d ./test
+
+	where ./test is the target directory
+
+
+5.	Mounting the JFFS2 Filesystem
+	-----------------------------
+
+To create a compressed JFFS filesystem (JFFS2), please execute the command
+
+	mkfs.jffs2 -d ./test -o jffs2.img
+
+	where ./test is the target directory.
+
+However, please make sure the following is in your kernel config.
+
+/*
+ * RAM/ROM/Flash chip drivers
+ */
+#define CONFIG_MTD_CFI 1
+#define CONFIG_MTD_ROM 1
+/*
+ * Mapping drivers for chip access
+ */
+#define CONFIG_MTD_COMPLEX_MAPPINGS 1
+#define CONFIG_MTD_BF533 1
+#undef CONFIG_MTD_UCLINUX
+
+Through the u-boot boot loader, use the jffs2.img in the corresponding
+partition made in linux-2.6.x/drivers/mtd/maps/bf533_flash.c.
+
+NOTE - 	Currently the Flash driver is available only for EZKIT. Watch out for a
+	STAMP driver soon.
+
+
+6. 	Mounting the NFS File system
+	-----------------------------
+
+	For mounting the NFS please do the following in the kernel config.
+
+	In Networking Support --> Networking options --> TCP/IP networking -->
+		IP: kernel level autoconfiguration
+
+	Enable BOOTP Support.
+
+	In Kernel hacking --> Compiled-in kernel boot parameter add the following
+
+		root=/dev/nfs rw ip=bootp
+
+	In File system --> Network File system, Enable
+
+		NFS file system support --> NFSv3 client support
+		Root File system on NFS
+
+	in uClibc menuconfig, do the following
+	In Networking Support
+		enable Remote Procedure Call (RPC) support
+			Full RPC Support
+
+	On the Host side, ensure that /etc/dhcpd.conf looks something like this
+
+		ddns-update-style ad-hoc;
+		allow bootp;
+		subnet 10.100.4.0 netmask 255.255.255.0 {
+		default-lease-time 122209600;
+		max-lease-time 31557600;
+		group {
+			host bf533 {
+				hardware ethernet 00:CF:52:49:C3:01;
+				fixed-address 10.100.4.50;
+				option root-path "/home/nfsmount";
+			}
+		}
+
+	ensure that /etc/exports looks something like this
+		/home/nfsmount *(rw,no_root_squash,no_all_squash)
+
+	 run the following commands as root (may differ depending on your
+	 distribution) :
+		-  service nfs start
+		-  service portmap start
+		-  service dhcpd start
+		-  /usr/sbin/exportfs
diff -puN /dev/null Documentation/blackfin/cache-lock.txt
--- /dev/null
+++ a/Documentation/blackfin/cache-lock.txt
@@ -0,0 +1,48 @@
+/*
+ * File:         Documentation/blackfin/cache-lock.txt
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for Blackfin
+ *
+ * Rev:          $Id: cache-lock.txt 2384 2006-11-01 04:12:43Z magicyang $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ */
+
+How to lock your code in cache in uClinux/blackfin
+--------------------------------------------------
+
+There are only a few steps required to lock your code into the cache.
+Currently you can lock the code by Way.
+
+Below are the interface provided for locking the cache.
+
+
+1. cache_grab_lock(int Ways);
+
+This function grab the lock for locking your code into the cache specified
+by Ways.
+
+
+2. cache_lock(int Ways);
+
+This function should be called after your critical code has been executed.
+Once the critical code exits, the code is now loaded into the cache. This
+function locks the code into the cache.
+
+
+So, the example sequence will be:
+
+	cache_grab_lock(WAY0_L);	/* Grab the lock */
+
+	critical_code();		/* Execute the code of interest */
+
+	cache_lock(WAY0_L);		/* Lock the cache */
+
+Where WAY0_L signifies WAY0 locking.
diff -puN /dev/null Documentation/blackfin/cachefeatures.txt
--- /dev/null
+++ a/Documentation/blackfin/cachefeatures.txt
@@ -0,0 +1,65 @@
+/*
+ * File:         Documentation/blackfin/cachefeatures.txt
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for Blackfin
+ *
+ * Rev:          $Id: cachefeatures.txt 2384 2006-11-01 04:12:43Z magicyang $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ */
+
+	- Instruction and Data cache initialization.
+		icache_init();
+		dcache_init();
+
+	-  Instruction and Data cache Invalidation Routines, when flushing the
+	   same is not required.
+		_icache_invalidate();
+		_dcache_invalidate();
+
+	Also, for invalidating the entire instruction and data cache, the below
+	routines are provided (another method for invalidation, refer page no 267 and 287 of
+	ADSP-BF533 Hardware Reference manual)
+
+		invalidate_entire_dcache();
+		invalidate_entire_icache();
+
+	-External Flushing of Instruction and data cache routines.
+
+		flush_instruction_cache();
+		flush_data_cache();
+
+	- Internal Flushing of Instruction and Data Cache.
+
+		icplb_flush();
+		dcplb_flush();
+
+	- Locking the cache.
+
+		cache_grab_lock();
+		cache_lock();
+
+	Please refer linux-2.6.x/Documentation/blackfin/cache-lock.txt for how to
+	lock the cache.
+
+	Locking the cache is optional feature.
+
+	- Miscellaneous cache functions.
+
+		flush_cache_all();
+		flush_cache_mm();
+		invalidate_dcache_range();
+		flush_dcache_range();
+		flush_dcache_page();
+		flush_cache_range();
+		flush_cache_page();
+		invalidate_dcache_range();
+		flush_page_to_ram();
+
diff -puN MAINTAINERS~blackfin-Documentation MAINTAINERS
--- a/MAINTAINERS~blackfin-Documentation
+++ a/MAINTAINERS
@@ -684,6 +684,44 @@ P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
 
+BLACKFIN ARCHITECTURE
+P:     Aubrey Li
+M:     aubrey.li@analog.com
+P:     Bernd Schmidt
+M:     bernd.schmidt@analog.com
+P:     Bryan Wu
+M:     bryan.wu@analog.com
+P:     Grace Pan
+M:     grace.pan@analog.com
+P:     Michael Hennerich
+M:     michael.hennerich@analog.com
+P:     Mike Frysinger
+M:     michael.frysinger@analog.com
+P:     Jane Lv
+M:     jane.lv@analog.com
+P:     Jerry Zeng
+M:     jerry.zeng@analog.com
+P:     Jie Zhang
+M:     jie.zhang@analog.com
+P:     Robin Getz
+M:     robin.getz@analog.com
+P:     Roy Huang
+M:     roy.huang@analog.com
+P:     Sonic Zhang
+M:     sonic.zhang@analog.com
+P:     Yi Li
+M:     yi.li@analog.com
+L:     uclinux-dist-devel@blackfin.uclinux.org
+W:     http://blackfin.uclinux.org
+S:     Supported
+
+BLACKFIN SERIAL DRIVER
+P:     Aubrey Li
+M:     aubrey.li@analog.com
+L:     uclinux-dist-devel@blackfin.uclinux.org
+W:     http://blackfin.uclinux.org
+S:     Supported
+
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
 M:	t.sailer@alumni.ethz.ch
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
