Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4B1C61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  2 Feb 2023 23:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjBBXhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjBBXg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 18:36:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48A5123
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 15:36:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88C9561D18
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 23:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96D2C433EF;
        Thu,  2 Feb 2023 23:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675381017;
        bh=F8E3hVfj0H1UmpdBrXggcTCe0572DLG2UQr28aPbEAs=;
        h=Date:To:From:Subject:From;
        b=0SubnJ9hdKO1oWe+hozEN3OEE1/UZMPEVioMKjcQNyznXJ1w9CzWQIsDpaTY4xDW3
         VdONsO2mZVfTMFmNSS33rbjnu+OFp71Oq5yPGTZGba4gsLFwBzdsUdRnZT9E+8pXEy
         CLhtCPL5In9bu3DWho0G2zdYdIdk+0zOc6dXSZhk=
Date:   Thu, 02 Feb 2023 15:36:57 -0800
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        linux@rasmusvillemoes.dk, fuyuanli@didiglobal.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-print-message-when-hung_task_warnings-gets-down-to-zero.patch added to mm-nonmm-unstable branch
Message-Id: <20230202233657.D96D2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task: print message when hung_task_warnings gets down to zero.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-print-message-when-hung_task_warnings-gets-down-to-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-print-message-when-hung_task_warnings-gets-down-to-zero.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

hung_task-print-message-when-hung_task_warnings-gets-down-to-zero.patch

