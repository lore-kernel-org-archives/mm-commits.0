Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDB93BED27
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896659; cv=none; b=GubcmDjVix9gl1fHGYo0zNQbVQv1c/3KIGoa8d+8kodONlv7duaUoWsLeU6Em3/1chyp23cbpgySjd4uaswkT96udYAiuSPAiYBIuVdWbZVSwBxOJykcC6L1/eon7px/9aqVmcACX98LMlmMfF0RwuWl2DeN4PUySxPcVKI11zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896659; c=relaxed/simple;
	bh=ayLiVD9iTwyQTqn4hoEiU9EcOcepx/jgrJO+yddfkSk=;
	h=Date:To:From:Subject:Message-Id; b=rHMB1BWyDKq4RIrMARPqY8r0vIMWNSARtSSF52r7D1CvtCle5B6GL4rtJA4JgjDTWLNq3f9uxNnL5NX9M9usophoLxbl9BVTvnfz/LVPrjo3yePzB8EKZrHzrPspxuS3a4DlOz6/rB6P1DdkQHA/rqlu4P27/H6ZbQQ5vST2Y50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zUDZu7lX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zUDZu7lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6941F000E9;
	Wed,  5 Aug 2026 02:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896657;
	bh=r5gBC/j09bDGGHxEninHUtZaOU1Tlyynk308l4K+LlA=;
	h=Date:To:From:Subject;
	b=zUDZu7lXTCIngTVuMaC/fHToHIWJ0P9wsnp74eZTcQqR6CD3pwn1YGrrmSRJw+odL
	 7DxETOhiqs6lMQcbLNLvRrtNPBo2I0RaTSkcuk9VGLBxkTZRosadIY3YXB+l2n3rwh
	 B1CE0NQrm4LFzMnK224FVTCA9IDWilmqsoKDckRw=
Date: Tue, 04 Aug 2026 19:24:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-remove-config_have_bootmem_info_node.patch removed from -mm tree
Message-Id: <20260805022417.BD6941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
has been removed from the -mm tree.  Its filename was
     x86-mm-remove-config_have_bootmem_info_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: x86/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
Date: Thu, 16 Jul 2026 16:51:06 +0200

CONFIG_HAVE_BOOTMEM_INFO_NODE now essentially doesn't do anything.

So let's remove support for CONFIG_HAVE_BOOTMEM_INFO_NODE.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-7-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   26 --------------------------
 mm/Kconfig            |    1 -
 2 files changed, 27 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-remove-config_have_bootmem_info_node
+++ a/arch/x86/mm/init_64.c
@@ -33,7 +33,6 @@
 #include <linux/nmi.h>
 #include <linux/gfp.h>
 #include <linux/kcore.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1286,16 +1285,6 @@ void __ref arch_remove_memory(u64 start,
 
 static struct kcore_list kcore_vsyscall;
 
-static void __init register_page_bootmem_info(void)
-{
-#if defined(CONFIG_NUMA) || defined(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)
-	int i;
-
-	for_each_online_node(i)
-		register_page_bootmem_info_node(NODE_DATA(i));
-#endif
-}
-
 /*
  * Pre-allocates page-table pages for the vmalloc area in the kernel page-table.
  * Only the level which needs to be synchronized between all page-tables is
@@ -1358,14 +1347,6 @@ void __init mem_init(void)
 	after_bootmem = 1;
 	x86_init.hyper.init_after_bootmem();
 
-	/*
-	 * Must be done after boot memory is put on freelist, because here we
-	 * might set fields in deferred struct pages that have not yet been
-	 * initialized, and memblock_free_all() initializes all the reserved
-	 * deferred pages for us.
-	 */
-	register_page_bootmem_info();
-
 	/* Register memory areas for /proc/kcore */
 	if (get_gate_vma(&init_mm))
 		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
@@ -1564,13 +1545,6 @@ int __meminit vmemmap_populate(unsigned
 	return err;
 }
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long nr_pages)
-{
-}
-#endif
-
 void __meminit vmemmap_populate_print_last(void)
 {
 	if (p_start) {
--- a/mm/Kconfig~x86-mm-remove-config_have_bootmem_info_node
+++ a/mm/Kconfig
@@ -590,7 +590,6 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG
 	select MIGRATION
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

