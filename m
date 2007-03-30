From: akpm@linux-foundation.org
Subject: + make-dev-port-conditional-on-config-symbol.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:21:10 -0700
Message-ID: <200703302121.l2ULLALn005943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53251 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbXC3VWT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+lkml@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk


The patch titled
     Make /dev/port conditional on config symbol
has been added to the -mm tree.  Its filename is
     make-dev-port-conditional-on-config-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make /dev/port conditional on config symbol
From: Russell King <rmk+lkml@arm.linux.org.uk>

Instead of having /dev/port support dependent in multiple places on a
string of preprocessor symbols, define a new configuration directive for
it.  This ensures that all four places remain consistent with each other.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    6 ++++++
 drivers/char/mem.c   |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/char/Kconfig~make-dev-port-conditional-on-config-symbol drivers/char/Kconfig
--- a/drivers/char/Kconfig~make-dev-port-conditional-on-config-symbol
+++ a/drivers/char/Kconfig
@@ -1081,5 +1081,11 @@ config TELCLOCK
 	  /sys/devices/platform/telco_clock, with a number of files for
 	  controlling the behavior of this hardware.
 
+config DEVPORT
+	bool
+	depends on !M68K
+	depends on ISA || PCI
+	default y
+
 endmenu
 
diff -puN drivers/char/mem.c~make-dev-port-conditional-on-config-symbol drivers/char/mem.c
--- a/drivers/char/mem.c~make-dev-port-conditional-on-config-symbol
+++ a/drivers/char/mem.c
@@ -551,7 +551,7 @@ static ssize_t write_kmem(struct file * 
  	return virtr + wrote;
 }
 
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file * file, char __user * buf,
 			 size_t count, loff_t *ppos)
 {
@@ -834,7 +834,7 @@ static const struct file_operations null
 	.splice_write	= splice_write_null,
 };
 
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 static const struct file_operations port_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_port,
@@ -912,7 +912,7 @@ static int memory_open(struct inode * in
 		case 3:
 			filp->f_op = &null_fops;
 			break;
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 		case 4:
 			filp->f_op = &port_fops;
 			break;
@@ -959,7 +959,7 @@ static const struct {
 	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops},
 	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops},
 	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops},
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops},
 #endif
 	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops},
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

pata_platform-for-arm-riscpc.patch
git-kbuild.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
provide-dummy-devm_ioport_-if-has_ioport.patch
make-dev-port-conditional-on-config-symbol.patch
