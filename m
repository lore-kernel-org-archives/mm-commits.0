Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED46ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIMVxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiIMVxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFDC6DAC2
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA8E4B810EA
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739E8C433D6;
        Tue, 13 Sep 2022 21:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106008;
        bh=E1cw2mp5ETWUA1dBHja5dMGgpVyH6xSehuVoZDETn9g=;
        h=Date:To:From:Subject:From;
        b=MtH0sM/Mlq7Dl2PTt58KU7fph32Wfd2YyxBfAZ10RXucFdNzSzgn1/6Rr4Wf+/jhe
         TUDNvXdRTmp3YKk0tZCg+GS1YAUfsdtK1xEqYrbv7gxHuzezmKXoydYhrfGCanjIQB
         BZ2p2QwF7Gts1eD0ofz/WR1UmjiA3j5jecykwki0=
Date:   Tue, 13 Sep 2022 14:53:27 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch added to mm-unstable branch
Message-Id: <20220913215328.739E8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: deduplicate damon_pa_{mark_accessed,deactivate_pages}()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: deduplicate damon_pa_{mark_accessed,deactivate_pages}()
Date: Tue, 13 Sep 2022 17:44:29 +0000

The bodies of damon_pa_{mark_accessed,deactivate_pages}() contains
duplicates.  This commit factors out the common part to a separate
function and removes the duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages
+++ a/mm/damon/paddr.c
@@ -232,7 +232,8 @@ static unsigned long damon_pa_pageout(st
 	return applied * PAGE_SIZE;
 }
 
-static unsigned long damon_pa_mark_accessed(struct damon_region *r)
+static inline unsigned long damon_pa_mark_accessed_or_deactivate(
+		struct damon_region *r, bool mark_accessed)
 {
 	unsigned long addr, applied = 0;
 
@@ -241,27 +242,24 @@ static unsigned long damon_pa_mark_acces
 
 		if (!page)
 			continue;
-		mark_page_accessed(page);
+		if (mark_accessed)
+			mark_page_accessed(page);
+		else
+			deactivate_page(page);
 		put_page(page);
 		applied++;
 	}
 	return applied * PAGE_SIZE;
 }
 
-static unsigned long damon_pa_deactivate_pages(struct damon_region *r)
+static unsigned long damon_pa_mark_accessed(struct damon_region *r)
 {
-	unsigned long addr, applied = 0;
-
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
-		struct page *page = damon_get_page(PHYS_PFN(addr));
+	return damon_pa_mark_accessed_or_deactivate(r, true);
+}
 
-		if (!page)
-			continue;
-		deactivate_page(page);
-		put_page(page);
-		applied++;
-	}
-	return applied * PAGE_SIZE;
+static unsigned long damon_pa_deactivate_pages(struct damon_region *r)
+{
+	return damon_pa_mark_accessed_or_deactivate(r, false);
 }
 
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch
mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch
mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch
mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch
mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch
mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch
mm-damon-core-reduce-parameters-for-damon_set_attrs.patch
mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch
mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch
mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch
mm-damon-reclaim-use-stat-parameters-generator.patch
mm-damon-lru_sort-use-stat-generator.patch
mm-damon-modules-common-implement-a-damos-quota-params-generator.patch
mm-damon-modules-common-implement-damos-time-quota-params-generator.patch
mm-damon-reclaim-use-the-quota-params-generator-macro.patch
mm-damon-lru_sort-use-quotas-param-generator.patch
mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

