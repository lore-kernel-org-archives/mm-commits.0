From: akpm@linux-foundation.org
Subject: [merged]
 tile-normalize-global-variables-exported-by-vmlinuxlds.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:26:44 -0700
Message-ID: <51db1274.ZUfNZHyfe+MlfZcQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GHT0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, rusty@rustcorp.com.au, jiang.liu@huawei.com, dhowells@redhat.com, davem@davemloft.net, cmetcalf@tilera.com, bhelgaas@google.com, liuj97@gmail.com

Subject: [merged] tile-normalize-global-variables-exported-by-vmlinuxlds.patch removed from -mm tree
To: liuj97@gmail.com,bhelgaas@google.com,cmetcalf@tilera.com,davem@davemloft.net,dhowells@redhat.com,jiang.liu@huawei.com,rusty@rustcorp.com.au,wency@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:44 -0700


The patch titled
     Subject: tile: normalize global variables exported by vmlinux.lds
has been removed from the -mm tree.  Its filename was
     tile-normalize-global-variables-exported-by-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

