From: akpm@linux-foundation.org
Subject: - proc-move-kconfig-to-fs-proc-kconfig.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:15 -0700
Message-ID: <200807252302.m6PN2FcF003810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbYGYXG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: move Kconfig to fs/proc/Kconfig
has been removed from the -mm tree.  Its filename was
     proc-move-kconfig-to-fs-proc-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: move Kconfig to fs/proc/Kconfig
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig      |   60 ----------------------------------------------
 fs/proc/Kconfig |   59 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 59 deletions(-)

diff -puN fs/Kconfig~proc-move-kconfig-to-fs-proc-kconfig fs/Kconfig
--- a/fs/Kconfig~proc-move-kconfig-to-fs-proc-kconfig
+++ a/fs/Kconfig
@@ -902,65 +902,7 @@ endif # BLOCK
 
 menu "Pseudo filesystems"
 
-config PROC_FS
-	bool "/proc file system support" if EMBEDDED
-	default y
-	help
-	  This is a virtual file system providing information about the status
-	  of the system. "Virtual" means that it doesn't take up any space on
-	  your hard disk: the files are created on the fly by the kernel when
-	  you try to access them. Also, you cannot read the files with older
-	  version of the program less: you need to use more or cat.
-
-	  It's totally cool; for example, "cat /proc/interrupts" gives
-	  information about what the different IRQs are used for at the moment
-	  (there is a small number of Interrupt ReQuest lines in your computer
-	  that are used by the attached devices to gain the CPU's attention --
-	  often a source of trouble if two devices are mistakenly configured
-	  to use the same IRQ). The program procinfo to display some
-	  information about your system gathered from the /proc file system.
-
-	  Before you can use the /proc file system, it has to be mounted,
-	  meaning it has to be given a location in the directory hierarchy.
-	  That location should be /proc. A command such as "mount -t proc proc
-	  /proc" or the equivalent line in /etc/fstab does the job.
-
-	  The /proc file system is explained in the file
-	  <file:Documentation/filesystems/proc.txt> and on the proc(5) manpage
-	  ("man 5 proc").
-
-	  This option will enlarge your kernel by about 67 KB. Several
-	  programs depend on this, so everyone should say Y here.
-
-config PROC_KCORE
-	bool "/proc/kcore support" if !ARM
-	depends on PROC_FS && MMU
-
-config PROC_VMCORE
-        bool "/proc/vmcore support (EXPERIMENTAL)"
-        depends on PROC_FS && CRASH_DUMP
-	default y
-        help
-        Exports the dump image of crashed kernel in ELF format.
-
-config PROC_SYSCTL
-	bool "Sysctl support (/proc/sys)" if EMBEDDED
-	depends on PROC_FS
-	select SYSCTL
-	default y
-	---help---
-	  The sysctl interface provides a means of dynamically changing
-	  certain kernel parameters and variables on the fly without requiring
-	  a recompile of the kernel or reboot of the system.  The primary
-	  interface is through /proc/sys.  If you say Y here a tree of
-	  modifiable sysctl entries will be generated beneath the
-          /proc/sys directory. They are explained in the files
-	  in <file:Documentation/sysctl/>.  Note that enabling this
-	  option will enlarge the kernel by at least 8 KB.
-
-	  As it is generally a good thing, you should say Y here unless
-	  building a kernel for install/rescue disks or your system is very
-	  limited in memory.
+source "fs/proc/Kconfig"
 
 config SYSFS
 	bool "sysfs file system support" if EMBEDDED
diff -puN /dev/null fs/proc/Kconfig
--- /dev/null
+++ a/fs/proc/Kconfig
@@ -0,0 +1,59 @@
+config PROC_FS
+	bool "/proc file system support" if EMBEDDED
+	default y
+	help
+	  This is a virtual file system providing information about the status
+	  of the system. "Virtual" means that it doesn't take up any space on
+	  your hard disk: the files are created on the fly by the kernel when
+	  you try to access them. Also, you cannot read the files with older
+	  version of the program less: you need to use more or cat.
+
+	  It's totally cool; for example, "cat /proc/interrupts" gives
+	  information about what the different IRQs are used for at the moment
+	  (there is a small number of Interrupt ReQuest lines in your computer
+	  that are used by the attached devices to gain the CPU's attention --
+	  often a source of trouble if two devices are mistakenly configured
+	  to use the same IRQ). The program procinfo to display some
+	  information about your system gathered from the /proc file system.
+
+	  Before you can use the /proc file system, it has to be mounted,
+	  meaning it has to be given a location in the directory hierarchy.
+	  That location should be /proc. A command such as "mount -t proc proc
+	  /proc" or the equivalent line in /etc/fstab does the job.
+
+	  The /proc file system is explained in the file
+	  <file:Documentation/filesystems/proc.txt> and on the proc(5) manpage
+	  ("man 5 proc").
+
+	  This option will enlarge your kernel by about 67 KB. Several
+	  programs depend on this, so everyone should say Y here.
+
+config PROC_KCORE
+	bool "/proc/kcore support" if !ARM
+	depends on PROC_FS && MMU
+
+config PROC_VMCORE
+        bool "/proc/vmcore support (EXPERIMENTAL)"
+        depends on PROC_FS && CRASH_DUMP
+	default y
+        help
+        Exports the dump image of crashed kernel in ELF format.
+
+config PROC_SYSCTL
+	bool "Sysctl support (/proc/sys)" if EMBEDDED
+	depends on PROC_FS
+	select SYSCTL
+	default y
+	---help---
+	  The sysctl interface provides a means of dynamically changing
+	  certain kernel parameters and variables on the fly without requiring
+	  a recompile of the kernel or reboot of the system.  The primary
+	  interface is through /proc/sys.  If you say Y here a tree of
+	  modifiable sysctl entries will be generated beneath the
+          /proc/sys directory. They are explained in the files
+	  in <file:Documentation/sysctl/>.  Note that enabling this
+	  option will enlarge the kernel by at least 8 KB.
+
+	  As it is generally a good thing, you should say Y here unless
+	  building a kernel for install/rescue disks or your system is very
+	  limited in memory.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
use-warn-in-fs-proc.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

