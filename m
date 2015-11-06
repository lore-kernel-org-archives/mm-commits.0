From: akpm@linux-foundation.org
Subject: + mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 16:05:21 -0800
Message-ID: <563beec1.yzpmnPzZnFpzzoaE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbbKFAFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 19:05:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove refresh_cpu_vm_stats() definition for !SMP kernel
has been added to the -mm tree.  Its filename is
     mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: remove refresh_cpu_vm_stats() definition for !SMP kernel

refresh_cpu_vm_stats(int cpu) is no longer referenced by !SMP kernel
since Linux 3.12.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/vmstat.h~mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel
+++ a/include/linux/vmstat.h
@@ -247,7 +247,6 @@ static inline void __dec_zone_page_state
 
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
-static inline void refresh_cpu_vm_stats(int cpu) { }
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch

