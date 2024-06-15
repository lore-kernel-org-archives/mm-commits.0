Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83241EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473429; cv=none; b=h3nNy7SoYZvx20ev7kUhcUs3u3XgDGaXU/5VxNJLdEFV5RW36P16Nt+wGaTIbZ/REonZqULYztFt4W4BDtjpY4uq4FWKWS1ElqfNcRbjXyVN6mJEWnT2xDQHoev/q0fEvWkPPDQu87b9mnBhToDjwoGlU4Olgso997I1qx7jLds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473429; c=relaxed/simple;
	bh=P7mebQxWVpmWpKn7jX2a5vv1FfNcj2nC0wt+BwejqHE=;
	h=Date:To:From:Subject:Message-Id; b=kgmFQgE2zOrQlHdWhDxbtfTjZ0FFOcmditAd8iZBv2ozYq3BHk74+WUVk9Gx2uS+ITCqxfq25NIhSpkz1V9l+L0W2lVVVtbNffEbFBb934bQRSE7jMR1J85u569PRj95lG7qm/n0VlTrNMmsN26BSuW9q+VRb4sizm4/Hzm5SjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iqPG6cKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iqPG6cKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E703C116B1;
	Sat, 15 Jun 2024 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473429;
	bh=P7mebQxWVpmWpKn7jX2a5vv1FfNcj2nC0wt+BwejqHE=;
	h=Date:To:From:Subject:From;
	b=iqPG6cKAHLyAu+ehGlnk0zFJKGUfGHo03yUoG5jaqoZ/RKKQcvYcxdQoI5geUd8FM
	 DNZVfSxgOmdDF8PqhJysPEjrpf4/mH4OZ90ZM2wsYQjEnS25dceOJzMMnox5HdHvzb
	 x+M9zby3mNowStnPfCS0rHRUlku1TMdvhRiQJtZw=
Date: Sat, 15 Jun 2024 10:43:48 -0700
To: mm-commits@vger.kernel.org,yjnworkstation@gmail.com,willy@infradead.org,keescook@chromium.org,ioworker0@gmail.com,00107082@163.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-init_mlocked_on_free_v3.patch removed from -mm tree
Message-Id: <20240615174349.7E703C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm: init_mlocked_on_free_v3"
has been removed from the -mm tree.  Its filename was
     revert-mm-init_mlocked_on_free_v3.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Revert "mm: init_mlocked_on_free_v3"
Date: Wed, 5 Jun 2024 11:17:10 +0200

There was insufficient review and no agreement that this is the right
approach.

There are serious flaws with the implementation that make processes using
mlock() not even work with simple fork() [1] and we get reliable crashes
when rebooting.

Further, simply because we might be unmapping a single PTE of a large
mlocked folio, we shouldn't zero out the whole folio.

... especially because the code can also *corrupt* urelated memory because
	kernel_init_pages(page, folio_nr_pages(folio));

Could end up writing outside of the actual folio if we work with a tail
page.

Let's revert it.  Once there is agreement that this is the right approach,
the issues were fixed and there was reasonable review and proper testing,
we can consider it again.

[1] https://lkml.kernel.org/r/4da9da2f-73e4-45fd-b62f-a8a513314057@redhat.com

Link: https://lkml.kernel.org/r/20240605091710.38961-1-david@redhat.com
Fixes: ba42b524a040 ("mm: init_mlocked_on_free_v3")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/lkml/20240528151340.4282-1-00107082@163.com/
Reported-by: Lance Yang <ioworker0@gmail.com>
Closes: https://lkml.kernel.org/r/20240601140917.43562-1-ioworker0@gmail.com
Acked-by: Lance Yang <ioworker0@gmail.com>
Cc: York Jasper Niebuhr <yjnworkstation@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 -
 include/linux/mm.h                              |    9 --
 mm/internal.h                                   |    1 
 mm/memory.c                                     |    6 -
 mm/mm_init.c                                    |   43 ++------------
 mm/page_alloc.c                                 |    2 
 security/Kconfig.hardening                      |   15 ----
 7 files changed, 9 insertions(+), 73 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~revert-mm-init_mlocked_on_free_v3
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2192,12 +2192,6 @@
 			Format: 0 | 1
 			Default set by CONFIG_INIT_ON_FREE_DEFAULT_ON.
 
-	init_mlocked_on_free=	[MM] Fill freed userspace memory with zeroes if
-				it was mlock'ed and not explicitly munlock'ed
-				afterwards.
-				Format: 0 | 1
-				Default set by CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON
-
 	init_pkru=	[X86] Specify the default memory protection keys rights
 			register contents for all processes.  0x55555554 by
 			default (disallow access to all but pkey 0).  Can
--- a/include/linux/mm.h~revert-mm-init_mlocked_on_free_v3
+++ a/include/linux/mm.h
@@ -3776,14 +3776,7 @@ DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_
 static inline bool want_init_on_free(void)
 {
 	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
-				&init_on_free);
-}
-
-DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON, init_mlocked_on_free);
-static inline bool want_init_mlocked_on_free(void)
-{
-	return static_branch_maybe(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON,
-				&init_mlocked_on_free);
+				   &init_on_free);
 }
 
 extern bool _debug_pagealloc_enabled_early;
--- a/mm/internal.h~revert-mm-init_mlocked_on_free_v3
+++ a/mm/internal.h
@@ -588,7 +588,6 @@ extern void __putback_isolated_page(stru
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order);
-extern void kernel_init_pages(struct page *page, int numpages);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
--- a/mm/memory.c~revert-mm-init_mlocked_on_free_v3
+++ a/mm/memory.c
@@ -1507,12 +1507,6 @@ static __always_inline void zap_present_
 		if (unlikely(folio_mapcount(folio) < 0))
 			print_bad_pte(vma, addr, ptent, page);
 	}
-
-	if (want_init_mlocked_on_free() && folio_test_mlocked(folio) &&
-	    !delay_rmap && folio_test_anon(folio)) {
-		kernel_init_pages(page, folio_nr_pages(folio));
-	}
-
 	if (unlikely(__tlb_remove_folio_pages(tlb, page, nr, delay_rmap))) {
 		*force_flush = true;
 		*force_break = true;
--- a/mm/mm_init.c~revert-mm-init_mlocked_on_free_v3
+++ a/mm/mm_init.c
@@ -2523,9 +2523,6 @@ EXPORT_SYMBOL(init_on_alloc);
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
-DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON, init_mlocked_on_free);
-EXPORT_SYMBOL(init_mlocked_on_free);
-
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
 static int __init early_init_on_alloc(char *buf)
@@ -2543,14 +2540,6 @@ static int __init early_init_on_free(cha
 }
 early_param("init_on_free", early_init_on_free);
 
-static bool _init_mlocked_on_free_enabled_early __read_mostly
-				= IS_ENABLED(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON);
-static int __init early_init_mlocked_on_free(char *buf)
-{
-	return kstrtobool(buf, &_init_mlocked_on_free_enabled_early);
-}
-early_param("init_mlocked_on_free", early_init_mlocked_on_free);
-
 DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
 /*
@@ -2578,21 +2567,12 @@ static void __init mem_debugging_and_har
 	}
 #endif
 
-	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early ||
-	    _init_mlocked_on_free_enabled_early) &&
+	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early) &&
 	    page_poisoning_requested) {
 		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-			"will take precedence over init_on_alloc, init_on_free "
-			"and init_mlocked_on_free\n");
+			"will take precedence over init_on_alloc and init_on_free\n");
 		_init_on_alloc_enabled_early = false;
 		_init_on_free_enabled_early = false;
-		_init_mlocked_on_free_enabled_early = false;
-	}
-
-	if (_init_mlocked_on_free_enabled_early && _init_on_free_enabled_early) {
-		pr_info("mem auto-init: init_on_free is on, "
-			"will take precedence over init_mlocked_on_free\n");
-		_init_mlocked_on_free_enabled_early = false;
 	}
 
 	if (_init_on_alloc_enabled_early) {
@@ -2609,17 +2589,9 @@ static void __init mem_debugging_and_har
 		static_branch_disable(&init_on_free);
 	}
 
-	if (_init_mlocked_on_free_enabled_early) {
-		want_check_pages = true;
-		static_branch_enable(&init_mlocked_on_free);
-	} else {
-		static_branch_disable(&init_mlocked_on_free);
-	}
-
-	if (IS_ENABLED(CONFIG_KMSAN) && (_init_on_alloc_enabled_early ||
-	    _init_on_free_enabled_early || _init_mlocked_on_free_enabled_early))
-		pr_info("mem auto-init: please make sure init_on_alloc, init_on_free and "
-			"init_mlocked_on_free are disabled when running KMSAN\n");
+	if (IS_ENABLED(CONFIG_KMSAN) &&
+	    (_init_on_alloc_enabled_early || _init_on_free_enabled_early))
+		pr_info("mem auto-init: please make sure init_on_alloc and init_on_free are disabled when running KMSAN\n");
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (debug_pagealloc_enabled()) {
@@ -2658,10 +2630,9 @@ static void __init report_meminit(void)
 	else
 		stack = "off";
 
-	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s, mlocked free:%s\n",
+	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
 		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
-		want_init_on_free() ? "on" : "off",
-		want_init_mlocked_on_free() ? "on" : "off");
+		want_init_on_free() ? "on" : "off");
 	if (want_init_on_free())
 		pr_info("mem auto-init: clearing system memory may take some time...\n");
 }
--- a/mm/page_alloc.c~revert-mm-init_mlocked_on_free_v3
+++ a/mm/page_alloc.c
@@ -1016,7 +1016,7 @@ static inline bool should_skip_kasan_poi
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-void kernel_init_pages(struct page *page, int numpages)
+static void kernel_init_pages(struct page *page, int numpages)
 {
 	int i;
 
--- a/security/Kconfig.hardening~revert-mm-init_mlocked_on_free_v3
+++ a/security/Kconfig.hardening
@@ -255,21 +255,6 @@ config INIT_ON_FREE_DEFAULT_ON
 	  touching "cold" memory areas. Most cases see 3-5% impact. Some
 	  synthetic workloads have measured as high as 8%.
 
-config INIT_MLOCKED_ON_FREE_DEFAULT_ON
-	bool "Enable mlocked memory zeroing on free"
-	depends on !KMSAN
-	help
-	  This config has the effect of setting "init_mlocked_on_free=1"
-	  on the kernel command line. If it is enabled, all mlocked process
-	  memory is zeroed when freed. This restriction to mlocked memory
-	  improves performance over "init_on_free" but can still be used to
-	  protect confidential data like key material from content exposures
-	  to other processes, as well as live forensics and cold boot attacks.
-	  Any non-mlocked memory is not cleared before it is reassigned. This
-	  configuration can be overwritten by setting "init_mlocked_on_free=0"
-	  on the command line. The "init_on_free" boot option takes
-	  precedence over "init_mlocked_on_free".
-
 config CC_HAS_ZERO_CALL_USED_REGS
 	def_bool $(cc-option,-fzero-call-used-regs=used-gpr)
 	# https://github.com/ClangBuiltLinux/linux/issues/1766
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

