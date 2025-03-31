Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD4DDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457099; cv=none; b=uov64RgnI31vDK0+uYDhFRpWFJFKFstpph5yQMRnqETemz3eJnFRs3MVPdDdR5EzcpEAVjykiUZ02H92v1Dtz1jXMANmi2wIYMPogZtk5XzDB+ZE37Pa4AtcmwHyfoIgoT6zof6jvL1qQmDlmwNwceMi9FRWh5gnofdps3WH29Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457099; c=relaxed/simple;
	bh=C2QMAU8vdDuI8z90Cjl7b+M2VmygNivnV9glczIkJ/8=;
	h=Date:To:From:Subject:Message-Id; b=BHwAOIjAIfn0NmKizM2+Gx5qlBEIPbmwAHj9CY8+JszpMA7IvWsvEZ/xMRoP5WOEtaxNpNtg8vNAnGu48NxYvHepPuTOWpve78f9mw92OaDwxEgD6k0aijdj3iOUh+X4p8cGIuCHjJC8Hs5j3J4vmUU9sYZcxrTUGf6I7mbnW0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DIqEWxGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DIqEWxGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA1C4CEE3;
	Mon, 31 Mar 2025 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457099;
	bh=C2QMAU8vdDuI8z90Cjl7b+M2VmygNivnV9glczIkJ/8=;
	h=Date:To:From:Subject:From;
	b=DIqEWxGBsz0CC0HFwy/H3ZKUBv6r571BxkPxcEv/lXN6ZS9t5cREPLJptYl0gqjni
	 Q7uj0y69GAI7Uk6UAOPe1xKXuHG0WX1ETqVq52YCisQ83mHJB29YrBh3nJdhppiyBu
	 CuUmPVx3NifBMtLXQcO6HFoKjbeZgvk2SApHGV+I=
Date: Mon, 31 Mar 2025 14:38:18 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-remove-unneeded-pgd_devmap.patch added to mm-new branch
Message-Id: <20250331213819.3CFA1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pgtable: remove unneeded pgd_devmap()
has been added to the -mm mm-new branch.  Its filename is
     mm-pgtable-remove-unneeded-pgd_devmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-remove-unneeded-pgd_devmap.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/pgtable: remove unneeded pgd_devmap()
Date: Mon, 31 Mar 2025 16:13:27 +0800

There's no user of pgd_devmap() now, remove it from all ARCH-es
and linux/pgtable.h.

Link: https://lkml.kernel.org/r/20250331081327.256412-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: <x86@kernel.org>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h             |    5 -----
 arch/loongarch/include/asm/pgtable.h         |    1 -
 arch/powerpc/include/asm/book3s/64/pgtable.h |    5 -----
 arch/riscv/include/asm/pgtable-64.h          |    5 -----
 arch/x86/include/asm/pgtable.h               |    5 -----
 include/linux/pgtable.h                      |    4 ----
 6 files changed, 25 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-pgtable-remove-unneeded-pgd_devmap
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1200,11 +1200,6 @@ static inline int pud_devmap(pud_t pud)
 {
 	return 0;
 }
-
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
--- a/arch/loongarch/include/asm/pgtable.h~mm-pgtable-remove-unneeded-pgd_devmap
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -615,7 +615,6 @@ static inline long pmd_protnone(pmd_t pm
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pud_devmap(pud)		(0)
-#define pgd_devmap(pgd)		(0)
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-pgtable-remove-unneeded-pgd_devmap
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1405,11 +1405,6 @@ static inline int pud_devmap(pud_t pud)
 {
 	return pte_devmap(pud_pte(pud));
 }
-
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
--- a/arch/riscv/include/asm/pgtable-64.h~mm-pgtable-remove-unneeded-pgd_devmap
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -411,11 +411,6 @@ static inline int pud_devmap(pud_t pud)
 {
 	return 0;
 }
-
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
 #endif
 
 #endif /* _ASM_RISCV_PGTABLE_64_H */
--- a/arch/x86/include/asm/pgtable.h~mm-pgtable-remove-unneeded-pgd_devmap
+++ a/arch/x86/include/asm/pgtable.h
@@ -361,11 +361,6 @@ static inline pud_t pud_mkspecial(pud_t
 	return pud_set_flags(pud, _PAGE_SPECIAL);
 }
 #endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
-
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
--- a/include/linux/pgtable.h~mm-pgtable-remove-unneeded-pgd_devmap
+++ a/include/linux/pgtable.h
@@ -1617,10 +1617,6 @@ static inline int pud_devmap(pud_t pud)
 {
 	return 0;
 }
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
 #endif
 
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

