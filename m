Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9927C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 18:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6EF611EE
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 18:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbhIPS7b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 14:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239094AbhIPS7T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 14:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5EC7611C8;
        Thu, 16 Sep 2021 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631818676;
        bh=r8MQaM3Vuu7aVFTXUMNcVBE1sZk1QUjsxaCEzBs4vDc=;
        h=Date:From:To:Subject:From;
        b=oVPFOd+gzosRMJNF/hgtBO8f/tpAV1lb2vdOIr/ijBb3KcGZcUx/cNjzb+fDTcXHk
         Ttnl7DxpTzeUGZGOYN1UqesSNRudQSz/3//SRdpOxysoihIx0kB4A32JF4VtQQvAAR
         x1rrhfhEGFMDSF2WN3i8HgWZCLiyR5rsw9iZdy3A=
Date:   Thu, 16 Sep 2021 11:57:56 -0700
From:   akpm@linux-foundation.org
To:     guojinhui@huawei.com, mm-commits@vger.kernel.org, pmladek@suse.com
Subject:  +
 watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch added to -mm
 tree
Message-ID: <20210916185756.ZqOZYO7GQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/softlockup: fix softlockup_stop_all() hungtask bug
has been added to the -mm tree.  Its filename is
     watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

watchdog-softlockup-fix-softlockup_stop_all-hungtask-bug.patch

