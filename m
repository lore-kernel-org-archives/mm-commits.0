From: akpm@linux-foundation.org
Subject: - make-dev-port-conditional-on-config-symbol.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:25 -0700
Message-ID: <200705090248.l492mP41009108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966236AbXEICsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+lkml@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Make /dev/port conditional on config symbol
has been removed from the -mm tree.  Its filename was
     make-dev-port-conditional-on-config-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1071,5 +1071,11 @@ config TELCLOCK
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

origin.patch
