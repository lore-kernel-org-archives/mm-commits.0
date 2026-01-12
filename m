Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F07D3793A0
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243158; cv=none; b=RaTxR1AdQL9X2jgo6anOtzeELc/bRJFJj421DQpxKILrVFjA48K/iQyWzmfISMhbT8nPEfwWT04Gpyxmt3QZFi+vi4gWvJIF8pGQgSIU+/M9mXV/uXdD7NkkOVpVA+d/oUOZ6BmXlGAITACh9/xbtc1mzaeS0xlPi1xaw8Xli8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243158; c=relaxed/simple;
	bh=k7Mot9Y/LFECLiA7QAER9qb00cxdw3q6JwkzyEX/hY4=;
	h=Date:To:From:Subject:Message-Id; b=c4Z7HxNLZmnFvbi2HmwaovqpADkih68GIlsbfLT2Zt/eLNwo7Um+LK8vYCRgQK+hktx1JGjSqEtn7jNCvxU9J38ZsoAxb8Ns3i9F+Q4cMM6495K30d4tIqOvX2KW5kE6BIbZ6ANntj1i09xCfrWVPsVYA2IQvWVZYii26N+iCes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N03ezwcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N03ezwcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06DEC116D0;
	Mon, 12 Jan 2026 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243157;
	bh=k7Mot9Y/LFECLiA7QAER9qb00cxdw3q6JwkzyEX/hY4=;
	h=Date:To:From:Subject:From;
	b=N03ezwcmJPAK+P9h6mVfr3/31Wt9w6eTUHnjn17idRCBdk3McG5aMCxczEpBd9w5T
	 pFGb07MgGRQij+AXuysK4tE+I7rB78zd+GlC/1MjyLADFTrtahmtZzc6Cjj+w5foKE
	 66tMO10gw3yha8TFljFnafnvYlILpGtNTuZpV/4U=
Date: Mon, 12 Jan 2026 10:39:17 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yeoreum.yun@arm.com,will@kernel.org,weixugc@google.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,thomas.lendacky@amd.com,tglx@kernel.org,surenb@google.com,smostafa@google.com,samuel.holland@sifive.com,samitolvanen@google.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,osandov@fb.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,justinstitt@google.com,jpoimboe@kernel.org,jeremy.linton@arm.com,jan.kiszka@siemens.com,jackmanb@google.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,axelrasmussen@google.com,ardb@kernel.org,anshuman.khandual@arm.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kasan-add-arch-specific-kasan-functions.patch added to mm-new branch
Message-Id: <20260112183917.B06DEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kasan: add arch specific kasan functions
has been added to the -mm mm-new branch.  Its filename is
     x86-kasan-add-arch-specific-kasan-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kasan-add-arch-specific-kasan-functions.patch

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
Subject: x86/kasan: add arch specific kasan functions
Date: Mon, 12 Jan 2026 17:27:43 +0000

KASAN's software tag-based mode needs multiple macros/functions to handle
tag and pointer interactions - to set, retrieve and reset tags from the
top bits of a pointer.

Mimic functions currently used by arm64 but change the tag's position to
bits [60:57] in the pointer.

Link: https://lkml.kernel.org/r/785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me
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

 arch/x86/include/asm/kasan.h |   42 +++++++++++++++++++++++++++++++--
 include/linux/kasan-tags.h   |    2 +
 include/linux/mmzone.h       |    2 -
 3 files changed, 43 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kasan.h~x86-kasan-add-arch-specific-kasan-functions
+++ a/arch/x86/include/asm/kasan.h
@@ -3,6 +3,8 @@
 #define _ASM_X86_KASAN_H
 
 #include <linux/const.h>
+#include <linux/kasan-tags.h>
+#include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 #define KASAN_SHADOW_SCALE_SHIFT 3
 
@@ -24,8 +26,43 @@
 						  KASAN_SHADOW_SCALE_SHIFT)))
 
 #ifndef __ASSEMBLER__
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define __tag_shifted(tag)		FIELD_PREP(GENMASK_ULL(60, 57), tag)
+#define __tag_reset(addr)		(sign_extend64((u64)(addr), 56))
+#define __tag_get(addr)			((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)addr))
+#else
+#define __tag_shifted(tag)		0UL
+#define __tag_reset(addr)		(addr)
+#define __tag_get(addr)			0
+#endif /* CONFIG_KASAN_SW_TAGS */
+
+#ifdef CONFIG_64BIT
+static inline void *__tag_set(const void *__addr, u8 tag)
+{
+	u64 addr = (u64)__addr;
+
+	addr &= ~__tag_shifted(KASAN_TAG_BYTE_MASK);
+	addr |= __tag_shifted(tag & KASAN_TAG_BYTE_MASK);
+
+	return (void *)addr;
+}
+#else
+static inline void *__tag_set(void *__addr, u8 tag)
+{
+	return __addr;
+}
+#endif
+
+#define arch_kasan_set_tag(addr, tag)	__tag_set(addr, tag)
+#define arch_kasan_reset_tag(addr)	__tag_reset(addr)
+#define arch_kasan_get_tag(addr)	__tag_get(addr)
 
 #ifdef CONFIG_KASAN
+
 void __init kasan_early_init(void);
 void __init kasan_init(void);
 void __init kasan_populate_shadow_for_vaddr(void *va, size_t size, int nid);
@@ -34,8 +71,9 @@ static inline void kasan_early_init(void
 static inline void kasan_init(void) { }
 static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size,
 						   int nid) { }
-#endif
 
-#endif
+#endif /* CONFIG_KASAN */
+
+#endif /* __ASSEMBLER__ */
 
 #endif
--- a/include/linux/kasan-tags.h~x86-kasan-add-arch-specific-kasan-functions
+++ a/include/linux/kasan-tags.h
@@ -10,6 +10,8 @@
 #define KASAN_TAG_WIDTH		0
 #endif
 
+#define KASAN_TAG_BYTE_MASK	((1UL << KASAN_TAG_WIDTH) - 1)
+
 #ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
 #endif
--- a/include/linux/mmzone.h~x86-kasan-add-arch-specific-kasan-functions
+++ a/include/linux/mmzone.h
@@ -1177,7 +1177,7 @@ static inline bool zone_is_empty(const s
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
 #define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_SHIFT) - 1)
-#define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
+#define KASAN_TAG_MASK		KASAN_TAG_BYTE_MASK
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
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

