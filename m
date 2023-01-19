Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2429C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjASBWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjASBUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792526CCDF
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 018606176F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7B2C433F1;
        Thu, 19 Jan 2023 01:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091003;
        bh=ckBOGl+m8U8OnDNc1bWDHIymENSNHyMqAADXuzsDIIo=;
        h=Date:To:From:Subject:From;
        b=XygliqgSMEUU5iCoTJkDEDxwmz+Mp9wdnBXdSknaH383GarY3duARAVMv5mc0U6vR
         SOc7p4nCBFcoUwrzha4B3C791ryC7StyAkwT+sdiaxXeD+kvceG327S2yOsa4E8o/A
         SmPwp/tDfNUqWO9uYRXJVbVeh5GKs/q+c6pD3oqg=
Date:   Wed, 18 Jan 2023 17:16:42 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch removed from -mm tree
Message-Id: <20230119011643.5B7B2C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: record appropriate folio size when the access is not found
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: record appropriate folio size when the access is not found
Date: Mon, 9 Jan 2023 21:33:32 +0000

DAMON virtual address spaces monitoring operations set doesn't set folio
size of the access checked address if access is not found.  It could
result in unnecessary and inefficient repeated check.  Appropriately set
the size regardless of access check result.

Link: https://lkml.kernel.org/r/20230109213335.62525-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found
+++ a/mm/damon/vaddr.c
@@ -452,10 +452,9 @@ static int damon_young_pmd_entry(pmd_t *
 			goto huge_out;
 		if (pmd_young(*pmd) || !folio_test_idle(folio) ||
 					mmu_notifier_test_young(walk->mm,
-						addr)) {
-			*priv->folio_sz = HPAGE_PMD_SIZE;
+						addr))
 			priv->young = true;
-		}
+		*priv->folio_sz = HPAGE_PMD_SIZE;
 		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
@@ -474,10 +473,9 @@ regular_page:
 	if (!folio)
 		goto out;
 	if (pte_young(*pte) || !folio_test_idle(folio) ||
-			mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->folio_sz = folio_size(folio);
+			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	}
+	*priv->folio_sz = folio_size(folio);
 	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -504,10 +502,9 @@ static int damon_young_hugetlb_entry(pte
 	folio_get(folio);
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
-	    mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->folio_sz = huge_page_size(h);
+	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	}
+	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

