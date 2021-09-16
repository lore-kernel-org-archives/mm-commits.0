Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F91DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E04061251
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhIPTpz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233076AbhIPTpw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:45:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1E3C61250;
        Thu, 16 Sep 2021 19:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631821471;
        bh=g8NJaU+2Tj4QQUo/DzD2qeSJxqO94fPkWC/1ESbxci8=;
        h=Date:From:To:Subject:From;
        b=UvdzK3qe7ZT7BLQU/pbz4kuG2FS4EpDKrZiTU6NPg/WiKFhe5oB3BmK/mEBcUDq9y
         CGhb2I5ZEU45D4I5Q/MrSjHVw7ty1yS5uqvM5snPBkBUzdqPx8NWAKHuES6UWmRvsu
         A8udiRm+t7Y7CMgvH7/AYarSSXNOFpkPJS4Y9cd0=
Date:   Thu, 16 Sep 2021 12:44:31 -0700
From:   akpm@linux-foundation.org
To:     guojinhui@huawei.com, mm-commits@vger.kernel.org, pmladek@suse.com
Subject:  [to-be-updated]
 watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch removed from
 -mm tree
Message-ID: <20210916194431.LMZDS7Wd6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/softlockup: fix softlockup_stop_all() hungtask bug
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jinhui Guo <guojinhui@huawei.com>
Subject: watchdog/softlockup: fix softlockup_stop_all() hungtask bug

If NR_CPUS equal to 1, it would trigger hungtask, it can be
triggered by follow command:
	echo 0 > /proc/sys/kernel/watchdog
	echo 1 > /proc/sys/kernel/watchdog
The hungtask stack:
	__schedule
	schedule
	schedule_timeout
	__wait_for_common
	softlockup_stop_fn
	lockup_detector_reconfigure
	proc_watchdog_common
	proc_watchdog
	proc_sys_call_handler
	vfs_write
	ksys_write
The watchdog_allowed_mask is completely cleared when the
watchdog is disabled. But the macro for_each_cpu() assume
all masks are "1" when macro NR_CPUS equal to 1. It makes
watchdog_allowed_mask not work at all.

Link: https://lkml.kernel.org/r/20210916175650.1380-1-guojinhui@huawei.com
Fixes: be45bf5395e0 ("watchdog/softlockup: Fix cpu_stop_queue_work() double-queue bug")
Signed-off-by: Jinhui Guo <guojinhui@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/cpumask.h~watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug
+++ a/include/linux/cpumask.h
@@ -175,10 +175,11 @@ static inline int cpumask_any_distribute
 	return cpumask_first(srcp);
 }
 
+/* It should check cpumask in some special case, such as watchdog */
 #define for_each_cpu(cpu, mask)			\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+	for ((cpu) = 0; (cpu) < 1 && test_bit(0, cpumask_bits(mask)); (cpu)++)
 #define for_each_cpu_not(cpu, mask)		\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+	for ((cpu) = 0; (cpu) < 1 && !test_bit(0, cpumask_bits(mask)); (cpu)++)
 #define for_each_cpu_wrap(cpu, mask, start)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)(start))
 #define for_each_cpu_and(cpu, mask1, mask2)	\
_

Patches currently in -mm which might be from guojinhui@huawei.com are


