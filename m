Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6192715A8
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044162; cv=none; b=ZF6kRXqjkdS7Avh6emXoPZIUQm+vz3Iq+Am+Qug154ldFiDAsHH4IiyeIi31mZubXaagcVnDygLixouTORUDG6EALZVOkBS/uqdZdwguXcfuRzkMm9yzC2jcIpvWD84vAxhKoTtuddlhB58tdJdkK38b/3ljwd+4ZR4T8H1+xmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044162; c=relaxed/simple;
	bh=HIlDgFbNpQbk5GsJBusBE7nWezYVb5KYJYiBPex06GE=;
	h=Date:To:From:Subject:Message-Id; b=A4O2ufKmKYen3OPyfUE5D3QtURfKVK5aEqWLw5bOWrnBL9IY8oTYmW2VAP+J5U7q4PLLXYBPp9Io5zTsBobYXf5Rse1CM8jvoeyPPQkoC/j5X0fpXcVX3OWX0Ue+uYYHTwDWLeUVy1ZRUumgJBGDQYsqiRlzOtyYBOngC5JZeiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UVBHLzy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVBHLzy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955B1C2BBFC;
	Mon, 10 Jun 2024 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718044161;
	bh=HIlDgFbNpQbk5GsJBusBE7nWezYVb5KYJYiBPex06GE=;
	h=Date:To:From:Subject:From;
	b=UVBHLzy4+u8/eown8sLDxzYx6TBXNSIseUSRHU8kgiaDkSVQHNvafMh5x27jmTzSj
	 KvNYuLGnnjCSWE+1dziUiekdtZAok5J/djITiBoxxfh4YhOeLY6znoO18zvSFraWZT
	 iwIp2HOt/byAt0ftGzEURi3GK1kDt2BeMuAYDAVU=
Date: Mon, 10 Jun 2024 11:29:21 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,trix@redhat.com,tglx@linutronix.de,pmladek@suse.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,dianders@chromium.org,christophe.leroy@csgroup.eu,luogengkun@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq.patch added to mm-nonmm-unstable branch
Message-Id: <20240610182921.955B1C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/core: fix AA deadlock due to watchdog holding cpu_hotplug_lock and wait for wq
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq.patch

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

watchdog-core-fix-aa-deadlock-due-to-watchdog-holding-cpu_hotplug_lock-and-wait-for-wq.patch

