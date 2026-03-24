Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9FE34C141
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388568; cv=none; b=eoZFHXxeagkCBA377V+z9eqGefVtVPtM13gE7xHnt9ZTsbkrXINw0ZO01iDQygyso0QK9YrKL+XS/nwXPXizkM0CCgDvVwBKNmUvax8QtUN6gZCCwrOmGGGPbg2phRK6DPqs8VlAI+8CHP8bXquWIJoogKy+JqJvGwfJwH4sXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388568; c=relaxed/simple;
	bh=uM3Cmt5cp2/ODAPFOsmGuB37KUtp4WJhJi2q6zJSrZc=;
	h=Date:To:From:Subject:Message-Id; b=hiZAQWqftCbIHGpEXYCvH0CvOHF8rSMeo1yNzznUq7v72XEs1Xdl+dhCg0MJWeY/DNcNxT5h1//b3Mj0dodLes0J5xgeK8UxO6mP0hOyVDXzxWpiCjjJSK92RAHtiKgifhSSCUxMyw0orTjbTDLvImvzzjFbZRcynrBZk3LJeCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iJsSJypp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iJsSJypp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D085EC19424;
	Tue, 24 Mar 2026 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388567;
	bh=uM3Cmt5cp2/ODAPFOsmGuB37KUtp4WJhJi2q6zJSrZc=;
	h=Date:To:From:Subject:From;
	b=iJsSJyppDZlWoqTeiJ2UU4tEMgJ6XY/hlRjUB4oaci9qHsXH5z4LSw4EoVBULtuhK
	 LpA6/ujZ4nsMZ/gqdVErVa0nRP3V1BWyFBalbCvZ3W51Nv6efXEOuGzPeMwYxUaCeB
	 QxJ97PiMsJCUe33Fcgo6CjviAMPozDfIKA0+FAlk=
Date: Tue, 24 Mar 2026 14:42:47 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,surenb@google.com,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,Liam.Howlett@oracle.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,chleroy@kernel.org,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch removed from -mm tree
Message-Id: <20260324214247.D085EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
has been removed from the -mm tree.  Its filename was
     mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
Date: Wed, 11 Feb 2026 12:31:38 +0200

Patch series "arch, mm: consolidate empty_zero_page", v3.

These patches cleanup handling of ZERO_PAGE() and zero_pfn.


This patch (of 4):

nommu architectures have empty_zero_page and define ZERO_PAGE() and
although they don't really use it to populate page tables, there is no
reason to hardwire !MMU implementation of is_zero_pfn() and my_zero_pfn()
to 0.

Drop #ifdef CONFIG_MMU around implementations of is_zero_pfn() and
my_zero_pfn() and remove !MMU version.

While on it, make zero_pfn __ro_after_init.

Link: https://lkml.kernel.org/r/20260211103141.3215197-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20260211103141.3215197-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   14 +-------------
 mm/memory.c             |   13 -------------
 mm/mm_init.c            |   10 ++++++++++
 3 files changed, 11 insertions(+), 26 deletions(-)

--- a/include/linux/pgtable.h~mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn
+++ a/include/linux/pgtable.h
@@ -1917,7 +1917,6 @@ static inline void pfnmap_setup_cachemod
 	pfnmap_setup_cachemode(pfn, PAGE_SIZE, prot);
 }
 
-#ifdef CONFIG_MMU
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
@@ -1940,18 +1939,7 @@ static inline unsigned long my_zero_pfn(
 	extern unsigned long zero_pfn;
 	return zero_pfn;
 }
-#endif
-#else
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	return 0;
-}
-
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return 0;
-}
-#endif /* CONFIG_MMU */
+#endif /* __HAVE_COLOR_ZERO_PAGE */
 
 #ifdef CONFIG_MMU
 
--- a/mm/memory.c~mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn
+++ a/mm/memory.c
@@ -162,21 +162,8 @@ static int __init disable_randmaps(char
 }
 __setup("norandmaps", disable_randmaps);
 
-unsigned long zero_pfn __read_mostly;
-EXPORT_SYMBOL(zero_pfn);
-
 unsigned long highest_memmap_pfn __read_mostly;
 
-/*
- * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
- */
-static int __init init_zero_pfn(void)
-{
-	zero_pfn = page_to_pfn(ZERO_PAGE(0));
-	return 0;
-}
-early_initcall(init_zero_pfn);
-
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
--- a/mm/mm_init.c~mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn
+++ a/mm/mm_init.c
@@ -53,6 +53,9 @@ EXPORT_SYMBOL(mem_map);
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
 
+unsigned long zero_pfn __ro_after_init;
+EXPORT_SYMBOL(zero_pfn);
+
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
@@ -2672,6 +2675,13 @@ static void __init mem_init_print_info(v
 		);
 }
 
+static int __init init_zero_pfn(void)
+{
+	zero_pfn = page_to_pfn(ZERO_PAGE(0));
+	return 0;
+}
+early_initcall(init_zero_pfn);
+
 void __init __weak arch_mm_preinit(void)
 {
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
userfaultfd-introduce-vm_uffd_ops-fix.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

