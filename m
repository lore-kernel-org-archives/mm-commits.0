Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA04DC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjASBWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjASBUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9356CCDD
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D34561B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00877C433D2;
        Thu, 19 Jan 2023 01:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091002;
        bh=+46+Kojqs75mufJut2Bx7EBopXuJlQJXAQjdF+5NzQ0=;
        h=Date:To:From:Subject:From;
        b=L1g954wJSuokPDlyOhMPTZwC2hfv3+Ie8UoIdeNZHIoMeJBCNWlKIQ50+vrN/IpF8
         Kj0d9w9MDktxUI5z7PKmjlZGuyMvRZZrAmW4CjkNqE4wCBJVOIW5ZIo5adl1jC8CHf
         ybclug87MNGFVF2/w613xz7MZQn8VwlSGb5D14QI=
Date:   Wed, 18 Jan 2023 17:16:41 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size.patch removed from -mm tree
Message-Id: <20230119011642.00877C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: support folio of neither HPAGE_PMD_SIZE nor PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: support folio of neither HPAGE_PMD_SIZE nor PAGE_SIZE
Date: Mon, 9 Jan 2023 21:33:31 +0000

DAMON virtual address space monitoring operations set treats folios having
non-HPAGE_PMD_SIZE size as having PAGE_SIZE size.  Use the exact size of
the folio.

Link: https://lkml.kernel.org/r/20230109213335.62525-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size
+++ a/mm/damon/vaddr.c
@@ -475,7 +475,7 @@ regular_page:
 		goto out;
 	if (pte_young(*pte) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->folio_sz = PAGE_SIZE;
+		*priv->folio_sz = folio_size(folio);
 		priv->young = true;
 	}
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

