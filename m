Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7196AAD
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711768025; cv=none; b=IsmrgcT22ZyAvNHO4FUNr6sztK9/0sdwkwTEA8vtSIodbhBLyTpbLDcoDMhfITaEQgfSchWzuGgI2mMWMey4UK/JxlgCAXsW/5zQpotNcu5ZLOdVaCAs3a3o0fd4aQWlEwVEXBOlEq3UIo2Qp6Bzc6BIIQYjU3CiD7/jTGalJN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711768025; c=relaxed/simple;
	bh=O9WGivuOpNkfQhx7OMO7C5ruDu01XZHtAqEE7CwL408=;
	h=Date:To:From:Subject:Message-Id; b=K/B/ZjNLJllQBd4VSpgv3c7WTEIYKLb+yuVRYsmrOR552z80hhupAAzIOSR3k66jKnieT7vpmDxFI3RnrkC/MmBHrdh1vxO1ZoGhHMW1aZDr5GGsnJU9dFAf98btUme6X2foK3zK6knAnydLtced3GF1n7GwdEVM22s/v/tEm9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=THY06buJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="THY06buJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5245FC433F1;
	Sat, 30 Mar 2024 03:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711768024;
	bh=O9WGivuOpNkfQhx7OMO7C5ruDu01XZHtAqEE7CwL408=;
	h=Date:To:From:Subject:From;
	b=THY06buJ2VzEHrhR1WcUN+eb7OuOUa2/e5YCAiNWdjEMtiy8nPHLz+kAWHN4WcJvu
	 ffhKRTzXaDO21+tqJS0XLeT2q3nWBAbvKFGJyN2DpxTrlnd3qPifxP50bsuD9cv/OC
	 557CODOZ4zc3AqvQ7J6ek0iR8iw2EskI/FYmERnI=
Date: Fri, 29 Mar 2024 20:07:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,keescook@chromium.org,yjnworkstation@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-init_mlocked_on_free_v3.patch added to mm-unstable branch
Message-Id: <20240330030704.5245FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: init_mlocked_on_free_v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-init_mlocked_on_free_v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-init_mlocked_on_free_v3.patch

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
From: York Jasper Niebuhr <yjnworkstation@gmail.com>
Subject: mm: init_mlocked_on_free_v3
Date: Fri, 29 Mar 2024 15:56:05 +0100

Implements the "init_mlocked_on_free" boot option. When this boot option
is enabled, any mlock'ed pages are zeroed on free. If
the pages are munlock'ed beforehand, no initialization takes place.
This boot option is meant to combat the performance hit of
"init_on_free" as reported in commit 6471384af2a6 ("mm: security:
introduce init_on_alloc=1 and init_on_free=1 boot options"). With
"init_mlocked_on_free=1" only relevant data is freed while everything
else is left untouched by the kernel. Correspondingly, this patch
introduces no performance hit for unmapping non-mlock'ed memory. The
unmapping overhead for purely mlocked memory was measured to be
approximately 13%. Realistically, most systems mlock only a fraction of
the total memory so the real-world system overhead should be close to
zero.

Optimally, userspace programs clear any key material or other
confidential memory before exit and munlock the according memory
regions. If a program crashes, userspace key managers fail to do this
job. Accordingly, no munlock operations are performed so the data is
caught and zeroed by the kernel. Should the program not crash, all
memory will ideally be munlocked so no overhead is caused.

CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON can be set to enable
"init_mlocked_on_free" by default.

Link: https://lkml.kernel.org/r/20240329145605.149917-1-yjnworkstation@gmail.com
Signed-off-by: York Jasper Niebuhr <yjnworkstation@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: York Jasper Niebuhr <yjnworkstation@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 +
 include/linux/mm.h                              |    9 ++
 mm/internal.h                                   |    1 
 mm/memory.c                                     |    6 +
 mm/mm_init.c                                    |   43 +++++++++++---
 mm/page_alloc.c                                 |    2 
 security/Kconfig.hardening                      |   15 ++++
 7 files changed, 73 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-init_mlocked_on_free_v3
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2148,6 +2148,12 @@
 			Format: 0 | 1
 			Default set by CONFIG_INIT_ON_FREE_DEFAULT_ON.
 
+	init_mlocked_on_free=	[MM] Fill freed userspace memory with zeroes if
+				it was mlock'ed and not explicitly munlock'ed
+				afterwards.
+				Format: 0 | 1
+				Default set by CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON
+
 	init_pkru=	[X86] Specify the default memory protection keys rights
 			register contents for all processes.  0x55555554 by
 			default (disallow access to all but pkey 0).  Can
--- a/include/linux/mm.h~mm-init_mlocked_on_free_v3
+++ a/include/linux/mm.h
@@ -3761,7 +3761,14 @@ DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_
 static inline bool want_init_on_free(void)
 {
 	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
-				   &init_on_free);
+				&init_on_free);
+}
+
+DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON, init_mlocked_on_free);
+static inline bool want_init_mlocked_on_free(void)
+{
+	return static_branch_maybe(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON,
+				&init_mlocked_on_free);
 }
 
 extern bool _debug_pagealloc_enabled_early;
--- a/mm/internal.h~mm-init_mlocked_on_free_v3
+++ a/mm/internal.h
@@ -562,6 +562,7 @@ extern void __putback_isolated_page(stru
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order);
+extern void kernel_init_pages(struct page *page, int numpages);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
--- a/mm/memory.c~mm-init_mlocked_on_free_v3
+++ a/mm/memory.c
@@ -1506,6 +1506,12 @@ static __always_inline void zap_present_
 		if (unlikely(page_mapcount(page) < 0))
 			print_bad_pte(vma, addr, ptent, page);
 	}
+
+	if (want_init_mlocked_on_free() && folio_test_mlocked(folio) &&
+	    !delay_rmap && folio_test_anon(folio)) {
+		kernel_init_pages(page, folio_nr_pages(folio));
+	}
+
 	if (unlikely(__tlb_remove_folio_pages(tlb, page, nr, delay_rmap))) {
 		*force_flush = true;
 		*force_break = true;
--- a/mm/mm_init.c~mm-init_mlocked_on_free_v3
+++ a/mm/mm_init.c
@@ -2515,6 +2515,9 @@ EXPORT_SYMBOL(init_on_alloc);
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON, init_mlocked_on_free);
+EXPORT_SYMBOL(init_mlocked_on_free);
+
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
 static int __init early_init_on_alloc(char *buf)
@@ -2532,6 +2535,14 @@ static int __init early_init_on_free(cha
 }
 early_param("init_on_free", early_init_on_free);
 
+static bool _init_mlocked_on_free_enabled_early __read_mostly
+				= IS_ENABLED(CONFIG_INIT_MLOCKED_ON_FREE_DEFAULT_ON);
+static int __init early_init_mlocked_on_free(char *buf)
+{
+	return kstrtobool(buf, &_init_mlocked_on_free_enabled_early);
+}
+early_param("init_mlocked_on_free", early_init_mlocked_on_free);
+
 DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
 /*
@@ -2559,12 +2570,21 @@ static void __init mem_debugging_and_har
 	}
 #endif
 
-	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early) &&
+	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early ||
+	    _init_mlocked_on_free_enabled_early) &&
 	    page_poisoning_requested) {
 		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-			"will take precedence over init_on_alloc and init_on_free\n");
+			"will take precedence over init_on_alloc, init_on_free "
+			"and init_mlocked_on_free\n");
 		_init_on_alloc_enabled_early = false;
 		_init_on_free_enabled_early = false;
+		_init_mlocked_on_free_enabled_early = false;
+	}
+
+	if (_init_mlocked_on_free_enabled_early && _init_on_free_enabled_early) {
+		pr_info("mem auto-init: init_on_free is on, "
+			"will take precedence over init_mlocked_on_free\n");
+		_init_mlocked_on_free_enabled_early = false;
 	}
 
 	if (_init_on_alloc_enabled_early) {
@@ -2581,9 +2601,17 @@ static void __init mem_debugging_and_har
 		static_branch_disable(&init_on_free);
 	}
 
-	if (IS_ENABLED(CONFIG_KMSAN) &&
-	    (_init_on_alloc_enabled_early || _init_on_free_enabled_early))
-		pr_info("mem auto-init: please make sure init_on_alloc and init_on_free are disabled when running KMSAN\n");
+	if (_init_mlocked_on_free_enabled_early) {
+		want_check_pages = true;
+		static_branch_enable(&init_mlocked_on_free);
+	} else {
+		static_branch_disable(&init_mlocked_on_free);
+	}
+
+	if (IS_ENABLED(CONFIG_KMSAN) && (_init_on_alloc_enabled_early ||
+	    _init_on_free_enabled_early || _init_mlocked_on_free_enabled_early))
+		pr_info("mem auto-init: please make sure init_on_alloc, init_on_free and "
+			"init_mlocked_on_free are disabled when running KMSAN\n");
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (debug_pagealloc_enabled()) {
@@ -2622,9 +2650,10 @@ static void __init report_meminit(void)
 	else
 		stack = "off";
 
-	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
+	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s, mlocked free:%s\n",
 		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
-		want_init_on_free() ? "on" : "off");
+		want_init_on_free() ? "on" : "off",
+		want_init_mlocked_on_free() ? "on" : "off");
 	if (want_init_on_free())
 		pr_info("mem auto-init: clearing system memory may take some time...\n");
 }
--- a/mm/page_alloc.c~mm-init_mlocked_on_free_v3
+++ a/mm/page_alloc.c
@@ -1038,7 +1038,7 @@ static inline bool should_skip_kasan_poi
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-static void kernel_init_pages(struct page *page, int numpages)
+void kernel_init_pages(struct page *page, int numpages)
 {
 	int i;
 
--- a/security/Kconfig.hardening~mm-init_mlocked_on_free_v3
+++ a/security/Kconfig.hardening
@@ -255,6 +255,21 @@ config INIT_ON_FREE_DEFAULT_ON
 	  touching "cold" memory areas. Most cases see 3-5% impact. Some
 	  synthetic workloads have measured as high as 8%.
 
+config INIT_MLOCKED_ON_FREE_DEFAULT_ON
+	bool "Enable mlocked memory zeroing on free"
+	depends on !KMSAN
+	help
+	  This config has the effect of setting "init_mlocked_on_free=1"
+	  on the kernel command line. If it is enabled, all mlocked process
+	  memory is zeroed when freed. This restriction to mlocked memory
+	  improves performance over "init_on_free" but can still be used to
+	  protect confidential data like key material from content exposures
+	  to other processes, as well as live forensics and cold boot attacks.
+	  Any non-mlocked memory is not cleared before it is reassigned. This
+	  configuration can be overwritten by setting "init_mlocked_on_free=0"
+	  on the command line. The "init_on_free" boot option takes
+	  precedence over "init_mlocked_on_free".
+
 config CC_HAS_ZERO_CALL_USED_REGS
 	def_bool $(cc-option,-fzero-call-used-regs=used-gpr)
 	# https://github.com/ClangBuiltLinux/linux/issues/1766
_

Patches currently in -mm which might be from yjnworkstation@gmail.com are

mm-init_mlocked_on_free_v3.patch

