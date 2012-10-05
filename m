From: akpm@linux-foundation.org
Subject: [to-be-updated] cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:56:18 -0700
Message-ID: <20121005205619.A0C7B200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53830 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab2JEU4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:56:22 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so140591eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:56:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, jkosina@suse.cz, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: CPU hotplug, debug: detect imbalance between get_online_cpus() and put_online_cpus()
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, debug: detect imbalance between get_online_cpus() and put_online_cpus()

The synchronization between CPU hotplug readers and writers is achieved by
means of refcounting, safe-guarded by the cpu_hotplug.lock.

get_online_cpus() increments the refcount, whereas put_online_cpus()
decrements it.  If we ever hit an imbalance between the two, we end up
compromising the guarantees of the hotplug synchronization i.e, for
example, an extra call to put_online_cpus() can end up allowing a hotplug
reader to execute concurrently with a hotplug writer.  So, add a BUG_ON()
in put_online_cpus() to detect such cases where the refcount can go
negative.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/cpu.c~cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus
+++ a/kernel/cpu.c
@@ -80,6 +80,7 @@ void put_online_cpus(void)
 	if (cpu_hotplug.active_writer == current)
 		return;
 	mutex_lock(&cpu_hotplug.lock);
+	BUG_ON(cpu_hotplug.refcount == 0);
 	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
 		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
linux-next.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus-fix.patch

