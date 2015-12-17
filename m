From: akpm@linux-foundation.org
Subject: +
 vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch added to -mm tree
Date: Thu, 17 Dec 2015 15:29:01 -0800
Message-ID: <5673453d.GqexZQAjy5h/GL02%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbbLQX3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 18:29:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, hannes@cmpxchg.org, mhocko@suse.cz, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix
has been added to the -mm tree.  Its filename is
     vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix

Hmmm... We got a race condition since quiet_vmstat touches cpu_stat_off
which may not be allocated early in the bootup sequence. Causes oopses on
boot.

Subject: vmstat: quieting vmstat requires a running system

Do not do anything unless the system is actually running. Otherwise
we may crash on bootup.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmstat.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix
+++ a/mm/vmstat.c
@@ -1416,6 +1416,9 @@ static void vmstat_update(struct work_st
  */
 void quiet_vmstat(void)
 {
+	if (system_state != SYSTEM_RUNNING)
+		return;
+
 	do {
 		if (!cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
 			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch
vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch

