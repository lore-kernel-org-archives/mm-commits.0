Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30027C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 18:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiJCSis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 14:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJCSir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 14:38:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6363342C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 11:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFEE3B811EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 18:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF9C433C1;
        Mon,  3 Oct 2022 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664822323;
        bh=2eHLp8cBdlAlo6P0XgKcPrg+l0TqFOEjo1YyVvlzG6Y=;
        h=Date:To:From:Subject:From;
        b=m9cAd6NcWl28HvIIcwoOk/8fXwePPboePDunTg1bNCONVsl99PXw4pVrP338Jl7EJ
         YB6ScC5vCeNwqhhMsOpdFmBsFhXbnlRACCZzRGpMlVrBSuad7UjIKJwOukky4MoWAY
         T2ndmTRpw4gcLO90QAcGeh4tIMMbP5q2XO4nk0Ek=
Date:   Mon, 03 Oct 2022 11:38:42 -0700
To:     mm-commits@vger.kernel.org, 42.hyeyoo@gmail.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch added to mm-hotfixes-unstable branch
Message-Id: <20221003183843.64FF9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: initialize damon_target->list in damon_new_target()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/core: initialize damon_target->list in damon_new_target()
Date: Sun, 2 Oct 2022 19:31:30 +0000

'struct damon_target' creation function, 'damon_new_target()' is not
initializing its '->list' field, unlike other DAMON structs creator
functions such as 'damon_new_region()'.  Normal users of
'damon_new_target()' initializes the field by adding the target to DAMON
context's targets list, but some code could access the uninitialized
field.

This commit avoids the case by initializing the field in
'damon_new_target()'.

Link: https://lkml.kernel.org/r/20221002193130.8227-1-sj@kernel.org
Fixes: f23b8eee1871 ("mm/damon/core: implement region-based sampling")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-damon_target-list-in-damon_new_target
+++ a/mm/damon/core.c
@@ -313,6 +313,7 @@ struct damon_target *damon_new_target(vo
 	t->pid = NULL;
 	t->nr_regions = 0;
 	INIT_LIST_HEAD(&t->regions_list);
+	INIT_LIST_HEAD(&t->list);
 
 	return t;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch
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

