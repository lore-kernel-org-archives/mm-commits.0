From: akpm@linux-foundation.org
Subject: + cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch added to -mm tree
Date: Wed, 03 Oct 2012 14:13:36 -0700
Message-ID: <20121003211337.49045100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:38897 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab2JCVNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 17:13:38 -0400
Received: by ggmi4 with SMTP id i4so311485ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 14:13:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, jkosina@suse.cz, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de


The patch titled
     Subject: CPU hotplug, debug: detect imbalance between get_online_cpus() and put_online_cpus()
has been added to the -mm tree.  Its filename is
     cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus-fix.patch

