From: akpm@linux-foundation.org
Subject: [merged] arch-remove-direct-definitions-of-kern_level-uses.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:28 -0700
Message-ID: <20120731184929.1E30920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42900 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2GaStb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:31 -0400
Received: by weyr1 with SMTP id r1so292222wey.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dhowells@redhat.com, kay.sievers@vrfy.org, kay@vrfy.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arch: remove direct definitions of KERN_<LEVEL> uses
has been removed from the -mm tree.  Its filename was
     arch-remove-direct-definitions-of-kern_level-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: arch: remove direct definitions of KERN_<LEVEL> uses

Add #include <linux/kern_levels.h> so that the #define KERN_<LEVEL> macros
don't have to be duplicated.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kay Sievers <kay@vrfy.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/lib/io-acorn.S         |    3 ++-
 arch/arm/vfp/vfphw.S            |    7 ++++---
 arch/frv/kernel/kernel_thread.S |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/arm/lib/io-acorn.S~arch-remove-direct-definitions-of-kern_level-uses arch/arm/lib/io-acorn.S
--- a/arch/arm/lib/io-acorn.S~arch-remove-direct-definitions-of-kern_level-uses
+++ a/arch/arm/lib/io-acorn.S
@@ -11,13 +11,14 @@
  *
  */
 #include <linux/linkage.h>
+#include <linux/kern_levels.h>
 #include <asm/assembler.h>
 
 		.text
 		.align
 
 .Liosl_warning:
-		.ascii	"<4>insl/outsl not implemented, called from %08lX\0"
+		.ascii	KERN_WARNING "insl/outsl not implemented, called from %08lX\0"
 		.align
 
 /*
diff -puN arch/arm/vfp/vfphw.S~arch-remove-direct-definitions-of-kern_level-uses arch/arm/vfp/vfphw.S
--- a/arch/arm/vfp/vfphw.S~arch-remove-direct-definitions-of-kern_level-uses
+++ a/arch/arm/vfp/vfphw.S
@@ -16,6 +16,7 @@
  */
 #include <asm/thread_info.h>
 #include <asm/vfpmacros.h>
+#include <linux/kern_levels.h>
 #include "../kernel/entry-header.S"
 
 	.macro	DBGSTR, str
@@ -24,7 +25,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
@@ -37,7 +38,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
@@ -52,7 +53,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
diff -puN arch/frv/kernel/kernel_thread.S~arch-remove-direct-definitions-of-kern_level-uses arch/frv/kernel/kernel_thread.S
--- a/arch/frv/kernel/kernel_thread.S~arch-remove-direct-definitions-of-kern_level-uses
+++ a/arch/frv/kernel/kernel_thread.S
@@ -10,10 +10,10 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/kern_levels.h>
 #include <asm/unistd.h>
 
 #define CLONE_VM	0x00000100	/* set if VM shared between processes */
-#define	KERN_ERR	"<3>"
 
 	.section .rodata
 kernel_thread_emsg:
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

