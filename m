From: akpm@linux-foundation.org
Subject: [merged]
 uml-normalize-global-variables-exported-by-vmlinuxlds.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:26:46 -0700
Message-ID: <51db1276.oPvlmm/Cv/iwH5JB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3GHT0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, richard@nod.at, jiang.liu@huawei.com, jdike@addtoit.com, liuj97@gmail.com

Subject: [merged] uml-normalize-global-variables-exported-by-vmlinuxlds.patch removed from -mm tree
To: liuj97@gmail.com,jdike@addtoit.com,jiang.liu@huawei.com,richard@nod.at,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:46 -0700


The patch titled
     Subject: UML: normalize global variables exported by vmlinux.lds
has been removed from the -mm tree.  Its filename was
     uml-normalize-global-variables-exported-by-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: UML: normalize global variables exported by vmlinux.lds

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

1) Use _text to mark the start of the kernel image including the head
text, and _stext to mark the start of the .text section.
2) Export mandatory global variables __bss_stop.
3) Adjust __init_begin and __init_end to avoid acrossing .text and
   .data sections.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/common.lds.S |    1 -
 arch/um/kernel/dyn.lds.S         |    6 ++++--
 arch/um/kernel/uml.lds.S         |    7 +++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff -puN arch/um/include/asm/common.lds.S~uml-normalize-global-variables-exported-by-vmlinuxlds arch/um/include/asm/common.lds.S
--- a/arch/um/include/asm/common.lds.S~uml-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/um/include/asm/common.lds.S
@@ -57,7 +57,6 @@
 	*(.uml.initcall.init)
 	__uml_initcall_end = .;
   }
-  __init_end = .;
 
   SECURITY_INIT
 
diff -puN arch/um/kernel/dyn.lds.S~uml-normalize-global-variables-exported-by-vmlinuxlds arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~uml-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/um/kernel/dyn.lds.S
@@ -14,8 +14,6 @@ SECTIONS
   __binary_start = .;
   . = ALIGN(4096);		/* Init code and data */
   _text = .;
-  _stext = .;
-  __init_begin = .;
   INIT_TEXT_SECTION(PAGE_SIZE)
 
   . = ALIGN(PAGE_SIZE);
@@ -67,6 +65,7 @@ SECTIONS
   } =0x90909090
   .plt            : { *(.plt) }
   .text           : {
+    _stext = .;
     TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
@@ -91,7 +90,9 @@ SECTIONS
 
   #include <asm/common.lds.S>
 
+  __init_begin = .;
   init.data : { INIT_DATA }
+  __init_end = .;
 
   /* Ensure the __preinit_array_start label is properly aligned.  We
      could instead move the label definition inside the section, but
@@ -155,6 +156,7 @@ SECTIONS
    . = ALIGN(32 / 8);
   . = ALIGN(32 / 8);
   }
+   __bss_stop = .;
   _end = .;
   PROVIDE (end = .);
 
diff -puN arch/um/kernel/uml.lds.S~uml-normalize-global-variables-exported-by-vmlinuxlds arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~uml-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/um/kernel/uml.lds.S
@@ -20,13 +20,12 @@ SECTIONS
   . = START + SIZEOF_HEADERS;
 
   _text = .;
-  _stext = .;
-  __init_begin = .;
   INIT_TEXT_SECTION(0)
   . = ALIGN(PAGE_SIZE);
 
   .text      :
   {
+    _stext = .;
     TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
@@ -62,7 +61,10 @@ SECTIONS
 
   #include <asm/common.lds.S>
 
+  __init_begin = .;
   init.data : { INIT_DATA }
+  __init_end = .;
+
   .data    :
   {
     INIT_TASK_DATA(KERNEL_STACK_SIZE)
@@ -97,6 +99,7 @@ SECTIONS
   PROVIDE(_bss_start = .);
   SBSS(0)
   BSS(0)
+   __bss_stop = .;
   _end = .;
   PROVIDE (end = .);
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

