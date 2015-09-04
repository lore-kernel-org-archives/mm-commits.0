From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix-2.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:26:51 -0700
Message-ID: <55ea1aab.9D/iKDP5lv8excoB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264AbbIDW0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, a.p.zijlstra@chello.nl, atomlin@redhat.com, cmetcalf@ezchip.com, dzickus@redhat.com, eranian@google.com, fweisbec@gmail.com, jolsa@kernel.org, linux@roeck-us.net, mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: use pr_debug() in fixup_ht_bug() failure path
has been removed from the -mm tree.  Its filename was
     watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix-2.patch

This patch was dropped because it was folded into watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: use pr_debug() in fixup_ht_bug() failure path

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephane Eranian <eranian@google.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel.c~watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix-2 arch/x86/kernel/cpu/perf_event_intel.c
--- a/arch/x86/kernel/cpu/perf_event_intel.c~watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix-2
+++ a/arch/x86/kernel/cpu/perf_event_intel.c
@@ -3378,7 +3378,7 @@ static __init int fixup_ht_bug(void)
 	}
 
 	if (watchdog_suspend() != 0) {
-		pr_info("failed to disable PMU erratum BJ122, BV98, HSD29 workaround\n");
+		pr_debug("failed to disable PMU erratum BJ122, BV98, HSD29 workaround\n");
 		return 0;
 	}
 
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch
watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch
watchdog-rename-watchdog_suspend-and-watchdog_resume.patch

