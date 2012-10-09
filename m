From: akpm@linux-foundation.org
Subject: [merged] cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:29 -0700
Message-ID: <20121009180530.3295C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41222 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:33 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362097bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, jkosina@suse.cz, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: CPU hotplug, debug: detect imbalance between get_online_cpus() and put_online_cpus()
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, debug: detect imbalance between get_online_cpus() and put_online_cpus()

The synchronization between CPU hotplug readers and writers is achieved by
means of refcounting, safeguarded by the cpu_hotplug.lock.

get_online_cpus() increments the refcount, whereas put_online_cpus()
decrements it.  If we ever hit an imbalance between the two, we end up
compromising the guarantees of the hotplug synchronization i.e, for
example, an extra call to put_online_cpus() can end up allowing a hotplug
reader to execute concurrently with a hotplug writer.  So, add a WARN_ON()
in put_online_cpus() to detect such cases where the refcount can go
negative, and also attempt to fix it up, so that we can continue to run.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/cpu.c~cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus
+++ a/kernel/cpu.c
@@ -80,6 +80,10 @@ void put_online_cpus(void)
 	if (cpu_hotplug.active_writer == current)
 		return;
 	mutex_lock(&cpu_hotplug.lock);
+
+	if (WARN_ON(!cpu_hotplug.refcount))
+		cpu_hotplug.refcount++; /* try to fix things up */
+
 	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
 		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
linux-next.patch

