Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BB9C6377A
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995BD610CB
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhGOS5S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 14:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242113AbhGOS4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A39613E4;
        Thu, 15 Jul 2021 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626375237;
        bh=EVVZoVytg1avIrnT+jzRMJZQB5t23a/y4OIGBNWbko0=;
        h=Date:From:To:Subject:From;
        b=ZIoNpB3uW0/tEF51BGZP28CZGoo22yzzUXZJPWGcsUaEWNtdOmes9OHqoIHRdewmf
         goLyfFcROZArDYQjwlo7DK8LM7EXXGGX51byDlBYxmoj+WcElnogKdBegmx6JiIvoY
         gIDXZ6ftfPmLdvRDcRGCfz6ceRgWI0JJj/CXuOnU=
Date:   Thu, 15 Jul 2021 11:53:57 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-vmstat-correct-some-wrong-comments.patch added to
 -mm tree
Message-ID: <20210715185357.tDM-byA94%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: correct some wrong comments
has been added to the -mm tree.  Its filename is
     mm-vmstat-correct-some-wrong-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-correct-some-wrong-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-correct-some-wrong-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmstat: correct some wrong comments

Patch series "Cleanup for vmstat".

This series contains cleanups to remove unneeded return value, correct
wrong comment and simplify the array size calculation.  More details can
be found in the respective changelogs.


This patch (of 3):

Correct wrong fls(mem+1) to fls(mem)+1 and remove the duplicated comment
with quiet_vmstat().

Link: https://lkml.kernel.org/r/20210715122911.15700-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210715122911.15700-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-correct-some-wrong-comments
+++ a/mm/vmstat.c
@@ -204,7 +204,7 @@ int calculate_normal_threshold(struct zo
 	 *
 	 * Some sample thresholds:
 	 *
-	 * Threshold	Processors	(fls)	Zonesize	fls(mem+1)
+	 * Threshold	Processors	(fls)	Zonesize	fls(mem)+1
 	 * ------------------------------------------------------------------
 	 * 8		1		1	0.9-1 GB	4
 	 * 16		2		2	0.9-1 GB	4
@@ -1874,11 +1874,6 @@ static void vmstat_update(struct work_st
 }
 
 /*
- * Switch off vmstat processing and then fold all the remaining differentials
- * until the diffs stay at zero. The function is used by NOHZ and can only be
- * invoked when tick processing is not active.
- */
-/*
  * Check if the diffs for a certain cpu indicate that
  * an update is needed.
  */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

