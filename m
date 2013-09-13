From: akpm@linux-foundation.org
Subject: [-] x86-make-mem=-option-to-work-for-efi-platform.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:29:37 -0700
Message-ID: <523375b1.GRTvBRTirmQIPOJJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3IMU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rob@landley.net, mjg@redhat.com, mingo@redhat.com, matt.fleming@intel.com, kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com, wency@cn.fujitsu.com

Subject: [-] x86-make-mem=-option-to-work-for-efi-platform.patch removed from -mm tree
To: wency@cn.fujitsu.com,bhelgaas@google.com,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,matt.fleming@intel.com,mingo@redhat.com,mjg@redhat.com,rob@landley.net,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:29:37 -0700


The patch titled
     Subject: x86: make 'mem=' option to work for efi platform
has been removed from the -mm tree.  Its filename was
     x86-make-mem=-option-to-work-for-efi-platform.patch

This patch was dropped because Matt had testing failures

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: x86: make 'mem=' option to work for efi platform

Current mem boot option only can work for non efi environment.  If the
user specifies add_efi_memmap, it cannot work for efi environment.  In the
efi environment, we call e820_add_region() to add the memory map.  So we
can modify __e820_add_region() and the mem boot option can work for efi
environment.

Note: Only E820_RAM is limited, and BOOT_SERVICES_{CODE,DATA} are always
mapped(If its address >= mem_limit, the memory won't be freed in
efi_free_boot_services()).

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/e820.h |    2 
 arch/x86/kernel/e820.c      |   72 +++++++++++++++++++++++++++++-----
 arch/x86/platform/efi/efi.c |   15 +++++--
 3 files changed, 77 insertions(+), 12 deletions(-)

diff -puN arch/x86/include/asm/e820.h~x86-make-mem=-option-to-work-for-efi-platform arch/x86/include/asm/e820.h
--- a/arch/x86/include/asm/e820.h~x86-make-mem=-option-to-work-for-efi-platform
+++ a/arch/x86/include/asm/e820.h
@@ -17,6 +17,8 @@ extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
+extern void e820_add_limit_region(u64 start, u64 size, int type);
+extern void e820_adjust_region(u64 *start, u64 *size);
 extern void e820_print_map(char *who);
 extern int
 sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
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
@@ -108,7 +109,7 @@ int __init e820_all_mapped(u64 start, u6
  * Add a memory region to the kernel e820 map.
  */
 static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
-					 int type)
+					 int type, bool limited)
 {
 	int x = e820x->nr_map;
 
@@ -119,6 +120,22 @@ static void __init __e820_add_region(str
 		return;
 	}
 
+	if (limited) {
+		if (start >= mem_limit) {
+			printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+			       (unsigned long long)start,
+			       (unsigned long long)(start + size - 1));
+			return;
+		}
+
+		if (mem_limit - start < size) {
+			printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+			       (unsigned long long)mem_limit,
+			       (unsigned long long)(start + size - 1));
+			size = mem_limit - start;
+		}
+	}
+
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -127,7 +144,37 @@ static void __init __e820_add_region(str
 
 void __init e820_add_region(u64 start, u64 size, int type)
 {
-	__e820_add_region(&e820, start, size, type);
+	__e820_add_region(&e820, start, size, type, false);
+}
+
+/*
+ * do_add_efi_memmap() calls this function().
+ *
+ * Note: BOOT_SERVICES_{CODE,DATA} regions on some efi machines are marked
+ * as E820_RAM, and they are needed to be mapped. Please use e820_add_region()
+ * to add BOOT_SERVICES_{CODE,DATA} regions.
+ */
+void __init e820_add_limit_region(u64 start, u64 size, int type)
+{
+	/*
+	 * efi_init() is called after finish_e820_parsing(), so we should
+	 * check whether [start, start + size) contains address above
+	 * mem_limit if the type is E820_RAM.
+	 */
+	__e820_add_region(&e820, start, size, type, type == E820_RAM);
+}
+
+void __init e820_adjust_region(u64 *start, u64 *size)
+{
+	if (*start >= mem_limit) {
+		*size = 0;
+		return;
+	}
+
+	if (mem_limit - *start < *size)
+		*size = mem_limit - *start;
+
+	return;
 }
 
 static void __init e820_print_type(u32 type)
@@ -455,8 +502,9 @@ static u64 __init __e820_update_range(st
 
 		/* new range is totally covered? */
 		if (ei->addr < start && ei_end > end) {
-			__e820_add_region(e820x, start, size, new_type);
-			__e820_add_region(e820x, end, ei_end - end, ei->type);
+			__e820_add_region(e820x, start, size, new_type, false);
+			__e820_add_region(e820x, end, ei_end - end, ei->type,
+					  false);
 			ei->size = start - ei->addr;
 			real_updated_size += size;
 			continue;
@@ -469,7 +517,7 @@ static u64 __init __e820_update_range(st
 			continue;
 
 		__e820_add_region(e820x, final_start, final_end - final_start,
-				  new_type);
+				  new_type, false);
 
 		real_updated_size += final_end - final_start;
 
@@ -809,7 +857,7 @@ static int userdef __initdata;
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
-	u64 mem_size;
+	char *oldp;
 
 	if (!p)
 		return -EINVAL;
@@ -825,11 +873,11 @@ static int __init parse_memopt(char *p)
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
@@ -895,6 +943,12 @@ early_param("memmap", parse_memmap_opt);
 
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
 
diff -puN arch/x86/platform/efi/efi.c~x86-make-mem=-option-to-work-for-efi-platform arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~x86-make-mem=-option-to-work-for-efi-platform
+++ a/arch/x86/platform/efi/efi.c
@@ -343,10 +343,17 @@ static void __init do_add_efi_memmap(voi
 		int e820_type;
 
 		switch (md->type) {
-		case EFI_LOADER_CODE:
-		case EFI_LOADER_DATA:
 		case EFI_BOOT_SERVICES_CODE:
 		case EFI_BOOT_SERVICES_DATA:
+			/* EFI_BOOT_SERVICES_{CODE,DATA} needs to be mapped */
+			if (md->attribute & EFI_MEMORY_WB)
+				e820_type = E820_RAM;
+			else
+				e820_type = E820_RESERVED;
+			e820_add_region(start, size, e820_type);
+			continue;
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
 		case EFI_CONVENTIONAL_MEMORY:
 			if (md->attribute & EFI_MEMORY_WB)
 				e820_type = E820_RAM;
@@ -371,7 +378,7 @@ static void __init do_add_efi_memmap(voi
 			e820_type = E820_RESERVED;
 			break;
 		}
-		e820_add_region(start, size, e820_type);
+		e820_add_limit_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
@@ -479,6 +486,8 @@ void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
+		e820_adjust_region(&start, &size);
+
 		/* Could not reserve boot area */
 		if (!size)
 			continue;
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch

