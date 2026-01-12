Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7034A37F750
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243165; cv=none; b=Azpza4dECa0of/bsxnIFECqmayXaQr0DAghnG4ihGW68urK1v57DeWQO8+8VPKyDkduamLlPurXfualB+iIkbULVnTt6ecVKZ+hrvUK5cSyvNjzM43uV3CaP5OVBnDeeXVQut0TE17mgte8hbMKDXMbecVBelbxQVEGiHM3bRQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243165; c=relaxed/simple;
	bh=Jc682f94ENL2uNjoG1rEyO+XfyLIxY4op7FlsmC3mfQ=;
	h=Date:To:From:Subject:Message-Id; b=pwbMgr7DaXQT5n+SUzum53KYts2KlCVzUtsRXdiUt+GCXd9MSful8WypLr/XsW0zEOXjfcbKrOyNDiu89LFQpYkHwu714iHQjg3wQXFhtp9CwOLOKZzVS42JuiTxERskov8F0yT0mPeHkmyIdcOxtj2vrPcxA4r5om1WjJns+x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pH6EQR2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pH6EQR2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EB3C116D0;
	Mon, 12 Jan 2026 18:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243165;
	bh=Jc682f94ENL2uNjoG1rEyO+XfyLIxY4op7FlsmC3mfQ=;
	h=Date:To:From:Subject:From;
	b=pH6EQR2Pv+seTUoZF75+41CKgmhLgHUnV5A99fQzOhFfChFiABl/i0QCZT+5TceO9
	 l1/hrxire15/tjpGXgsPU+CWnLufywznJ5+OAIQPZV37O1pBjgC5prMuZWGzvu5xra
	 I0kuO3Eh5JHCOG2KrKxfmN+AqStOzH3PPSmTEfvw=
Date: Mon, 12 Jan 2026 10:39:24 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yeoreum.yun@arm.com,will@kernel.org,weixugc@google.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,thomas.lendacky@amd.com,tglx@kernel.org,surenb@google.com,smostafa@google.com,samuel.holland@sifive.com,samitolvanen@google.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,osandov@fb.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,justinstitt@google.com,jpoimboe@kernel.org,jeremy.linton@arm.com,jan.kiszka@siemens.com,jackmanb@google.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,axelrasmussen@google.com,ardb@kernel.org,anshuman.khandual@arm.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic.patch added to mm-new branch
Message-Id: <20260112183924.E2EB3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: untag addresses in EXECMEM_ROX related pointer arithmetic
has been added to the -mm mm-new branch.  Its filename is
     mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic.patch

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
Subject: mm/execmem: untag addresses in EXECMEM_ROX related pointer arithmetic
Date: Mon, 12 Jan 2026 17:27:54 +0000

ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release. 
vm_reset_perms() calculates range's start and end addresses using min()
and max() functions.  To do that it compares pointers but, with KASAN
software tags mode enabled, some are tagged - addr variable is, while
start and end variables aren't.  This can cause the wrong address to be
chosen and result in various errors in different places.

Reset tags in the address used as function argument in min(), max().

execmem_cache_add() adds tagged pointers to a maple tree structure, which
then are incorrectly compared when walking the tree.  That results in
different pointers being returned later and page permission violation
errors panicking the kernel.

Reset tag of the address range inserted into the maple tree inside
execmem_vmalloc() which then gets propagated to execmem_cache_add().

Link: https://lkml.kernel.org/r/09f5b8d31aaf87cf2ba30a29c56524fdd4958bcc.1768233085.git.m.wieczorretman@pm.me
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

 mm/execmem.c |    9 ++++++++-
 mm/vmalloc.c |    7 ++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/mm/execmem.c~mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic
+++ a/mm/execmem.c
@@ -59,7 +59,14 @@ static void *execmem_vmalloc(struct exec
 		return NULL;
 	}
 
-	return p;
+	/*
+	 * Resetting the tag here is necessary to avoid the tagged address
+	 * ending up in the maple tree structure. There it's linear address
+	 * can be incorrectly compared with other addresses which can result in
+	 * a wrong address being picked down the line and for example a page
+	 * permission violation error panicking the kernel.
+	 */
+	return kasan_reset_tag(p);
 }
 
 struct vm_struct *execmem_vmap(size_t size)
--- a/mm/vmalloc.c~mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic
+++ a/mm/vmalloc.c
@@ -3359,7 +3359,12 @@ static void vm_reset_perms(struct vm_str
 	 * the vm_unmap_aliases() flush includes the direct map.
 	 */
 	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
-		unsigned long addr = (unsigned long)page_address(area->pages[i]);
+		/*
+		 * Addresses' tag needs resetting so it can be properly used in
+		 * the min() and max() below. Otherwise the start or end values
+		 * might be favoured.
+		 */
+		unsigned long addr = (unsigned long)kasan_reset_tag(page_address(area->pages[i]));
 
 		if (addr) {
 			unsigned long page_size;
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

