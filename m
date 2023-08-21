Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D95EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjHUUja (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjHUUjU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7FDC7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 400CE64AFB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EC3C433C7;
        Mon, 21 Aug 2023 20:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650354;
        bh=L2FYXfiaSeQbMT8gAj6dHTOCOdD71M3YK/eOT4B6JxY=;
        h=Date:To:From:Subject:From;
        b=s70qC26KqrlgzZlFQxVkTNZgWsYzi8UWpQ4csj1EKQ+sULgkFJgqZgeNSeSd5ReB7
         y1T8xSvBnnQsmYgAGd4q2hD1H+s2MfttcRalkgFdBJTNJHX81ZBDdJj5Tc+2s+/ykk
         LmQM1GMMFvjE/BvSB6aIcP1a9Uovqd7vxXNNDgpE=
Date:   Mon, 21 Aug 2023 13:39:14 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch removed from -mm tree
Message-Id: <20230821203914.97EC3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: damon: use pmdp_get instead of drectly dereferencing pmd
has been removed from the -mm tree.  Its filename was
     damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


