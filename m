From: akpm@linux-foundation.org
Subject: + add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:03:15 -0700
Message-ID: <200709150203.l8F23FIj002264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159AbXIOCDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp


The patch titled
     add-vmcore: add a prefix "VMCOREINFO_" to the vmcoreinfo macros
has been added to the -mm tree.  Its filename is
     add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-vmcore: add a prefix "VMCOREINFO_" to the vmcoreinfo macros
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

Add a prefix "VMCOREINFO_" to the vmcoreinfo macros.  Old vmcoreinfo macros
were defined as generic names SYMBOL/SIZE/OFFSET /LENGTH/CONFIG, and it is
impossible to grep for them.  So these names should be changed.  This
discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/0415.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/machine_kexec.c   |    6 +-
 arch/ia64/kernel/machine_kexec.c   |   18 +++----
 arch/x86_64/kernel/machine_kexec.c |    4 -
 include/linux/kexec.h              |   14 ++---
 kernel/kexec.c                     |   68 +++++++++++++--------------
 5 files changed, 55 insertions(+), 55 deletions(-)

diff -puN arch/i386/kernel/machine_kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros arch/i386/kernel/machine_kexec.c
--- a/arch/i386/kernel/machine_kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros
+++ a/arch/i386/kernel/machine_kexec.c
@@ -174,11 +174,11 @@ early_param("crashkernel", parse_crashke
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
-	SYMBOL(node_data);
-	LENGTH(node_data, MAX_NUMNODES);
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
 #ifdef CONFIG_X86_PAE
-	CONFIG(X86_PAE);
+	VMCOREINFO_CONFIG(X86_PAE);
 #endif
 }
 
diff -puN arch/ia64/kernel/machine_kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -132,19 +132,19 @@ void machine_kexec(struct kimage *image)
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
-	SYMBOL(pgdat_list);
-	LENGTH(pgdat_list, MAX_NUMNODES);
+	VMCOREINFO_SYMBOL(pgdat_list);
+	VMCOREINFO_LENGTH(pgdat_list, MAX_NUMNODES);
 
-	SYMBOL(node_memblk);
-	LENGTH(node_memblk, NR_NODE_MEMBLKS);
-	SIZE(node_memblk_s);
-	OFFSET(node_memblk_s, start_paddr);
-	OFFSET(node_memblk_s, size);
+	VMCOREINFO_SYMBOL(node_memblk);
+	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
+	VMCOREINFO_SIZE(node_memblk_s);
+	VMCOREINFO_OFFSET(node_memblk_s, start_paddr);
+	VMCOREINFO_OFFSET(node_memblk_s, size);
 #endif
 #ifdef CONFIG_PGTABLE_3
-	CONFIG(PGTABLE_3);
+	VMCOREINFO_CONFIG(PGTABLE_3);
 #elif  CONFIG_PGTABLE_4
-	CONFIG(PGTABLE_4);
+	VMCOREINFO_CONFIG(PGTABLE_4);
 #endif
 }
 
diff -puN arch/x86_64/kernel/machine_kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros arch/x86_64/kernel/machine_kexec.c
--- a/arch/x86_64/kernel/machine_kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros
+++ a/arch/x86_64/kernel/machine_kexec.c
@@ -261,8 +261,8 @@ early_param("crashkernel", setup_crashke
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
-	SYMBOL(node_data);
-	LENGTH(node_data, MAX_NUMNODES);
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
 }
 
diff -puN include/linux/kexec.h~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros include/linux/kexec.h
--- a/include/linux/kexec.h~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros
+++ a/include/linux/kexec.h
@@ -127,22 +127,22 @@ void vmcoreinfo_append_str(const char *f
 	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
-#define SYMBOL(name) \
+#define VMCOREINFO_SYMBOL(name) \
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
-#define SIZE(name) \
+#define VMCOREINFO_SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
 			      (unsigned long)sizeof(struct name))
-#define TYPEDEF_SIZE(name) \
+#define VMCOREINFO_TYPEDEF_SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
 			      (unsigned long)sizeof(name))
-#define OFFSET(name, field) \
+#define VMCOREINFO_OFFSET(name, field) \
 	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
 			      (unsigned long)&(((struct name *)0)->field))
-#define LENGTH(name, value) \
+#define VMCOREINFO_LENGTH(name, value) \
 	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
-#define NUMBER(name) \
+#define VMCOREINFO_NUMBER(name) \
 	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
-#define CONFIG(name) \
+#define VMCOREINFO_CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
 
 extern struct kimage *kexec_image;
diff -puN kernel/kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros kernel/kexec.c
--- a/kernel/kexec.c~add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros
+++ a/kernel/kexec.c
@@ -1198,47 +1198,47 @@ static int __init crash_save_vmcoreinfo_
 	vmcoreinfo_append_str("OSRELEASE=%s\n", init_uts_ns.name.release);
 	vmcoreinfo_append_str("PAGESIZE=%ld\n", PAGE_SIZE);
 
-	SYMBOL(init_uts_ns);
-	SYMBOL(node_online_map);
-	SYMBOL(swapper_pg_dir);
-	SYMBOL(_stext);
+	VMCOREINFO_SYMBOL(init_uts_ns);
+	VMCOREINFO_SYMBOL(node_online_map);
+	VMCOREINFO_SYMBOL(swapper_pg_dir);
+	VMCOREINFO_SYMBOL(_stext);
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-	SYMBOL(mem_map);
-	SYMBOL(contig_page_data);
+	VMCOREINFO_SYMBOL(mem_map);
+	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
 #ifdef CONFIG_SPARSEMEM
-	SYMBOL(mem_section);
-	LENGTH(mem_section, NR_SECTION_ROOTS);
-	SIZE(mem_section);
-	OFFSET(mem_section, section_mem_map);
+	VMCOREINFO_SYMBOL(mem_section);
+	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
+	VMCOREINFO_SIZE(mem_section);
+	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 #endif
-	SIZE(page);
-	SIZE(pglist_data);
-	SIZE(zone);
-	SIZE(free_area);
-	SIZE(list_head);
-	TYPEDEF_SIZE(nodemask_t);
-	OFFSET(page, flags);
-	OFFSET(page, _count);
-	OFFSET(page, mapping);
-	OFFSET(page, lru);
-	OFFSET(pglist_data, node_zones);
-	OFFSET(pglist_data, nr_zones);
+	VMCOREINFO_SIZE(page);
+	VMCOREINFO_SIZE(pglist_data);
+	VMCOREINFO_SIZE(zone);
+	VMCOREINFO_SIZE(free_area);
+	VMCOREINFO_SIZE(list_head);
+	VMCOREINFO_TYPEDEF_SIZE(nodemask_t);
+	VMCOREINFO_OFFSET(page, flags);
+	VMCOREINFO_OFFSET(page, _count);
+	VMCOREINFO_OFFSET(page, mapping);
+	VMCOREINFO_OFFSET(page, lru);
+	VMCOREINFO_OFFSET(pglist_data, node_zones);
+	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
-	OFFSET(pglist_data, node_mem_map);
+	VMCOREINFO_OFFSET(pglist_data, node_mem_map);
 #endif
-	OFFSET(pglist_data, node_start_pfn);
-	OFFSET(pglist_data, node_spanned_pages);
-	OFFSET(pglist_data, node_id);
-	OFFSET(zone, free_area);
-	OFFSET(zone, vm_stat);
-	OFFSET(zone, spanned_pages);
-	OFFSET(free_area, free_list);
-	OFFSET(list_head, next);
-	OFFSET(list_head, prev);
-	LENGTH(zone.free_area, MAX_ORDER);
-	NUMBER(NR_FREE_PAGES);
+	VMCOREINFO_OFFSET(pglist_data, node_start_pfn);
+	VMCOREINFO_OFFSET(pglist_data, node_spanned_pages);
+	VMCOREINFO_OFFSET(pglist_data, node_id);
+	VMCOREINFO_OFFSET(zone, free_area);
+	VMCOREINFO_OFFSET(zone, vm_stat);
+	VMCOREINFO_OFFSET(zone, spanned_pages);
+	VMCOREINFO_OFFSET(free_area, free_list);
+	VMCOREINFO_OFFSET(list_head, next);
+	VMCOREINFO_OFFSET(list_head, prev);
+	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 
 	arch_crash_save_vmcoreinfo();
 
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

add-vmcoreinfo.patch
add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch
