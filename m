Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1EFC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 283FB6120D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhKESwj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhKESwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:52:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68DE06120D;
        Fri,  5 Nov 2021 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636138198;
        bh=6Fquk5Ep1jBWoSCLshalzBdyuA3uu7eZF4Dx+qyPEzo=;
        h=Date:From:To:Subject:From;
        b=x7cMoEIhZGNxWlQWO5gz42mJe8uaZzQ9GHlhhJVl0u2Lvkv4ID+m2y6IGRLVZItur
         YDxthiOh/uH9OVxSAA4R3DAEMmRvoHGtjESOWZaMGrkqsf3xGH5yj3s93fkbJ+woDQ
         maQSSaWrFdqgPFa1k2zzGMwHBf1YhGSH0SDT/E0E=
Date:   Fri, 05 Nov 2021 11:49:57 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [folded-merged]
 mm-damon-paddr-support-the-pageout-scheme-fix.patch removed from -mm tree
Message-ID: <20211105184957.oKgy5YzBv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: fix missing-prototype build warning for 'damon_pa_apply_scheme()'
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-the-pageout-scheme-fix.patch

This patch was dropped because it was folded into mm-damon-paddr-support-the-pageout-scheme.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: fix missing-prototype build warning for 'damon_pa_apply_scheme()'

Kernel test robot found[1] commit ccd554f15bb1 ("mm/damon/paddr: support
the pageout scheme") on the -mm tree[2], which is introduced by the patch
titled 'mm-damon-paddr-support-the-pageout-scheme.patch'[3] introduces
following build warning, and therefore the build fails if
'CONFIG_WERROR=y'.

    linux/mm/damon/paddr.c:216:5: error: no previous prototype for `damon_pa_apply_scheme' [-Werror=missing-prototypes]
     int damon_pa_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
         ^~~~~~~~~~~~~~~~~~~~~
    cc1: all warnings being treated as errors
    linux/scripts/Makefile.build:277: recipe for target 'mm/damon/paddr.o' failed

This commit fixes the warning by adding the missed prototype in the
header file.

Note: Because the reported '.config' introduces warnings on not only DAMON
but also other subsystems, I tested for only DAMON by adding the below
compiler flag in mm/damon/Makefile.

    ccflags-$(CONFIG_DAMON_PADDR)  += -Werror -Wmissing-prototypes

[1] https://lore.kernel.org/lkml/202110250029.5rftt73s-lkp@intel.com/
[2] https://github.com/hnaz/linux-mm/commit/ccd554f15bb1cd977d740c1ea8241ecf95108c94
[3] https://lore.kernel.org/mm-commits/20211019213137.91_rr1GrX%25akpm@linux-foundation.org/

Link: https://lkml.kernel.org/r/20211025064220.13904-1-sj@kernel.org
Fixes: ccd554f15bb1 ("mm/damon/paddr: support the pageout scheme") in -mm tree
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/damon.h~mm-damon-paddr-support-the-pageout-scheme-fix
+++ a/include/linux/damon.h
@@ -357,6 +357,8 @@ void damon_va_set_primitives(struct damo
 void damon_pa_prepare_access_checks(struct damon_ctx *ctx);
 unsigned int damon_pa_check_accesses(struct damon_ctx *ctx);
 bool damon_pa_target_valid(void *t);
+int damon_pa_apply_scheme(struct damon_ctx *context, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme);
 void damon_pa_set_primitives(struct damon_ctx *ctx);
 
 #endif	/* CONFIG_DAMON_PADDR */
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
docs-admin-guide-mm-damon-start-simplify-the-content.patch
docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

