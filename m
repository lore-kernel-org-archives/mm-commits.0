Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A8CC7619A
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 19:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjDET6J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 15:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjDET6I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 15:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793421BF9
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 12:58:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1418963DC3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFE0C433D2;
        Wed,  5 Apr 2023 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680724686;
        bh=JP1eFxNkRLgQ8gwcapxfl7YczBMkCKUlpXZhJ4njbn8=;
        h=Date:To:From:Subject:From;
        b=SLWTYQz/CWTUpWU3Tw6vPvOPRefcw5K20FqxM6jJv1ALjz4sWB7PDPq6pp/TxSRWi
         96QBgGHg6fG3+8aYpkiakpwyrMl8LoQNHEyYSAlnC+6erkhiEC5i4+4hWUk8itnr7Y
         5xXXPg+/wT6Ff4MSRuCHNriHkYz+Hko4bfIF6YPg=
Date:   Wed, 05 Apr 2023 12:58:05 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, hca@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-stat-remove-arch_idle_time.patch added to mm-nonmm-unstable branch
Message-Id: <20230405195806.6CFE0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/stat: remove arch_idle_time()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-stat-remove-arch_idle_time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-stat-remove-arch_idle_time.patch

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

s390-mm-try-vma-lock-based-page-fault-handling-first.patch
proc-stat-remove-arch_idle_time.patch

