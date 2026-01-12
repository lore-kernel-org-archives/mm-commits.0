Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFD237F750
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243184; cv=none; b=OnfRgayG85nrIRVgTuButBTq93TffXtE2JqQx+pB/J86MhK9BI3MdyQEFgBj/VMyJoD04kLxlHpCkpAq/yCkYtz0KD2uGOP7Yf9oR6CGn9lW+CtdSFVq3u+CBIpoQ2QI39vbORxdg77LHVVQhAawcLbn4OlzjUi0NZiK4+tlrGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243184; c=relaxed/simple;
	bh=du2ztmb9pQxakrTjSTcTaOuZ7URz0rYxXQuLA9BMW1Y=;
	h=Date:To:From:Subject:Message-Id; b=loAsb2LDjIBQWO1yUm4+/iajpN4NTI84/9ZGkATJqVE4y/dwH+wv/86+2Vp4bpSFsHdEwT5OwPXKnS2WPTd7U4odMe7jjF0yMlDal6J5UhQlHgSWVgpbyfGs1gh1GZSw0HIR/EIDn4oTfS7rLS8Tem5G9GZukv8LCWHwAPXxeQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sACKmMex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sACKmMex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8B2C116D0;
	Mon, 12 Jan 2026 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243184;
	bh=du2ztmb9pQxakrTjSTcTaOuZ7URz0rYxXQuLA9BMW1Y=;
	h=Date:To:From:Subject:From;
	b=sACKmMexXTA6fOhKzEYI8zCoe9aCQox2TCxLngo29qevDd9YdmVal54PEPdM4BstH
	 pjNsIG1VSMTqbx7XAZdip5cTLIw/9wc5/Pity57y7lirz0tMQa1/hxNkWeyYdYK7xu
	 nKx3vN7v47tIzRsxnh312sYeenbf/23+oXQbLLgw=
Date: Mon, 12 Jan 2026 10:39:43 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yeoreum.yun@arm.com,will@kernel.org,weixugc@google.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,thomas.lendacky@amd.com,tglx@kernel.org,surenb@google.com,smostafa@google.com,samuel.holland@sifive.com,samitolvanen@google.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,osandov@fb.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,justinstitt@google.com,jpoimboe@kernel.org,jeremy.linton@arm.com,jan.kiszka@siemens.com,jackmanb@google.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,axelrasmussen@google.com,ardb@kernel.org,anshuman.khandual@arm.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow.patch added to mm-new branch
Message-Id: <20260112183944.3D8B2C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kasan: logical bit shift for kasan_mem_to_shadow
has been added to the -mm mm-new branch.  Its filename is
     x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow.patch

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
Subject: x86/kasan: logical bit shift for kasan_mem_to_shadow
Date: Mon, 12 Jan 2026 17:28:29 +0000

The tag-based KASAN adopts an arithemitc bit shift to convert a memory
address to a shadow memory address.  While it makes a lot of sense on
arm64, it doesn't work well for all cases on x86 - either the
non-canonical hook becomes quite complex for different paging levels, or
the inline mode would need a lot more adjustments.  Thus the best working
scheme is the logical bit shift and non-canonical shadow offset that x86
uses for generic KASAN, of course adjusted for the increased granularity
from 8 to 16 bytes.

Add an arch specific implementation of kasan_mem_to_shadow() that uses the
logical bit shift.

The non-canonical hook tries to calculate whether an address came from
kasan_mem_to_shadow().  First it checks whether this address fits into the
legal set of values possible to output from the mem to shadow function.

Tie both generic and tag-based x86 KASAN modes to the address range
check associated with generic KASAN.

Link: https://lkml.kernel.org/r/b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me
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

 arch/x86/include/asm/kasan.h |   15 +++++++++++++++
 mm/kasan/report.c            |    5 +++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kasan.h~x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow
+++ a/arch/x86/include/asm/kasan.h
@@ -31,6 +31,21 @@
 #include <linux/bits.h>
 
 #ifdef CONFIG_KASAN_SW_TAGS
+/*
+ * Using the non-arch specific implementation of __kasan_mem_to_shadow() with a
+ * arithmetic bit shift can cause high code complexity in KASAN's non-canonical
+ * hook for x86 or might not work for some paging level and KASAN mode
+ * combinations. The inline mode compiler support could also suffer from higher
+ * complexity for no specific benefit. Therefore the generic mode's logical
+ * shift implementation is used.
+ */
+static inline void *__kasan_mem_to_shadow(const void *addr)
+{
+	return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
+		+ KASAN_SHADOW_OFFSET;
+}
+
+#define kasan_mem_to_shadow(addr)	__kasan_mem_to_shadow(addr)
 #define __tag_shifted(tag)		FIELD_PREP(GENMASK_ULL(60, 57), tag)
 #define __tag_reset(addr)		(sign_extend64((u64)(addr), 56))
 #define __tag_get(addr)			((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)addr))
--- a/mm/kasan/report.c~x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow
+++ a/mm/kasan/report.c
@@ -642,13 +642,14 @@ void kasan_non_canonical_hook(unsigned l
 	const char *bug_type;
 
 	/*
-	 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shift
+	 * For Generic KASAN and Software Tag-Based mode on the x86
+	 * architecture, kasan_mem_to_shadow() uses the logical right shift
 	 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
 	 * both x86 and arm64). Thus, the possible shadow addresses (even for
 	 * bogus pointers) belong to a single contiguous region that is the
 	 * result of kasan_mem_to_shadow() applied to the whole address space.
 	 */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) || IS_ENABLED(CONFIG_X86_64)) {
 		if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
 		    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
 			return;
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

