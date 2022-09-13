Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F02C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIMVxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIMVxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3723F6D9FF
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E24D6B810EE
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85769C433D6;
        Tue, 13 Sep 2022 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106006;
        bh=NTWpe60eaYXmaocAYTAWo0OW9JJMbz2VufPq6jvj8sw=;
        h=Date:To:From:Subject:From;
        b=y745BWmTRp7gYT+kx8b6OIny5iGiTDJ6ymGK5k0svBmGDMKUifvcHyISq7GMkloKM
         z3jZ+lcLmOlZZb592mXnK57u5MMZduGDEC+QyR9Y6sIcXvIOHUjd+LSPTCcnz5IS0g
         v6EcaoZXTJsD445WnAthgUIluKuf+49E+tz+AOD0=
Date:   Tue, 13 Sep 2022 14:53:25 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch added to mm-unstable branch
Message-Id: <20220913215326.85769C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: make supported DAMOS actions of paddr clear
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch

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
Subject: mm/damon/paddr: make supported DAMOS actions of paddr clear
Date: Tue, 13 Sep 2022 17:44:28 +0000

Patch series "mm/damon: cleanup code".

DAMON code was not so clean from the beginning, but it has been too much
nowadays, especially due to the duplicates in DAMON_RECLAIM and
DAMON_LRU_SORT.  This patchset cleans some of the mess.


This patch (of 22):

The 'switch-case' statement in 'damon_va_apply_scheme()' function provides
a 'case' for every supported DAMOS action while all not-yet-supported
DAMOS actions fall through the 'default' case, and comment it so that
people can easily know which actions are supported.  Its counterpart in
'paddr', 'damon_pa_apply_scheme()', however, doesn't.  This commit makes
the 'paddr' side function follows the pattern of 'vaddr' for better
readability and consistency.

Link: https://lkml.kernel.org/r/20220913174449.50645-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220913174449.50645-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-make-supported-damos-actions-of-paddr-clear
+++ a/mm/damon/paddr.c
@@ -275,7 +275,10 @@ static unsigned long damon_pa_apply_sche
 		return damon_pa_mark_accessed(r);
 	case DAMOS_LRU_DEPRIO:
 		return damon_pa_deactivate_pages(r);
+	case DAMOS_STAT:
+		break;
 	default:
+		/* DAMOS actions that not yet supported by 'paddr'. */
 		break;
 	}
 	return 0;
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

