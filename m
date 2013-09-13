From: akpm@linux-foundation.org
Subject: [folded-merged] watchdog-update-watchdog_tresh-properly-fix.patch removed from -mm tree
Date: Fri, 13 Sep 2013 14:07:11 -0700
Message-ID: <52337e7f.ueVcOV62FwjkEBk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3IMVHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, festevam@gmail.com, fengguang.wu@intel.com, mhocko@suse.cz

Subject: [folded-merged] watchdog-update-watchdog_tresh-properly-fix.patch removed from -mm tree
To: mhocko@suse.cz,fengguang.wu@intel.com,festevam@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:07:11 -0700


The patch titled
     Subject: include/linux/smp.h: define __smp_call_function_single for !CONFIG_SMP
has been removed from the -mm tree.  Its filename was
     watchdog-update-watchdog_tresh-properly-fix.patch

This patch was dropped because it was folded into watchdog-update-watchdog_tresh-properly.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: include/linux/smp.h: define __smp_call_function_single for !CONFIG_SMP

This function was not needed until (watchdog: update watchdog_tresh
properly) which cannot use on_each_cpu unfortunately as
watchdog_nmi_enable relies on perf_event_alloc which is might sleep.

Export it as an alias to on_each_cpu for !CONFIG_SMP.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/smp.h~watchdog-update-watchdog_tresh-properly-fix include/linux/smp.h
--- a/include/linux/smp.h~watchdog-update-watchdog_tresh-properly-fix
+++ a/include/linux/smp.h
@@ -157,6 +157,12 @@ static inline void kick_all_cpus_sync(vo
 
 #endif /* !SMP */
 
+static inline void __smp_call_function_single(int cpuid,
+		struct call_single_data *data, int wait)
+{
+	on_each_cpu(data->func, data->info, wait);
+}
+
 /*
  * smp_processor_id(): get the current CPU ID.
  *
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch

