Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB22937F750
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243187; cv=none; b=JkFLr/wcJvteYSA2gQVdxQo8222THDJ6yMROA8Th91RBMnyJ0DlQqQkhjKfn7X7SUWn60bP2+UltNzBL4ZjeqwQsNHgUMmXpwyZc1gtT7+gCHiJhSB7r1DJ+TEN4t/DB+4g9SljZpfOAkEoRvbz32437DXK9IfrMIOHz04ql0+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243187; c=relaxed/simple;
	bh=cOZkNN3UtocgN6d6kHH4Z90TGWFiidpphRR+5z7fPIo=;
	h=Date:To:From:Subject:Message-Id; b=BdPjgQW3n9gpEzjsB4ivEYd/+bt8w/pwcV2Vlfuk+u3Ive2X0+FBslQ1r4YgazH7RnNJlIzLHD/xg0wnWOr7R60sr9MwQGlQEi08wfOXQe93SLmcjMhvnFwNJKOB2uG2iUpCUvBQpW2AQDBDMpjmZYXwpML0mgAwS0Nau/aqBxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mOzcVVe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mOzcVVe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD9EC116D0;
	Mon, 12 Jan 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243187;
	bh=cOZkNN3UtocgN6d6kHH4Z90TGWFiidpphRR+5z7fPIo=;
	h=Date:To:From:Subject:From;
	b=mOzcVVe/DihgbQz9hZNq57np/1hRyS4CefyTAU9zn/KwsNdlNoLPHZ68GEpcQHvZX
	 BSzzVGk1Ly/Grq12vmUiloxKAsxgJJJ1ooQaal5TDfftMxA2mgjVkKM6N9E9ScByY3
	 qCyxkJhz4jFwcxV7Drxg9zuy/jjynKuqoh7/qpUU=
Date: Mon, 12 Jan 2026 10:39:46 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yeoreum.yun@arm.com,will@kernel.org,weixugc@google.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,thomas.lendacky@amd.com,tglx@kernel.org,surenb@google.com,smostafa@google.com,samuel.holland@sifive.com,samitolvanen@google.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,osandov@fb.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,justinstitt@google.com,jpoimboe@kernel.org,jeremy.linton@arm.com,jan.kiszka@siemens.com,jackmanb@google.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,axelrasmussen@google.com,ardb@kernel.org,anshuman.khandual@arm.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kasan-make-software-tag-based-kasan-available.patch added to mm-new branch
Message-Id: <20260112183947.5DD9EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kasan: make software tag-based kasan available
has been added to the -mm mm-new branch.  Its filename is
     x86-kasan-make-software-tag-based-kasan-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kasan-make-software-tag-based-kasan-available.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: x86/kasan: make software tag-based kasan available
Date: Mon, 12 Jan 2026 17:28:35 +0000

Make CONFIG_KASAN_SW_TAGS available for x86 machines if they have
ADDRESS_MASKING enabled (LAM) as that works similarly to Top-Byte Ignore
(TBI) that allows the software tag-based mode on arm64 platform.

The value for sw_tags KASAN_SHADOW_OFFSET was calculated by rearranging
the formulas for KASAN_SHADOW_START and KASAN_SHADOW_END from
arch/x86/include/asm/kasan.h - the only prerequisites being
KASAN_SHADOW_SCALE_SHIFT of 4, and KASAN_SHADOW_END equal to the one from
KASAN generic mode.

Set scale macro based on KASAN mode: in software tag-based mode 16 bytes
of memory map to one shadow byte and 8 in generic mode.

Disable CONFIG_KASAN_INLINE and CONFIG_KASAN_STACK when
CONFIG_KASAN_SW_TAGS is enabled on x86 until the appropriate compiler
support is available.

Link: https://lkml.kernel.org/r/5b46822936bf9bf7e5cf5d1b57f936345c45a140.1768233085.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/arch/x86/x86_64/mm.rst |    6 ++++--
 arch/x86/Kconfig                     |    4 ++++
 arch/x86/boot/compressed/misc.h      |    1 +
 arch/x86/include/asm/kasan.h         |    5 +++++
 arch/x86/mm/kasan_init_64.c          |    6 ++++++
 lib/Kconfig.kasan                    |    3 ++-
 6 files changed, 22 insertions(+), 3 deletions(-)

--- a/arch/x86/boot/compressed/misc.h~x86-kasan-make-software-tag-based-kasan-available
+++ a/arch/x86/boot/compressed/misc.h
@@ -14,6 +14,7 @@
 #undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 #undef CONFIG_KASAN
 #undef CONFIG_KASAN_GENERIC
+#undef CONFIG_KASAN_SW_TAGS
 
 #define __NO_FORTIFY
 
--- a/arch/x86/include/asm/kasan.h~x86-kasan-make-software-tag-based-kasan-available
+++ a/arch/x86/include/asm/kasan.h
@@ -6,7 +6,12 @@
 #include <linux/kasan-tags.h>
 #include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define KASAN_SHADOW_SCALE_SHIFT 4
+#else
 #define KASAN_SHADOW_SCALE_SHIFT 3
+#endif
 
 /*
  * Compiler uses shadow offset assuming that addresses start
--- a/arch/x86/Kconfig~x86-kasan-make-software-tag-based-kasan-available
+++ a/arch/x86/Kconfig
@@ -67,6 +67,7 @@ config X86
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_CONFIGURES_CPU_MITIGATIONS
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
+	select ARCH_DISABLE_KASAN_INLINE	if X86_64 && KASAN_SW_TAGS
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
@@ -196,6 +197,8 @@ config X86
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if X86_64
 	select HAVE_ARCH_KASAN_VMALLOC		if X86_64
+	select HAVE_ARCH_KASAN_SW_TAGS		if ADDRESS_MASKING
+	select ARCH_NEEDS_DEFER_KASAN		if ADDRESS_MASKING
 	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_KMSAN			if X86_64
 	select HAVE_ARCH_KGDB
@@ -409,6 +412,7 @@ config AUDIT_ARCH
 config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
+	default 0xeffffc0000000000 if KASAN_SW_TAGS
 	default 0xdffffc0000000000
 
 config HAVE_INTEL_TXT
--- a/arch/x86/mm/kasan_init_64.c~x86-kasan-make-software-tag-based-kasan-available
+++ a/arch/x86/mm/kasan_init_64.c
@@ -465,4 +465,10 @@ void __init kasan_init(void)
 
 	init_task.kasan_depth = 0;
 	kasan_init_generic();
+	pr_info("KernelAddressSanitizer initialized\n");
+
+	if (boot_cpu_has(X86_FEATURE_LAM))
+		kasan_init_sw_tags();
+	else
+		pr_info("KernelAddressSanitizer not initialized (sw-tags): hardware doesn't support LAM\n");
 }
--- a/Documentation/arch/x86/x86_64/mm.rst~x86-kasan-make-software-tag-based-kasan-available
+++ a/Documentation/arch/x86/x86_64/mm.rst
@@ -60,7 +60,8 @@ Complete virtual memory map with 4-level
    ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unused hole
    ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual memory map (vmemmap_base)
    ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unused hole
-   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory
+   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory (generic mode)
+   fffff40000000000 |   -8    TB | fffffbffffffffff |    8 TB | KASAN shadow memory (software tag-based mode)
   __________________|____________|__________________|_________|____________________________________________________________
                                                               |
                                                               | Identical layout to the 56-bit one from here on:
@@ -130,7 +131,8 @@ Complete virtual memory map with 5-level
    ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unused hole
    ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual memory map (vmemmap_base)
    ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unused hole
-   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory
+   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory (generic mode)
+   ffeffc0000000000 |   -6    PB | fffffbffffffffff |    4 PB | KASAN shadow memory (software tag-based mode)
   __________________|____________|__________________|_________|____________________________________________________________
                                                               |
                                                               | Identical layout to the 47-bit one from here on:
--- a/lib/Kconfig.kasan~x86-kasan-make-software-tag-based-kasan-available
+++ a/lib/Kconfig.kasan
@@ -112,7 +112,8 @@ config KASAN_SW_TAGS
 
 	  Requires GCC 11+ or Clang.
 
-	  Supported only on arm64 CPUs and relies on Top Byte Ignore.
+	  Supported on arm64 CPUs that support Top Byte Ignore and on x86 CPUs
+	  that support Linear Address Masking.
 
 	  Consumes about 1/16th of available memory at kernel start and
 	  add an overhead of ~20% for dynamic allocations.
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-fix-inline-mode-for-x86-tag-based-mode.patch
x86-kasan-add-arch-specific-kasan-functions.patch
x86-mm-reset-tag-for-virtual-to-physical-address-conversions.patch
mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic.patch
x86-mm-physical-address-comparisons-in-fill_pd-pte.patch
x86-kasan-kasan-raw-shadow-memory-pte-init.patch
x86-mm-lam-compatible-non-canonical-definition.patch
x86-mm-lam-initialization.patch
x86-minimal-slab-alignment.patch
arm64-unify-software-tag-based-kasan-inline-recovery-path.patch
x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow.patch
x86-kasan-make-software-tag-based-kasan-available.patch

