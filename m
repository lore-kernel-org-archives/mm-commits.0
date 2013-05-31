From: akpm@linux-foundation.org
Subject: + uml-normalize-global-variables-exported-by-vmlinuxlds.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:30 -0700
Message-ID: <51a908de.XqlArDMfAuWqrHRH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3EaUcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, richard@nod.at, jiang.liu@huawei.com, jdike@addtoit.com, liuj97@gmail.com

Subject: + uml-normalize-global-variables-exported-by-vmlinuxlds.patch added to -mm tree
To: liuj97@gmail.com,jdike@addtoit.com,jiang.liu@huawei.com,richard@nod.at,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:30 -0700


The patch titled
     Subject: UML: normalize global variables exported by vmlinux.lds
has been added to the -mm tree.  Its filename is
     uml-normalize-global-variables-exported-by-vmlinuxlds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch
vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch
avr32-normalize-global-variables-exported-by-vmlinuxlds.patch
c6x-normalize-global-variables-exported-by-vmlinuxlds.patch
h8300-normalize-global-variables-exported-by-vmlinuxlds.patch
score-normalize-global-variables-exported-by-vmlinuxlds.patch
tile-normalize-global-variables-exported-by-vmlinuxlds.patch
uml-normalize-global-variables-exported-by-vmlinuxlds.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch
mm-hotplug-prepare-for-removing-num_physpages.patch
mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-um-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-unicore32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-xtensa-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch

