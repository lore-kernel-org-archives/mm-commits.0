Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1DDC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 22:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjG0WN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjG0WN4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 18:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948B119B
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 15:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F1161F6B
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 22:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74758C433C8;
        Thu, 27 Jul 2023 22:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690496034;
        bh=iVTTnPfUl5Bq5FiET080bCHF4Qvgrx5e4tpFRMWZPqY=;
        h=Date:To:From:Subject:From;
        b=Gha3EGQ3PY+XmE//K9MVZ8ELOH5xn8I6RbBDyJJErvBHb4PcoRGfBUOWzRoRYvW8E
         /B2xi7bjLCCps0nOrxK7R1vgXBrFF+2gMYTt9VMLZQBnxh9pjcsM92XhWqqkUPEacK
         rHex+gajyTGgKkeEm8PzrSmKgSnQxHCsPpk27lEc=
Date:   Thu, 27 Jul 2023 15:13:53 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch added to mm-unstable branch
Message-Id: <20230727221354.74758C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: damon: use pmdp_get instead of drectly dereferencing pmd
has been added to the -mm mm-unstable branch.  Its filename is
     damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch

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
From: Levi Yun <ppbuk5246@gmail.com>
Subject: damon: use pmdp_get instead of drectly dereferencing pmd
Date: Fri, 28 Jul 2023 06:21:57 +0900

As ptep_get, Use the pmdp_get wrapper when we accessing pmdval instead of
directly dereferencing pmd.

Link: https://lkml.kernel.org/r/20230727212157.2985025-1-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 mm/damon/paddr.c      |    2 +-
 mm/damon/vaddr.c      |   23 +++++++++++++++--------
 3 files changed, 17 insertions(+), 10 deletions(-)

--- a/mm/damon/ops-common.c~damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd
+++ a/mm/damon/ops-common.c
@@ -54,7 +54,7 @@ void damon_ptep_mkold(pte_t *pte, struct
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct folio *folio = damon_get_folio(pmd_pfn(*pmd));
+	struct folio *folio = damon_get_folio(pmd_pfn(pmdp_get(pmd)));
 
 	if (!folio)
 		return;
--- a/mm/damon/paddr.c~damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd
+++ a/mm/damon/paddr.c
@@ -94,7 +94,7 @@ static bool __damon_pa_young(struct foli
 				mmu_notifier_test_young(vma->vm_mm, addr);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			*accessed = pmd_young(*pvmw.pmd) ||
+			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 #else
--- a/mm/damon/vaddr.c~damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd
+++ a/mm/damon/vaddr.c
@@ -301,16 +301,19 @@ static int damon_mkold_pmd_entry(pmd_t *
 		unsigned long next, struct mm_walk *walk)
 {
 	pte_t *pte;
+	pmd_t pmde;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge(*pmd)) {
+	if (pmd_trans_huge(pmdp_get(pmd))) {
 		ptl = pmd_lock(walk->mm, pmd);
-		if (!pmd_present(*pmd)) {
+		pmde = pmdp_get(pmd);
+
+		if (!pmd_present(pmde)) {
 			spin_unlock(ptl);
 			return 0;
 		}
 
-		if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_huge(pmde)) {
 			damon_pmdp_mkold(pmd, walk->vma, addr);
 			spin_unlock(ptl);
 			return 0;
@@ -439,21 +442,25 @@ static int damon_young_pmd_entry(pmd_t *
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
+	if (pmd_trans_huge(pmdp_get(pmd))) {
+		pmd_t pmde;
+
 		ptl = pmd_lock(walk->mm, pmd);
-		if (!pmd_present(*pmd)) {
+		pmde = pmdp_get(pmd);
+
+		if (!pmd_present(pmde)) {
 			spin_unlock(ptl);
 			return 0;
 		}
 
-		if (!pmd_trans_huge(*pmd)) {
+		if (!pmd_trans_huge(pmde)) {
 			spin_unlock(ptl);
 			goto regular_page;
 		}
-		folio = damon_get_folio(pmd_pfn(*pmd));
+		folio = damon_get_folio(pmd_pfn(pmde));
 		if (!folio)
 			goto huge_out;
-		if (pmd_young(*pmd) || !folio_test_idle(folio) ||
+		if (pmd_young(pmde) || !folio_test_idle(folio) ||
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are

damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch

