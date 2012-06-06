From: akpm@linux-foundation.org
Subject: + arch-remove-direct-definitions-of-kern_level-uses.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:45:11 -0700
Message-ID: <20120606214511.449F7A02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64824 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2FFVpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:45:12 -0400
Received: by qcsp5 with SMTP id p5so763808qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:45:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, dhowells@redhat.com, kay.sievers@vrfy.org, kay@vrfy.org, linux@arm.linux.org.uk


The patch titled
     Subject: arch: remove direct definitions of KERN_<LEVEL> uses
has been added to the -mm tree.  Its filename is
     arch-remove-direct-definitions-of-kern_level-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: arch: remove direct definitions of KERN_<LEVEL> uses

Add #include <linux/kern_levels.h> so that the #define KERN_<LEVEL> macros
don't have to be duplicated.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kay Sievers <kay@vrfy.org>
Cc: David Howells <dhowells@redhat.com>
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
Subject: Subject: arch: remove direct definitions of KERN_<LEVEL> uses

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

