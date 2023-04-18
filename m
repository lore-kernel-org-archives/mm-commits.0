Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC53C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjDRXl2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXlH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BF1C671
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C549C630E9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B63BC433EF;
        Tue, 18 Apr 2023 23:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861219;
        bh=8GgdgQ3NUeqOqmqU+8PXa1b26Ns9eeB1HTeZY3fy7LU=;
        h=Date:To:From:Subject:From;
        b=jEi/kjf/O52exqfAqImY5WvtRPnz7aFMTN1CBDodiKwAMbGGaWym++usZOCRMSvKo
         eETOB3+S5Pttdxajr0jAQqMRmyidKMvGkFPM9VWpZV3gJm3tWlVjzr5ZI3l/00lJJ4
         tcmi1ia/ElzxH/jkFO7S752hW/1bBgQQkM7zc9iU=
Date:   Tue, 18 Apr 2023 16:40:18 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, hca@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-stat-remove-arch_idle_time.patch removed from -mm tree
Message-Id: <20230418234019.2B63BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/stat: remove arch_idle_time()
has been removed from the -mm tree.  Its filename was
     proc-stat-remove-arch_idle_time.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: proc/stat: remove arch_idle_time()
Date: Wed, 5 Apr 2023 16:34:52 +0200

The last (only) architecture specific arch_idle_time() implementation was
removed with commit be76ea614460 ("s390/idle: remove arch_cpu_idle_time()
and corresponding code").

Therefore remove the now dead code in fs/proc/stat.c as well.

Link: https://lkml.kernel.org/r/20230405143452.2677172-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/fs/proc/stat.c~proc-stat-remove-arch_idle_time
+++ a/fs/proc/stat.c
@@ -22,30 +22,6 @@
 #define arch_irq_stat() 0
 #endif
 
-#ifdef arch_idle_time
-
-u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
-{
-	u64 idle;
-
-	idle = kcs->cpustat[CPUTIME_IDLE];
-	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
-		idle += arch_idle_time(cpu);
-	return idle;
-}
-
-static u64 get_iowait_time(struct kernel_cpustat *kcs, int cpu)
-{
-	u64 iowait;
-
-	iowait = kcs->cpustat[CPUTIME_IOWAIT];
-	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
-		iowait += arch_idle_time(cpu);
-	return iowait;
-}
-
-#else
-
 u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
 {
 	u64 idle, idle_usecs = -1ULL;
@@ -78,8 +54,6 @@ static u64 get_iowait_time(struct kernel
 	return iowait;
 }
 
-#endif
-
 static void show_irq_gap(struct seq_file *p, unsigned int gap)
 {
 	static const char zeros[] = " 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
_

Patches currently in -mm which might be from hca@linux.ibm.com are


