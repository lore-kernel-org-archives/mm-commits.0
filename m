From: akpm@linux-foundation.org
Subject: + x86-make-mem=-option-to-work-for-efi-platform.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:11:41 -0700
Message-ID: <20121030221142.2D5B25C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39831 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2J3WLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:11:45 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so51143wib.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:11:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, hpa@zytor.com, matt.fleming@intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: x86: make 'mem=' option work for efi platform
has been added to the -mm tree.  Its filename is
     x86-make-mem=-option-to-work-for-efi-platform.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

