From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-make-mem=-option-to-work-for-efi-platform.patch removed from -mm tree
Date: Thu, 08 Nov 2012 12:42:42 -0800
Message-ID: <20121108204242.7C7D8100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39369 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab2KHUmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:42:43 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so379218yen.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:42:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, matt.fleming@intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: make 'mem=' option work for efi platform
has been removed from the -mm tree.  Its filename was
     x86-make-mem=-option-to-work-for-efi-platform.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: x86: make 'mem=' option work for efi platform

Current mem boot option only can work for non efi environments.  If the
user specifies add_efi_memmap, it cannot work for efi environment.

In the efi environment, we call e820_add_region() to add the memory map. 
So we can modify __e820_add_region() and the mem boot option can work for
an efi environment.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/e820.c~x86-make-mem=-option-to-work-for-efi-platform arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~x86-make-mem=-option-to-work-for-efi-platform
+++ a/arch/x86/kernel/e820.c
@@ -47,6 +47,7 @@ unsigned long pci_mem_start = 0xaeedbabe
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL(pci_mem_start);
 #endif
+static u64 mem_limit = ~0ULL;
 
 /*
  * This function checks if any part of the range <start,end> is mapped
@@ -119,6 +120,20 @@ static void __init __e820_add_region(str
 		return;
 	}
 
+	if (start >= mem_limit) {
+		printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+		       (unsigned long long)start,
+		       (unsigned long long)(start + size - 1));
+		return;
+	}
+
+	if (mem_limit - start < size) {
+		printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+		       (unsigned long long)mem_limit,
+		       (unsigned long long)(start + size - 1));
+		size = mem_limit - start;
+	}
+
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -809,7 +824,7 @@ static int userdef __initdata;
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
-	u64 mem_size;
+	char *oldp;
 
 	if (!p)
 		return -EINVAL;
@@ -825,11 +840,11 @@ static int __init parse_memopt(char *p)
 	}
 
 	userdef = 1;
-	mem_size = memparse(p, &p);
+	oldp = p;
+	mem_limit = memparse(p, &p);
 	/* don't remove all of memory when handling "mem={invalid}" param */
-	if (mem_size == 0)
+	if (mem_limit == 0 || p == oldp)
 		return -EINVAL;
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
 }
@@ -881,6 +896,12 @@ early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
 {
+	if (mem_limit != ~0ULL) {
+		userdef = 1;
+		e820_remove_range(mem_limit, ULLONG_MAX - mem_limit,
+				  E820_RAM, 1);
+	}
+
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

linux-next.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-fix-nr_free_pages-mismatch-fix.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

