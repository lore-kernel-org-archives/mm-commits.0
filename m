Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69C5C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C724E610E7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347976AbhIBWCC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWCC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72BE660F56;
        Thu,  2 Sep 2021 22:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620063;
        bh=yJ/c/v/Jsbcr7kQtTIpggM1tcbMiXFW3gWqHugcss9A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2dFJO2ZOJ5tfEBmiCxVdg2W27selw6epS5EIDiXqdaEB3jiydxIacWoN9Gubr+PFm
         ++Ypv/N9UnicBHsaKm/6Le/0cDlIPFhYpq9EYdlxv1CLBGb+mOFgdINhiAPnZK+Rin
         kQj6k21qIP68lO67aQEHlNsu2C7s23/BBiTTvBvg=
Date:   Thu, 02 Sep 2021 15:01:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 209/212] mm/vmstat: correct some wrong comments
Message-ID: <20210902220103.ObyYbTVoC%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1876,11 +1876,6 @@ static void vmstat_update(struct work_st
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
