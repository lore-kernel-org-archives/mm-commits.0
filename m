Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86AE4084C
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718125428; cv=none; b=GqvaObHWpZSOhVOhhfcMCyNRaUGS43uHtuzCIPuYzpAGoNuqYibnEf8PIAmfMQnXd7HTq9zYQV9LriggfZ30OFzJImU+TzCDJTjv3ii9WWJKoD1M6QeGzd2UhlVDyGEDH+4w4qtydRSaeuS0ynVZcaHd1a3NuGPMNolSvGnJttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718125428; c=relaxed/simple;
	bh=T84L3/MJ/lmMidIMhz2Ute9h2pfl3aXxp355JYE8am8=;
	h=Date:To:From:Subject:Message-Id; b=guENlMRSOcDqDq7TpusOIMI1K2+92SvDr16i+96BxXQEgYzICTU8fznRV5qOUK8ME2ocwkiQBuQox2e+r0xiR1B2P+8raME26UqoY4j48WA+lIjY3/2Ii37tUZhgGpPew+XOXKu3S4U8ygHA4aZ/adSniG8J1YoWtcL65DxLxI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsASClZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsASClZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399D1C2BD10;
	Tue, 11 Jun 2024 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718125428;
	bh=T84L3/MJ/lmMidIMhz2Ute9h2pfl3aXxp355JYE8am8=;
	h=Date:To:From:Subject:From;
	b=wsASClZIs2uoms/khDzMUudIXcJqU4KukQoAJ/WjnW54M75lslQPP4DFw76XeHcu3
	 m0RDFmacw1JQQ4yotu/9LD95gHCKj9U0mhxKsA368RT/Z92MpZfT1I/3Gnppa9MyMk
	 FFaHZucXrhe8jTfBgwL94kjvymxQsFZawh0c+40o=
Date: Tue, 11 Jun 2024 10:03:47 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,trix@redhat.com,tglx@linutronix.de,pmladek@suse.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,dianders@chromium.org,christophe.leroy@csgroup.eu,luogengkun@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq.patch removed from -mm tree
Message-Id: <20240611170348.399D1C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/core: fix AA deadlock due to watchdog holding cpu_hotplug_lock and wait for wq
has been removed from the -mm tree.  Its filename was
     watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Luo Gengkun <luogengkun@huaweicloud.com>
Subject: watchdog/core: fix AA deadlock due to watchdog holding cpu_hotplug_lock and wait for wq
Date: Thu, 6 Jun 2024 15:38:28 +0000

We found an AA deadlock problem as shown belowed:

TaskA				TaskB				WatchDog			system_wq

...
css_killed_work_fn:
P(cgroup_mutex)
...
								...
								__lockup_detector_reconfigure:
								P(cpu_hotplug_lock.read)
								...
				...
				cpu_up:
				percpu_down_write:
				P(cpu_hotplug_lock.write)
												...
												cgroup_bpf_release:
												P(cgroup_mutex)
								smp_call_on_cpu:
								Wait system_wq

cpuset_css_offline:
P(cpu_hotplug_lock.read)

WatchDog is waiting for system_wq, who is waitting for cgroup_mutex, to
finish the jobs, but the owner of the cgroup_mutex is waitting for
cpu_hotplug_lock.  The key point is the cpu_hotplug_lock, cause the
system_wq may be waitting other lock.  It seems unhealthy to hold a lock
when waitting system_wq, because we never know what jobs are system_wq
doing.  So I fix this by replace cpu_read_lock/unlock with
cpu_hotplug_disable/enable to prevent cpu offline/online.

Link: https://lkml.kernel.org/r/20240606153828.3261006-1-luogengkun@huaweicloud.com
Fixes: e31d6883f21c ("watchdog/core, powerpc: Lock cpus across reconfiguration")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c~watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq
+++ a/kernel/watchdog.c
@@ -867,7 +867,7 @@ int lockup_detector_offline_cpu(unsigned
 
 static void __lockup_detector_reconfigure(void)
 {
-	cpus_read_lock();
+	cpu_hotplug_disable();
 	watchdog_hardlockup_stop();
 
 	softlockup_stop_all();
@@ -877,7 +877,7 @@ static void __lockup_detector_reconfigur
 		softlockup_start_all();
 
 	watchdog_hardlockup_start();
-	cpus_read_unlock();
+	cpu_hotplug_enable();
 	/*
 	 * Must be called outside the cpus locked section to prevent
 	 * recursive locking in the perf code.
@@ -916,11 +916,11 @@ static __init void lockup_detector_setup
 #else /* CONFIG_SOFTLOCKUP_DETECTOR */
 static void __lockup_detector_reconfigure(void)
 {
-	cpus_read_lock();
+	cpu_hotplug_disable();
 	watchdog_hardlockup_stop();
 	lockup_detector_update_enable();
 	watchdog_hardlockup_start();
-	cpus_read_unlock();
+	cpu_hotplug_enable();
 }
 void lockup_detector_reconfigure(void)
 {
_

Patches currently in -mm which might be from luogengkun@huaweicloud.com are


