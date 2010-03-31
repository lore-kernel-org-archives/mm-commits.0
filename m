From: akpm@linux-foundation.org
Subject: [merged] cpufreq-fix-a-lockdep-warning.patch removed from -mm tree
Date: Wed, 31 Mar 2010 11:53:08 -0400
Message-ID: <201003311854.o2VIsI2C002104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757144Ab0CaSy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 14:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, benh@kernel.crashing.org, davej@redhat.com, dhowells@redhat.com, johannes@sipsolutions.net, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: fix a lockdep warning
has been removed from the -mm tree.  Its filename was
     cpufreq-fix-a-lockdep-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: fix a lockdep warning
From: Amerigo Wang <amwang@redhat.com>

There is no need to do sysfs_remove_link() or kobject_put() etc.  when
policy_rwsem_write is held, move them after releasing the lock.

This fixes the lockdep warning:

halt/4071 is trying to acquire lock:
 (s_active){++++.+}, at: [<c0000000001ef868>] .sysfs_addrm_finish+0x58/0xc0

but task is already holding lock:
 (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>] .lock_policy_rwsem_write+0x84/0xf4

Signed-off-by: WANG Cong <amwang@redhat.com>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-fix-a-lockdep-warning drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-fix-a-lockdep-warning
+++ a/drivers/cpufreq/cpufreq.c
@@ -1113,6 +1113,8 @@ static int __cpufreq_remove_dev(struct s
 	unsigned int cpu = sys_dev->id;
 	unsigned long flags;
 	struct cpufreq_policy *data;
+	struct kobject *kobj;
+	struct completion *cmp;
 #ifdef CONFIG_SMP
 	struct sys_device *cpu_sys_dev;
 	unsigned int j;
@@ -1141,10 +1143,11 @@ static int __cpufreq_remove_dev(struct s
 		dprintk("removing link\n");
 		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		sysfs_remove_link(&sys_dev->kobj, "cpufreq");
+		kobj = &sys_dev->kobj;
 		cpufreq_cpu_put(data);
 		cpufreq_debug_enable_ratelimit();
 		unlock_policy_rwsem_write(cpu);
+		sysfs_remove_link(kobj, "cpufreq");
 		return 0;
 	}
 #endif
@@ -1181,7 +1184,10 @@ static int __cpufreq_remove_dev(struct s
 				data->governor->name, CPUFREQ_NAME_LEN);
 #endif
 			cpu_sys_dev = get_cpu_sysdev(j);
-			sysfs_remove_link(&cpu_sys_dev->kobj, "cpufreq");
+			kobj = &cpu_sys_dev->kobj;
+			unlock_policy_rwsem_write(cpu);
+			sysfs_remove_link(kobj, "cpufreq");
+			lock_policy_rwsem_write(cpu);
 			cpufreq_cpu_put(data);
 		}
 	}
@@ -1192,19 +1198,22 @@ static int __cpufreq_remove_dev(struct s
 	if (cpufreq_driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
-	kobject_put(&data->kobj);
+	kobj = &data->kobj;
+	cmp = &data->kobj_unregister;
+	unlock_policy_rwsem_write(cpu);
+	kobject_put(kobj);
 
 	/* we need to make sure that the underlying kobj is actually
 	 * not referenced anymore by anybody before we proceed with
 	 * unloading.
 	 */
 	dprintk("waiting for dropping of refcount\n");
-	wait_for_completion(&data->kobj_unregister);
+	wait_for_completion(cmp);
 	dprintk("wait complete\n");
 
+	lock_policy_rwsem_write(cpu);
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(data);
