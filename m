Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E07E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjJFVsX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjJFVsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97714C6
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38D4C433C7;
        Fri,  6 Oct 2023 21:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628899;
        bh=9r2Y6cTfZpYtbtP6NeWpybZmFHPixGUQjvJ2rePF5IQ=;
        h=Date:To:From:Subject:From;
        b=nMhvc1RzXrrQgxCl9Z8hzxqLI0fLOMaWAuWwPaksjQKorYt2/4izia4jMTuQEb187
         8/KcrLHFZgrQ4OSdeyYMc+GQObeWS5dG+KgB/ou+OEom06uwRv5AHfeRUsoJPd35Tn
         lcNbjV1h6gyskxiYYtxMEyQUJZcX8fkFli3u2YCU=
Date:   Fri, 06 Oct 2023 14:48:16 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, link@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-unnecessary-si_meminfo-invoke.patch removed from -mm tree
Message-Id: <20231006214818.C38D4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: remove unnecessary si_meminfo invoke.
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-unnecessary-si_meminfo-invoke.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huan Yang <link@vivo.com>
Subject: mm/damon/core: remove unnecessary si_meminfo invoke.
Date: Wed, 20 Sep 2023 09:57:27 +0800

si_meminfo() will read and assign more info not just free/ram pages.  For
just DAMOS_WMARK_FREE_MEM_RATE use, only get free and ram pages is ok to
save cpu.

Link: https://lkml.kernel.org/r/20230920015727.4482-1-link@vivo.com
Signed-off-by: Huan Yang <link@vivo.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-unnecessary-si_meminfo-invoke
+++ a/mm/damon/core.c
@@ -1326,12 +1326,10 @@ static bool kdamond_need_stop(struct dam
 
 static unsigned long damos_wmark_metric_value(enum damos_wmark_metric metric)
 {
-	struct sysinfo i;
-
 	switch (metric) {
 	case DAMOS_WMARK_FREE_MEM_RATE:
-		si_meminfo(&i);
-		return i.freeram * 1000 / i.totalram;
+		return global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		       totalram_pages();
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from link@vivo.com are


