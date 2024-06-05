Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EF5154BE3
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625558; cv=none; b=u99Lf8oP/AqbTcYflCPzHqYh3UIW7yNjwm0xinIl9PcZQ90v9mjEnzEabvXSouLHwyhUlAlOwT8w8xAGn6mJGW9wyQxAYbb5bYarYkM/8nss6AxBDoacO9CmEttCSpmQInHSYL5OS7dQ+Zz7uo7P9crVA1+uhTXReVVUpHccmyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625558; c=relaxed/simple;
	bh=aiGoYsQocCynPUZgqLsWYYRKZ9KvnL2mpCbyihq8AO8=;
	h=Date:To:From:Subject:Message-Id; b=mAixqf4QM0k3bteKnZboUON7MhOlr+mJzBn28XIkzpD8OW/K7HQ1b6ygkI7+cv9KaQ/FPJpsZRWdlPjfzcBcJEPe8Nm+AvIhoRE/gWhEWfYMApWBM+9+rahTxvYfjKZdJhM2LiWOXQFQH95hWKVTKy13O2k2p70VBtrd5T/x10M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wfXagIOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wfXagIOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC50C2BD11;
	Wed,  5 Jun 2024 22:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717625557;
	bh=aiGoYsQocCynPUZgqLsWYYRKZ9KvnL2mpCbyihq8AO8=;
	h=Date:To:From:Subject:From;
	b=wfXagIOTrrew5cCFfo8TAWpF0FzAj72ZbjZbeRLsB1V5UDGff+4G8uJ8nETR7XIDe
	 q8uL2GSo+oz2I0ExAN4xu5UbpC4fcigD7LLTV/jQBChxkOqEW1pyuGKz6yoSHu26jg
	 cIt5a/tFjkelUhjunZ6aXKe5/0VD7piNVa4KjYXg=
Date: Wed, 05 Jun 2024 15:12:36 -0700
To: mm-commits@vger.kernel.org,yjnworkstation@gmail.com,willy@infradead.org,keescook@chromium.org,ioworker0@gmail.com,00107082@163.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-init_mlocked_on_free_v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20240605221237.7CC50C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm: init_mlocked_on_free_v3"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-init_mlocked_on_free_v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-init_mlocked_on_free_v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -2170,12 +2170,6 @@
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

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

