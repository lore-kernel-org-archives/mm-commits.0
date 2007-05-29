From: akpm@linux-foundation.org
Subject: - documentation-documentation-initrdtxt.patch removed from -mm tree
Date: Tue, 29 May 2007 11:52:48 -0700
Message-ID: <200705291852.l4TIqlwK008429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759009AbXE2SxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cavokz@gmail.com, cavok@dandreoli.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     documentation: Documentation/initrd.txt
has been removed from the -mm tree.  Its filename was
     documentation-documentation-initrdtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: documentation: Documentation/initrd.txt
From: Domenico Andreoli <cavokz@gmail.com>

Final clearification of the pivot_root mechanism, which brings this
document really up-to-date.

Signed-off-by: Domenico Andreoli <cavok@dandreoli.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/initrd.txt |   74 +++++++++++++++++++++++--------------
 1 files changed, 46 insertions(+), 28 deletions(-)

diff -puN Documentation/initrd.txt~documentation-documentation-initrdtxt Documentation/initrd.txt
--- a/Documentation/initrd.txt~documentation-documentation-initrdtxt
+++ a/Documentation/initrd.txt
@@ -27,16 +27,20 @@ When using initrd, the system typically 
   1) the boot loader loads the kernel and the initial RAM disk
   2) the kernel converts initrd into a "normal" RAM disk and
      frees the memory used by initrd
-  3) initrd is mounted read-write as root
-  4) /linuxrc is executed (this can be any valid executable, including
+  3) if the root device is not /dev/ram0, the old (deprecated)
+     change_root procedure is followed. see the "Obsolete root change
+     mechanism" section below.
+  4) root device is mounted. if it is /dev/ram0, the initrd image is
+     then mounted as root
+  5) /sbin/init is executed (this can be any valid executable, including
      shell scripts; it is run with uid 0 and can do basically everything
-     init can do)
-  5) linuxrc mounts the "real" root file system
-  6) linuxrc places the root file system at the root directory using the
+     init can do).
+  6) init mounts the "real" root file system
+  7) init places the root file system at the root directory using the
      pivot_root system call
-  7) the usual boot sequence (e.g. invocation of /sbin/init) is performed
-     on the root file system
-  8) the initrd file system is removed
+  8) init execs the /sbin/init on the new root filesystem, performing
+     the usual boot sequence
+  9) the initrd file system is removed
 
 Note that changing the root directory does not involve unmounting it.
 It is therefore possible to leave processes running on initrd during that
@@ -70,7 +74,7 @@ initrd adds the following new options:
   root=/dev/ram0
 
     initrd is mounted as root, and the normal boot procedure is followed,
-    with the RAM disk still mounted as root.
+    with the RAM disk mounted as root.
 
 Compressed cpio images
 ----------------------
@@ -137,11 +141,11 @@ We'll describe the loopback device metho
     # mkdir /mnt/dev
     # mknod /mnt/dev/console c 5 1
  5) copy all the files that are needed to properly use the initrd
-    environment. Don't forget the most important file, /linuxrc
-    Note that /linuxrc's permissions must include "x" (execute).
+    environment. Don't forget the most important file, /sbin/init
+    Note that /sbin/init's permissions must include "x" (execute).
  6) correct operation the initrd environment can frequently be tested
     even without rebooting with the command
-    # chroot /mnt /linuxrc
+    # chroot /mnt /sbin/init
     This is of course limited to initrds that do not interfere with the
     general system state (e.g. by reconfiguring network interfaces,
     overwriting mounted devices, trying to start already running demons,
@@ -154,7 +158,7 @@ We'll describe the loopback device metho
     # gzip -9 initrd
 
 For experimenting with initrd, you may want to take a rescue floppy and
-only add a symbolic link from /linuxrc to /bin/sh. Alternatively, you
+only add a symbolic link from /sbin/init to /bin/sh. Alternatively, you
 can try the experimental newlib environment [2] to create a small
 initrd.
 
@@ -163,15 +167,14 @@ boot loaders support initrd. Since the b
 with an older mechanism, the following boot command line parameters
 have to be given:
 
-  root=/dev/ram0 init=/linuxrc rw
+  root=/dev/ram0 rw
 
 (rw is only necessary if writing to the initrd file system.)
 
 With LOADLIN, you simply execute
 
      LOADLIN <kernel> initrd=<disk_image>
-e.g. LOADLIN C:\LINUX\BZIMAGE initrd=C:\LINUX\INITRD.GZ root=/dev/ram0
-       init=/linuxrc rw
+e.g. LOADLIN C:\LINUX\BZIMAGE initrd=C:\LINUX\INITRD.GZ root=/dev/ram0 rw
 
 With LILO, you add the option INITRD=<path> to either the global section
 or to the section of the respective kernel in /etc/lilo.conf, and pass
@@ -179,7 +182,7 @@ the options using APPEND, e.g.
 
   image = /bzImage
     initrd = /boot/initrd.gz
-    append = "root=/dev/ram0 init=/linuxrc rw"
+    append = "root=/dev/ram0 rw"
 
 and run /sbin/lilo
 
@@ -191,7 +194,7 @@ Now you can boot and enjoy using initrd.
 Changing the root device
 ------------------------
 
-When finished with its duties, linuxrc typically changes the root device
+When finished with its duties, init typically changes the root device
 and proceeds with starting the Linux system on the "real" root device.
 
 The procedure involves the following steps:
@@ -217,7 +220,7 @@ must exist before calling pivot_root. Ex
 # mkdir initrd
 # pivot_root . initrd
 
-Now, the linuxrc process may still access the old root via its
+Now, the init process may still access the old root via its
 executable, shared libraries, standard input/output/error, and its
 current root directory. All these references are dropped by the
 following command:
@@ -249,10 +252,6 @@ disk can be freed:
 It is also possible to use initrd with an NFS-mounted root, see the
 pivot_root(8) man page for details.
 
-Note: if linuxrc or any program exec'ed from it terminates for some
-reason, the old change_root mechanism is invoked (see section "Obsolete
-root change mechanism").
-
 
 Usage scenarios
 ---------------
@@ -264,15 +263,15 @@ as follows:
   1) system boots from floppy or other media with a minimal kernel
      (e.g. support for RAM disks, initrd, a.out, and the Ext2 FS) and
      loads initrd
-  2) /linuxrc determines what is needed to (1) mount the "real" root FS
+  2) /sbin/init determines what is needed to (1) mount the "real" root FS
      (i.e. device type, device drivers, file system) and (2) the
      distribution media (e.g. CD-ROM, network, tape, ...). This can be
      done by asking the user, by auto-probing, or by using a hybrid
      approach.
-  3) /linuxrc loads the necessary kernel modules
-  4) /linuxrc creates and populates the root file system (this doesn't
+  3) /sbin/init loads the necessary kernel modules
+  4) /sbin/init creates and populates the root file system (this doesn't
      have to be a very usable system yet)
-  5) /linuxrc invokes pivot_root to change the root file system and
+  5) /sbin/init invokes pivot_root to change the root file system and
      execs - via chroot - a program that continues the installation
   6) the boot loader is installed
   7) the boot loader is configured to load an initrd with the set of
@@ -291,7 +290,7 @@ different hardware configurations in a s
 such cases, it is desirable to generate only a small set of kernels
 (ideally only one) and to keep the system-specific part of configuration
 information as small as possible. In this case, a common initrd could be
-generated with all the necessary modules. Then, only /linuxrc or a file
+generated with all the necessary modules. Then, only /sbin/init or a file
 read by it would have to be different.
 
 A third scenario are more convenient recovery disks, because information
@@ -337,6 +336,25 @@ This old, deprecated mechanism is common
 the new, supported mechanism is called "pivot_root".
 
 
+Mixed change_root and pivot_root mechanism
+------------------------------------------
+
+In case you did not want to use root=/dev/ram0 to trig the pivot_root mechanism,
+you may create both /linuxrc and /sbin/init in your initrd image.
+
+/linuxrc would contain only the following:
+
+#! /bin/sh
+mount -n -t proc proc /proc
+echo 0x0100 >/proc/sys/kernel/real-root-dev
+umount -n /proc
+
+Once linuxrc exited, the kernel would mount again your initrd as root,
+this time executing /sbin/init. Again, it would be duty of this init
+to build the right environment (maybe using the root= device passed on
+the cmdline) before the final execution of the real /sbin/init.
+
+
 Resources
 ---------
 
_

Patches currently in -mm which might be from cavokz@gmail.com are
