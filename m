Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF0117993
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958198; cv=none; b=kKWERTj+4Z5VcdbUdoOPJ+YNQozjC3dE2lXCT0mKpvAGy7w3B9QBIgU+JsSEJOLXJ14bo+5zZXohWQXG5JYQKFitt1FgPSDiAiuqizavZXmewYny5R+ROFmFTQLyDJxn3bQ/J4Yfkhyrx9bR/uSDRqx9qe7Eg2VA2rYgabcsAe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958198; c=relaxed/simple;
	bh=/8XtU1y3dOwfQmhSgEJ0xzy6VbmI/V2IKZ+M8Efmzd0=;
	h=Date:To:From:Subject:Message-Id; b=FKLqJfd6qA+UVlvuN56m9L0+Trssc8f++FjEmz+kOMiMiZioiqRzHzhiAnIrbWMq/ezFEnNrp+1E0aJQO9EHA4B19czhEeGU4IwE24zdC82bI4O9Br8aEnLb7l4i9RXpd0ejpGdjh6PsMHbmYUqvillpvIs5pioSEPHbXZ4q2Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XOpgO22B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XOpgO22B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D7CC4CED6;
	Sat,  4 Jan 2025 02:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958196;
	bh=/8XtU1y3dOwfQmhSgEJ0xzy6VbmI/V2IKZ+M8Efmzd0=;
	h=Date:To:From:Subject:From;
	b=XOpgO22BUIrwY/etz5MnVmRjhrjvXkFvvJyBjjDjeHxjXHVp/GwuiertS2j3C/Gi3
	 pgjFfrqO3wDMnyx6/sdIVlK8C36K4RWMXjZLxbs7s4OXo6ceXFtrahOx33b07WoPml
	 v+mQ2s6/I0gQkKl2GmLG7TTRVj+gIEJg92IkVSA8=
Date: Fri, 03 Jan 2025 18:36:35 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-common-part-of-pagetable__ctor-to-helper.patch added to mm-unstable branch
Message-Id: <20250104023636.77D7CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move common part of pagetable_*_ctor to helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-common-part-of-pagetable__ctor-to-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-common-part-of-pagetable__ctor-to-helper.patch

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: move common part of pagetable_*_ctor to helper
Date: Fri, 3 Jan 2025 18:44:10 +0000

Patch series "Account page tables at all levels".

This series should be considered in conjunction with Qi's series [1].
Together, they ensure that page table ctor/dtor are called at all levels
(PTE to PGD) and all architectures, where page tables are regular pages.
Besides the improvement in accounting and general cleanup, this also
create a single place where construction/destruction hooks can be called
for all page tables, namely the now-generic pagetable_dtor() introduced
by Qi, and __pagetable_ctor() introduced in this series.

[1] https://lore.kernel.org/linux-mm/cover.1735549103.git.zhengqi.arch@bytedance.com/


This patch (of 6):

pagetable_*_ctor all have the same basic implementation.  Move the common
part to a helper to reduce duplication.

Link: https://lkml.kernel.org/r/20250103184415.2744423-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20250103184415.2744423-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mm-move-common-part-of-pagetable__ctor-to-helper
+++ a/include/linux/mm.h
@@ -3076,6 +3076,14 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
+static inline void __pagetable_ctor(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
@@ -3093,12 +3101,9 @@ static inline void pagetable_dtor_free(s
 
 static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
 	if (!ptlock_init(ptdesc))
 		return false;
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3202,13 +3207,10 @@ static inline spinlock_t *pmd_lock(struc
 
 static inline bool pagetable_pmd_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
 	if (!pmd_ptlock_init(ptdesc))
 		return false;
-	__folio_set_pgtable(folio);
 	ptdesc_pmd_pts_init(ptdesc);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3233,18 +3235,12 @@ static inline spinlock_t *pud_lock(struc
 
 static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 }
 
 extern void __init pagecache_init(void);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

