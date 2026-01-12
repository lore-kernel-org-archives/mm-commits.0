Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D193876AA
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243173; cv=none; b=fHqCYUC3y7loYTuektf6/sIZ+idpsDtmPp//faoTwRrAVM3kcQ05rZBphBTTCn9BLxnfvVZi+Ny/ZyHjIivJUS8niezbnIHRljvq4hr+mhijyUFzpY5RYjGhD7kYse/BymbnassvEaGQLNKrwgfGvUvTLIAdINmkRjeht08Dwbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243173; c=relaxed/simple;
	bh=FDlnGVA2kDHhVIBXYKyCYEoZ54hWElbcSlqkSlOPTUg=;
	h=Date:To:From:Subject:Message-Id; b=I6K6hc4Ht5gCRYevK07zAJgr55slVMmmtHoOVqQe+Y6euIyr12TdIjHThjt+v5N/mYAzlkvjyxibJ92XZy4SIy1NT8Ie2denMPBFb4xNfw3Z1DtoU76UB/eWCbEgCq7+dK/oGmGCmAb7Ofk067iwDnninpFvIv3XoXhoNNzGiQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYJSszGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYJSszGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41047C116D0;
	Mon, 12 Jan 2026 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243173;
	bh=FDlnGVA2kDHhVIBXYKyCYEoZ54hWElbcSlqkSlOPTUg=;
	h=Date:To:From:Subject:From;
	b=uYJSszGpr6E09nCPKzMBbx6312qhDoj6prir1UC41TAhjBmD7e9ANLuVrhxQNKENB
	 lfQfsbqkYAEBPNCve4+CpOiIChhF2QqARxygv6AU5tVOEfLHpYbSDhJuBlJD64JWbK
	 SxuLpywABCiG2/EHq9TqlKu6EHMFbRT9eix2pzqI=
Date: Mon, 12 Jan 2026 10:39:32 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yeoreum.yun@arm.com,will@kernel.org,weixugc@google.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,thomas.lendacky@amd.com,tglx@kernel.org,surenb@google.com,smostafa@google.com,samuel.holland@sifive.com,samitolvanen@google.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,osandov@fb.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,justinstitt@google.com,jpoimboe@kernel.org,jeremy.linton@arm.com,jan.kiszka@siemens.com,jackmanb@google.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,axelrasmussen@google.com,ardb@kernel.org,anshuman.khandual@arm.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-lam-compatible-non-canonical-definition.patch added to mm-new branch
Message-Id: <20260112183933.41047C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: LAM compatible non-canonical definition
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-lam-compatible-non-canonical-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-lam-compatible-non-canonical-definition.patch

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
Subject: x86/mm: LAM compatible non-canonical definition
Date: Mon, 12 Jan 2026 17:28:09 +0000

For an address to be canonical it has to have its top bits equal to each
other.  The number of bits depends on the paging level and whether they're
supposed to be ones or zeroes depends on whether the address points to
kernel or user space.

With Linear Address Masking (LAM) enabled, the definition of linear
address canonicality is modified.  Not all of the previously required bits
need to be equal, only the first and last from the previously equal
bitmask.  So for example a 5-level paging kernel address needs to have
bits [63] and [56] set.

Change the canonical checking function to use bit masks instead of bit
shifts.

Link: https://lkml.kernel.org/r/0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>
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

 arch/x86/include/asm/page.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/page.h~x86-mm-lam-compatible-non-canonical-definition
+++ a/arch/x86/include/asm/page.h
@@ -76,9 +76,22 @@ static __always_inline void *pfn_to_kadd
 	return __va(pfn << PAGE_SHIFT);
 }
 
+#ifdef CONFIG_KASAN_SW_TAGS
+#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL((vaddr_bits) - 1))
+#else
+#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
+#endif
+
+/*
+ * To make an address canonical either set or clear the bits defined by the
+ * CANONICAL_MASK(). Clear the bits for userspace addresses if the top address
+ * bit is a zero. Set the bits for kernel addresses if the top address bit is a
+ * one.
+ */
 static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
 {
-	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
+	return (vaddr & BIT_ULL(63)) ? vaddr | CANONICAL_MASK(vaddr_bits) :
+				       vaddr & ~CANONICAL_MASK(vaddr_bits);
 }
 
 static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
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

