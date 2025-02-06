Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489062288D9
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 23:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738883992; cv=none; b=f8N53skMUrItR2ge7I50sbKDJ5y53aPZodsL5xqju9rAhcXI/ktevvqUpIrllUKGT02d9rt+/WahBUum6W/EjTfFqkQcIqQjPSayGY9Uihwdm1Ln58lITCHQ8ruWHZTT43UOZWY5Uc0GTgmqQe9JuMVApd2cT31O9jxf9DyMozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738883992; c=relaxed/simple;
	bh=25gyhuytYyD/k011o9Wr4ZLS7LwKRTnxUH33KkMpCj8=;
	h=Date:To:From:Subject:Message-Id; b=NvefBk9Eb0JFektKN8M5medyJEXC14I07tc+t5H+5z8SqRKD7lzcJlLKgWn1mosQ3YG8sq6jDqiO+HPzpj1gucfl3Q0Xy0Gv1PUVDdaK4xDONHXZRCMIUihzLZ4nXZHGk7hxD4QiqGzNodbFYM9/pB5pK5Y5EA7MCTv0jRO3Dqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q3Esi56f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q3Esi56f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED44AC4CEDD;
	Thu,  6 Feb 2025 23:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738883992;
	bh=25gyhuytYyD/k011o9Wr4ZLS7LwKRTnxUH33KkMpCj8=;
	h=Date:To:From:Subject:From;
	b=q3Esi56ft9YZaQkXik5Soh+teXFBimP/RaWexhCpB+eduvMriwY18F9U0aMhDrYzf
	 GtBmLFtvGMVMe1PQpsMy8gYJP8R2bBGVD6wqqc7wiRTOMBbZiS+Jufv8kZwXU+Pi7K
	 GBan04uQyfRIiH7eF0r0YB+pizbasR/sHaOMwLKk=
Date: Thu, 06 Feb 2025 15:19:51 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch added to mm-unstable branch
Message-Id: <20250206231951.ED44AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: convert cmdline parameters from setup to early
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: convert cmdline parameters from setup to early
Date: Thu, 6 Feb 2025 18:50:48 +0000

Convert the cmdline parameters (hugepagesz, hugepages, default_hugepagesz
and hugetlb_free_vmemmap) to early parameters.

Since parse_early_param might run before MMU setups on some platforms
(powerpc), validation of huge page sizes as specified in command line
parameters would fail.  So instead, for the hstate-related values, just
record the them and parse them on demand, from hugetlb_bootmem_alloc.

The allocation of hugetlb bootmem pages is now done in
hugetlb_bootmem_alloc, which is called explicitly at the start of
mm_core_init().  core_initcall would be too late, as that happens with
memblock already torn down.

This change will allow earlier allocation and initialization of bootmem
hugetlb pages later on.

No functional change intended.

Link: https://lkml.kernel.org/r/20250206185109.1210657-9-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +
 mm/hugetlb.c            |  133 ++++++++++++++++++++++++++++++--------
 mm/hugetlb_vmemmap.c    |    6 +
 mm/mm_init.c            |    3 
 4 files changed, 119 insertions(+), 29 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-cmdline-parameters-from-setup-to-early
+++ a/include/linux/hugetlb.h
@@ -174,6 +174,8 @@ struct address_space *hugetlb_folio_mapp
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
+void hugetlb_bootmem_alloc(void);
+
 /* arch callbacks */
 
 #ifndef CONFIG_HIGHPTE
@@ -1250,6 +1252,10 @@ static inline bool hugetlbfs_pagecache_p
 {
 	return false;
 }
+
+static inline void hugetlb_bootmem_alloc(void)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~mm-hugetlb-convert-cmdline-parameters-from-setup-to-early
+++ a/mm/hugetlb.c
@@ -40,6 +40,7 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
+#include <asm/setup.h>
 
 #include <linux/io.h>
 #include <linux/hugetlb.h>
@@ -62,6 +63,24 @@ static unsigned long hugetlb_cma_size __
 
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 
+/*
+ * Due to ordering constraints across the init code for various
+ * architectures, hugetlb hstate cmdline parameters can't simply
+ * be early_param. early_param might call the setup function
+ * before valid hugetlb page sizes are determined, leading to
+ * incorrect rejection of valid hugepagesz= options.
+ *
+ * So, record the parameters early and consume them whenever the
+ * init code is ready for them, by calling hugetlb_parse_params().
+ */
+
+/* one (hugepagesz=,hugepages=) pair per hstate, one default_hugepagesz */
+#define HUGE_MAX_CMDLINE_ARGS	(2 * HUGE_MAX_HSTATE + 1)
+struct hugetlb_cmdline {
+	char *val;
+	int (*setup)(char *val);
+};
+
 /* for command line parsing */
 static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
@@ -69,6 +88,20 @@ static bool __initdata parsed_valid_huge
 static bool __initdata parsed_default_hugepagesz;
 static unsigned int default_hugepages_in_node[MAX_NUMNODES] __initdata;
 
+static char hstate_cmdline_buf[COMMAND_LINE_SIZE] __initdata;
+static int hstate_cmdline_index __initdata;
+static struct hugetlb_cmdline hugetlb_params[HUGE_MAX_CMDLINE_ARGS] __initdata;
+static int hugetlb_param_index __initdata;
+static __init int hugetlb_add_param(char *s, int (*setup)(char *val));
+static __init void hugetlb_parse_params(void);
+
+#define hugetlb_early_param(str, func) \
+static __init int func##args(char *s) \
+{ \
+	return hugetlb_add_param(s, func); \
+} \
+early_param(str, func##args)
+
 /*
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
@@ -3488,6 +3521,8 @@ static void __init hugetlb_hstate_alloc_
 
 		for (i = 0; i < MAX_NUMNODES; i++)
 			INIT_LIST_HEAD(&huge_boot_pages[i]);
+		h->next_nid_to_alloc = first_online_node;
+		h->next_nid_to_free = first_online_node;
 		initialized = true;
 	}
 
@@ -4550,8 +4585,6 @@ void __init hugetlb_add_hstate(unsigned
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_online_node;
-	h->next_nid_to_free = first_online_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/SZ_1K);
 
@@ -4576,6 +4609,42 @@ static void __init hugepages_clear_pages
 	}
 }
 
+static __init int hugetlb_add_param(char *s, int (*setup)(char *))
+{
+	size_t len;
+	char *p;
+
+	if (hugetlb_param_index >= HUGE_MAX_CMDLINE_ARGS)
+		return -EINVAL;
+
+	len = strlen(s) + 1;
+	if (len + hstate_cmdline_index > sizeof(hstate_cmdline_buf))
+		return -EINVAL;
+
+	p = &hstate_cmdline_buf[hstate_cmdline_index];
+	memcpy(p, s, len);
+	hstate_cmdline_index += len;
+
+	hugetlb_params[hugetlb_param_index].val = p;
+	hugetlb_params[hugetlb_param_index].setup = setup;
+
+	hugetlb_param_index++;
+
+	return 0;
+}
+
+static __init void hugetlb_parse_params(void)
+{
+	int i;
+	struct hugetlb_cmdline *hcp;
+
+	for (i = 0; i < hugetlb_param_index; i++) {
+		hcp = &hugetlb_params[i];
+
+		hcp->setup(hcp->val);
+	}
+}
+
 /*
  * hugepages command line processing
  * hugepages normally follows a valid hugepagsz or default_hugepagsz
@@ -4595,7 +4664,7 @@ static int __init hugepages_setup(char *
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
-		return 1;
+		return -EINVAL;
 	}
 
 	/*
@@ -4649,24 +4718,16 @@ static int __init hugepages_setup(char *
 		}
 	}
 
-	/*
-	 * Global state is always initialized later in hugetlb_init.
-	 * But we need to allocate gigantic hstates here early to still
-	 * use the bootmem allocator.
-	 */
-	if (hugetlb_max_hstate && hstate_is_gigantic(parsed_hstate))
-		hugetlb_hstate_alloc_pages(parsed_hstate);
-
 	last_mhp = mhp;
 
-	return 1;
+	return 0;
 
 invalid:
 	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
 	hugepages_clear_pages_in_node();
-	return 1;
+	return -EINVAL;
 }
-__setup("hugepages=", hugepages_setup);
+hugetlb_early_param("hugepages", hugepages_setup);
 
 /*
  * hugepagesz command line processing
@@ -4685,7 +4746,7 @@ static int __init hugepagesz_setup(char
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
-		return 1;
+		return -EINVAL;
 	}
 
 	h = size_to_hstate(size);
@@ -4700,7 +4761,7 @@ static int __init hugepagesz_setup(char
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
 			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
-			return 1;
+			return -EINVAL;
 		}
 
 		/*
@@ -4710,14 +4771,14 @@ static int __init hugepagesz_setup(char
 		 */
 		parsed_hstate = h;
 		parsed_valid_hugepagesz = true;
-		return 1;
+		return 0;
 	}
 
 	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
 	parsed_valid_hugepagesz = true;
-	return 1;
+	return 0;
 }
-__setup("hugepagesz=", hugepagesz_setup);
+hugetlb_early_param("hugepagesz", hugepagesz_setup);
 
 /*
  * default_hugepagesz command line input
@@ -4731,14 +4792,14 @@ static int __init default_hugepagesz_set
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
 		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
-		return 1;
+		return -EINVAL;
 	}
 
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported default_hugepagesz=%s\n", s);
-		return 1;
+		return -EINVAL;
 	}
 
 	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
@@ -4755,17 +4816,33 @@ static int __init default_hugepagesz_set
 	 */
 	if (default_hstate_max_huge_pages) {
 		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
-		for_each_online_node(i)
-			default_hstate.max_huge_pages_node[i] =
-				default_hugepages_in_node[i];
-		if (hstate_is_gigantic(&default_hstate))
-			hugetlb_hstate_alloc_pages(&default_hstate);
+		/*
+		 * Since this is an early parameter, we can't check
+		 * NUMA node state yet, so loop through MAX_NUMNODES.
+		 */
+		for (i = 0; i < MAX_NUMNODES; i++) {
+			if (default_hugepages_in_node[i] != 0)
+				default_hstate.max_huge_pages_node[i] =
+					default_hugepages_in_node[i];
+		}
 		default_hstate_max_huge_pages = 0;
 	}
 
-	return 1;
+	return 0;
+}
+hugetlb_early_param("default_hugepagesz", default_hugepagesz_setup);
+
+void __init hugetlb_bootmem_alloc(void)
+{
+	struct hstate *h;
+
+	hugetlb_parse_params();
+
+	for_each_hstate(h) {
+		if (hstate_is_gigantic(h))
+			hugetlb_hstate_alloc_pages(h);
+	}
 }
-__setup("default_hugepagesz=", default_hugepagesz_setup);
 
 static unsigned int allowed_mems_nr(struct hstate *h)
 {
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-convert-cmdline-parameters-from-setup-to-early
+++ a/mm/hugetlb_vmemmap.c
@@ -444,7 +444,11 @@ DEFINE_STATIC_KEY_FALSE(hugetlb_optimize
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
-core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
+static int __init hugetlb_vmemmap_optimize_param(char *buf)
+{
+	return kstrtobool(buf, &vmemmap_optimize_enabled);
+}
+early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
 
 static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
--- a/mm/mm_init.c~mm-hugetlb-convert-cmdline-parameters-from-setup-to-early
+++ a/mm/mm_init.c
@@ -30,6 +30,7 @@
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
 #include <linux/vmstat.h>
+#include <linux/hugetlb.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -2654,6 +2655,8 @@ static void __init mem_init_print_info(v
  */
 void __init mm_core_init(void)
 {
+	hugetlb_bootmem_alloc();
+
 	/* Initializations relying on SMP setup */
 	BUILD_BUG_ON(MAX_ZONELISTS > 2);
 	build_all_zonelists(NULL);
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

