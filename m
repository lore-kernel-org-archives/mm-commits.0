From: akpm@linux-foundation.org
Subject: + kgdb-fix-help-text.patch added to -mm tree
Date: Thu, 20 Sep 2007 16:24:30 -0700
Message-ID: <200709202324.l8KNOUKP008014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbXITXYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 19:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jason.wessel@windriver.com


The patch titled
     kgdb: fix help text
has been added to the -mm tree.  Its filename is
     kgdb-fix-help-text.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kgdb: fix help text
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kgdb help text typos, grammar, config symbol names, and indentation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kgdb |   42 ++++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff -puN lib/Kconfig.kgdb~kgdb-fix-help-text lib/Kconfig.kgdb
--- a/lib/Kconfig.kgdb~kgdb-fix-help-text
+++ a/lib/Kconfig.kgdb
@@ -27,15 +27,15 @@ config KGDB_ARCH_HAS_SHADOW_INFO
 config KGDB_CONSOLE
 	bool "KGDB: Console messages through gdb"
 	depends on KGDB
-	  help
-	    If you say Y here, console messages will appear through gdb.
-	    Other consoles such as tty or ttyS will continue to work as usual.
-	    Note, that if you use this in conjunction with KGDB_ETH, if the
-	    ethernet driver runs into an error condition during use with KGDB
-	    it is possible to hit an infinite recusrion, causing the kernel
-	    to crash, and typically reboot.  For this reason, it is preferable
-	    to use NETCONSOLE in conjunction with KGDB_ETH instead of
-	    KGDB_CONSOLE.
+	help
+	  If you say Y here, console messages will appear through gdb.
+	  Other consoles such as tty or ttyS will continue to work as usual.
+	  Note that if you use this in conjunction with KGDBOE, if the
+	  ethernet driver runs into an error condition during use with KGDB,
+	  it is possible to hit an infinite recursion, causing the kernel
+	  to crash, and typically reboot.  For this reason, it is preferable
+	  to use NETCONSOLE in conjunction with KGDBOE instead of
+	  KGDB_CONSOLE.
 
 choice
 	prompt "Method for KGDB communication"
@@ -106,7 +106,7 @@ config KGDB_TXX9
 	bool "KGDB: On TX49xx serial port"
 	depends on MIPS && CPU_TX49XX
 	help
-	  Uses TX49xx serial port to communicate with the host KGDB.
+	  Uses TX49xx serial port to communicate with the host GDB.
 
 config KGDB_SH_SCI
 	bool "KGDB: On SH SCI(F) serial port"
@@ -251,20 +251,18 @@ config KGDB_8250_CONF_STRING
 	depends on KGDB_8250_NOMODULE && !KGDB_SIMPLE_SERIAL
 	default "io,2f8,115200,3" if X86
 	help
-	  The format of this string should be <io or
-	  mmio>,<address>,<baud rate>,<irq>.  For example, to use the
-	  serial port on an i386 box located at 0x2f8 and 115200 baud
-	  on IRQ 3 at use:
-	  io,2f8,115200,3
+	  The format of this string should be <io or mmio>,
+	  <address>,<baud rate>,<irq>.  For example, on an i386 box,
+	  to use the serial port located at 0x2f8, IRQ 3, at 115200 baud
+	  use:  io,2f8,115200,3
 
 config KGDB_ATTACH_WAIT
 	bool "KGDB: Wait for debugger to attach on an unknown exception"
 	default y if KGDB_8250_NOMODULE
 	default n if !KGDB_8250_NOMODULE
-	  help
-	    If a panic occurs, or any kind of exception the kgdb will
-	    stop and wait for a debugger to attach.  This sets the
-	    default behavior for waiting for the debugger to attach.  This
-	    value can also be changed at runtime through
-	    /sys/module/kgdb/paramaters/attachwait
-
+	help
+	  If a panic occurs, or any kind of exception, the kgdb will
+	  stop and wait for a debugger to attach.  This sets the
+	  default behavior for waiting for the debugger to attach.  This
+	  value can also be changed at runtime through
+	  /sys/module/kgdb/parameters/attachwait
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch
sound-hda-fix-help-text.patch
kgdb-fix-help-text.patch
