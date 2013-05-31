From: akpm@linux-foundation.org
Subject: + tile-normalize-global-variables-exported-by-vmlinuxlds.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:29 -0700
Message-ID: <51a908dd.kiuMv+txisDEMBWF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3EaUca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, rusty@rustcorp.com.au, jiang.liu@huawei.com, dhowells@redhat.com, davem@davemloft.net, cmetcalf@tilera.com, bhelgaas@google.com, liuj97@gmail.com

Subject: + tile-normalize-global-variables-exported-by-vmlinuxlds.patch added to -mm tree
To: liuj97@gmail.com,bhelgaas@google.com,cmetcalf@tilera.com,davem@davemloft.net,dhowells@redhat.com,jiang.liu@huawei.com,rusty@rustcorp.com.au,wency@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:29 -0700


The patch titled
     Subject: tile: normalize global variables exported by vmlinux.lds
has been added to the -mm tree.  Its filename is
     tile-normalize-global-variables-exported-by-vmlinuxlds.patch

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
Subject: tile: normalize global variables exported by vmlinux.lds

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

1) Use _text to mark the start of the kernel image including the head
text, and _stext to mark the start of the .text section.
2) Export mandatory global variables __init_begin and __init_end.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/sections.h |    2 +-
 arch/tile/kernel/setup.c         |    4 ++--
 arch/tile/kernel/vmlinux.lds.S   |    4 +++-
 arch/tile/mm/init.c              |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/tile/include/asm/sections.h~tile-normalize-global-variables-exported-by-vmlinuxlds arch/tile/include/asm/sections.h
--- a/arch/tile/include/asm/sections.h~tile-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/tile/include/asm/sections.h
@@ -34,7 +34,7 @@ extern char __sys_cmpxchg_grab_lock[];
 extern char __start_atomic_asm_code[], __end_atomic_asm_code[];
 #endif
 
-/* Handle the discontiguity between _sdata and _stext. */
+/* Handle the discontiguity between _sdata and _text. */
 static inline int arch_is_kernel_data(unsigned long addr)
 {
 	return addr >= (unsigned long)_sdata &&
diff -puN arch/tile/kernel/setup.c~tile-normalize-global-variables-exported-by-vmlinuxlds arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~tile-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/tile/kernel/setup.c
@@ -307,8 +307,8 @@ static void __cpuinit store_permanent_ma
 		hv_store_mapping(addr, pages << PAGE_SHIFT, pa);
 	}
 
-	hv_store_mapping((HV_VirtAddr)_stext,
-			 (uint32_t)(_einittext - _stext), 0);
+	hv_store_mapping((HV_VirtAddr)_text,
+			 (uint32_t)(_einittext - _text), 0);
 }
 
 /*
diff -puN arch/tile/kernel/vmlinux.lds.S~tile-normalize-global-variables-exported-by-vmlinuxlds arch/tile/kernel/vmlinux.lds.S
--- a/arch/tile/kernel/vmlinux.lds.S~tile-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/tile/kernel/vmlinux.lds.S
@@ -27,7 +27,6 @@ SECTIONS
   .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
   {
     _text = .;
-    _stext = .;
     *(.intrpt1)
   } :intrpt1 =0
 
@@ -36,6 +35,7 @@ SECTIONS
 
   /* Now the real code */
   . = ALIGN(0x20000);
+  _stext = .;
   .text : AT (ADDR(.text) - LOAD_OFFSET) {
     HEAD_TEXT
     SCHED_TEXT
@@ -58,11 +58,13 @@ SECTIONS
   #define LOAD_OFFSET PAGE_OFFSET
 
   . = ALIGN(PAGE_SIZE);
+  __init_begin = .;
   VMLINUX_SYMBOL(_sinitdata) = .;
   INIT_DATA_SECTION(16) :data =0
   PERCPU_SECTION(L2_CACHE_BYTES)
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_einitdata) = .;
+  __init_end = .;
 
   _sdata = .;                   /* Start of data section */
 
diff -puN arch/tile/mm/init.c~tile-normalize-global-variables-exported-by-vmlinuxlds arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~tile-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/tile/mm/init.c
@@ -562,7 +562,7 @@ static void __init kernel_physical_mappi
 			prot = ktext_set_nocache(prot);
 		}
 
-		BUG_ON(address != (unsigned long)_stext);
+		BUG_ON(address != (unsigned long)_text);
 		pte = NULL;
 		for (; address < (unsigned long)_einittext;
 		     pfn++, address += PAGE_SIZE) {
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

