Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D813D64
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722214334; cv=none; b=f7unbfmtmj1HMv/FATO+Alt1gfqI404opiUSLx6wg+bazede2ILBDTQYzcHc+wq0/1MOkLOKt7ySd0479ufGG0KPQeimvqZEErQy5e2mGqor2tCeUnucTlK4lkBsB2qNHILJkaynB8TrrCHJbTmXfdIJ7rbvA4SIHOjYHClIuM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722214334; c=relaxed/simple;
	bh=iSuL1fakndZp0J2zoqbxjlkxgw9Kg25GsmpArqO4Gxw=;
	h=Date:To:From:Subject:Message-Id; b=oCvOgf13XcVE4frnSD1oONWN8YYzc+7WL8zsv910bPYaP/f/OK0Fu7CC+NiB3D3ELyBzJTgoNBGkttGnsiUBJkzp/K+EN7aBNXkOIZ/NtFMdhfMf70g1bqLozZCFEruh322alL/19Hz4XxPZ5Hfyu0sQEBV0Zzdkxt88d2qFYrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aJTj5KbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aJTj5KbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D90C116B1;
	Mon, 29 Jul 2024 00:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722214333;
	bh=iSuL1fakndZp0J2zoqbxjlkxgw9Kg25GsmpArqO4Gxw=;
	h=Date:To:From:Subject:From;
	b=aJTj5KbFC4rH2NumDdtAELbq2z0NZwAB10qrIuomtjVrirjWXjjA6o3MWwbdnI2S7
	 OiXyrl8nd7Bte/it0M0S/+ce9uuyY/LGmdKr7GpVjs95VmO6Qx2dY30t80oriI0ti7
	 WEO5DwVWWwZkSpnZZ/W1Vkwm5n8z1vz11zdWytrA=
Date: Sun, 28 Jul 2024 17:52:13 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@linutronix.de,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,linux@armlinux.org.uk,jgross@suse.com,hpa@zytor.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch added to mm-unstable branch
Message-Id: <20240729005213.B3D90C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: enforce that PMD PT sharing has split PMD PT locks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: enforce that PMD PT sharing has split PMD PT locks
Date: Fri, 26 Jul 2024 17:07:27 +0200

Sharing page tables between processes but falling back to per-MM page
table locks cannot possibly work.

So, let's make sure that we do have split PMD locks by adding a new
Kconfig option and letting that depend on CONFIG_SPLIT_PMD_PTLOCKS.

Link: https://lkml.kernel.org/r/20240726150728.3159964-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig              |    4 ++++
 include/linux/hugetlb.h |    5 ++---
 mm/hugetlb.c            |    8 ++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/fs/Kconfig~mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks
+++ a/fs/Kconfig
@@ -288,6 +288,10 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
+config HUGETLB_PMD_PAGE_TABLE_SHARING
+	def_bool HUGETLB_PAGE
+	depends on ARCH_WANT_HUGE_PMD_SHARE && SPLIT_PMD_PTLOCKS
+
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
 
--- a/include/linux/hugetlb.h~mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks
+++ a/include/linux/hugetlb.h
@@ -1243,7 +1243,7 @@ static inline __init void hugetlb_cma_re
 }
 #endif
 
-#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
 	return page_count(virt_to_page(pte)) > 1;
@@ -1279,8 +1279,7 @@ bool __vma_private_lock(struct vm_area_s
 static inline pte_t *
 hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
 {
-#if defined(CONFIG_HUGETLB_PAGE) && \
-	defined(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) && defined(CONFIG_LOCKDEP)
+#if defined(CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING) && defined(CONFIG_LOCKDEP)
 	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 	/*
--- a/mm/hugetlb.c~mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks
+++ a/mm/hugetlb.c
@@ -7211,7 +7211,7 @@ long hugetlb_unreserve_pages(struct inod
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static unsigned long page_table_shareable(struct vm_area_struct *svma,
 				struct vm_area_struct *vma,
 				unsigned long addr, pgoff_t idx)
@@ -7373,7 +7373,7 @@ int huge_pmd_unshare(struct mm_struct *m
 	return 1;
 }
 
-#else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
+#else /* !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
@@ -7396,7 +7396,7 @@ bool want_pmd_share(struct vm_area_struc
 {
 	return false;
 }
-#endif /* CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
+#endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -7494,7 +7494,7 @@ unsigned long hugetlb_mask_last_page(str
 /* See description above.  Architectures can provide their own version. */
 __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
 {
-#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 	if (huge_page_size(h) == PMD_SIZE)
 		return PUD_SIZE - PMD_SIZE;
 #endif
_

Patches currently in -mm which might be from david@redhat.com are

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch

