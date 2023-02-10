Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBE8C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 01:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjBJBFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 20:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjBJBFC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 20:05:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3252C5C8B2
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 17:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E23BFB8235C
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 01:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A727C433EF;
        Fri, 10 Feb 2023 01:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675991099;
        bh=gNVF4+7c0MSaSHSw4L07M+72DQF6tLSwZIK5zOvkgwc=;
        h=Date:To:From:Subject:From;
        b=bTg72OgHiiGvrZ/Q3CoRG3bQYAbz/auVqhxti7dMfI6dJwTT0dsgqQXPQBBN1lD5+
         6ulLM1zbEYOsHhMas/Lk9E8T7u10qnGHW96L8s9nG5koQpfRUKGQvaT8mXzQ0YsVBR
         jU14Og1p02Q42M9aJ52UG4MaybxD1nCiR4NgLKb8=
Date:   Thu, 09 Feb 2023 17:04:59 -0800
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        linux@rasmusvillemoes.dk, fuyuanli@didiglobal.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-print-message-when-hung_task_warnings-gets-down-to-zero.patch removed from -mm tree
Message-Id: <20230210010459.9A727C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hung_task: print message when hung_task_warnings gets down to zero.
has been removed from the -mm tree.  Its filename was
     hung_task-print-message-when-hung_task_warnings-gets-down-to-zero.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: fuyuanli <fuyuanli@didiglobal.com>
Subject: hung_task: print message when hung_task_warnings gets down to zero.
Date: Wed, 1 Feb 2023 21:54:33 +0800

It's useful to report it when hung_task_warnings gets down to zero, so
that we can know if kernel log was lost or there is no hung task was
detected.

Link: https://lkml.kernel.org/r/20230201135416.GA6560@didi-ThinkCentre-M920t-N000
Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/hung_task.c~hung_task-print-message-when-hung_task_warnings-gets-down-to-zero
+++ a/kernel/hung_task.c
@@ -142,6 +142,8 @@ static void check_hung_task(struct task_
 
 		if (sysctl_hung_task_all_cpu_backtrace)
 			hung_task_show_all_bt = true;
+		if (!sysctl_hung_task_warnings)
+			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
 	}
 
 	touch_nmi_watchdog();
_

Patches currently in -mm which might be from fuyuanli@didiglobal.com are


