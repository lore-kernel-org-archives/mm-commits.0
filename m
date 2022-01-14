Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECBBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiANVgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiANVgX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:36:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74DAC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D813B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1A5C36AE5;
        Fri, 14 Jan 2022 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642196180;
        bh=zY2Zn5zvmmQ208R7I7leZOuNHb+LyOmlBRj/pCEAfbs=;
        h=Date:From:To:Subject:From;
        b=yPooA1tw9z/zLNCQqeoYZYLAEXkp262bThScOzb6pLONlv+qBhNVu1a7cEC4yl2zz
         cDCBRDlAb245axnEchZupUGEfvmfaxiP76eQfuBOmv3q7hNAghvQ3UV8ma4ZpNCdrR
         2XwG0jKaL/baKOupcqyyclPbnmsW4vXWGwQWD+g0=
Date:   Fri, 14 Jan 2022 13:36:19 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  [folded-merged]
 mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
 removed from -mm tree
Message-ID: <20220114213619.J4hw8Ggj5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

This patch was dropped because it was folded into mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix

mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch[1],
which is merged in -mm but mainline yet, is making unnecessary function
prototype position changes in the damon.h.  This could make later
'git-blame' a little bit complex.  It also violates the 80 columns limit,
which is not madated but preferred and all other code of DAMON is
following.

This commit fixes those.  This should be folded into the patch before it
is sent to Linus.

[1] https://lore.kernel.org/mm-commits/20211115174837.wvyS8FbLx%25akpm@linux-foundation.org/

Link: https://lkml.kernel.org/r/20211118114827.20052-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++--
 mm/damon/paddr.c      |    5 +++--
 mm/damon/vaddr.c      |    8 +++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
+++ a/include/linux/damon.h
@@ -461,13 +461,13 @@ int damon_stop(struct damon_ctx **ctxs,
 #endif	/* CONFIG_DAMON */
 
 #ifdef CONFIG_DAMON_VADDR
-void damon_va_set_primitives(struct damon_ctx *ctx);
 bool damon_va_target_valid(void *t);
+void damon_va_set_primitives(struct damon_ctx *ctx);
 #endif	/* CONFIG_DAMON_VADDR */
 
 #ifdef CONFIG_DAMON_PADDR
-void damon_pa_set_primitives(struct damon_ctx *ctx);
 bool damon_pa_target_valid(void *t);
+void damon_pa_set_primitives(struct damon_ctx *ctx);
 #endif	/* CONFIG_DAMON_PADDR */
 
 #endif	/* _DAMON_H */
--- a/mm/damon/paddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
+++ a/mm/damon/paddr.c
@@ -246,8 +246,9 @@ static int damon_pa_apply_scheme(struct
 	return 0;
 }
 
-static int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static int damon_pa_scheme_score(struct damon_ctx *context,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
--- a/mm/damon/vaddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix
+++ a/mm/damon/vaddr.c
@@ -292,7 +292,8 @@ static void damon_va_init(struct damon_c
  *
  * Returns true if it is.
  */
-static bool damon_intersect(struct damon_region *r, struct damon_addr_range *re)
+static bool damon_intersect(struct damon_region *r,
+		struct damon_addr_range *re)
 {
 	return !(r->ar.end <= re->start || re->end <= r->ar.start);
 }
@@ -633,8 +634,9 @@ static int damon_va_apply_scheme(struct
 	return damos_madvise(t, r, madv_action);
 }
 
-static int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static int damon_va_scheme_score(struct damon_ctx *context,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 
 	switch (scheme->action) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch
mm-damon-dbgfs-remove-a-unnecessary-variable.patch
mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch
mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

