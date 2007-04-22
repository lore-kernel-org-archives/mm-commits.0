From: akpm@linux-foundation.org
Subject: + add-suspend-related-notifications-for-cpu-hotplug.patch added to -mm tree
Date: Sat, 21 Apr 2007 20:06:00 -0700
Message-ID: <200704220306.l3M360dS018365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932212AbXDVDGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 23:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ego@in.ibm.com, pavel@ucw.cz


The patch titled
     Add suspend-related notifications for CPU hotplug
has been added to the -mm tree.  Its filename is
     add-suspend-related-notifications-for-cpu-hotplug.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Add suspend-related notifications for CPU hotplug
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Since nonboot CPUs are now disabled after tasks and devices have been
frozen and the CPU hotplug infrastructure is used for this purpose, we =
need
special CPU hotplug notifications that will help the CPU-hotplug-aware
subsystems distinguish normal CPU hotplug events=A0from CPU hotplug eve=
nts
related to a system-wide suspend or resume operation in progress.  This
patch introduces such notifications and causes them to be used during
suspend and resume transitions.  It also changes all of the
CPU-hotplug-aware subsystems to take these notifications into considera=
tion
(for now they are handled in the same way as the corresponding "normal"
ones).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-hotplug.txt             |    9 ++++-
 arch/i386/kernel/cpu/intel_cacheinfo.c    |    2 +
 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +
 arch/i386/kernel/cpuid.c                  |    2 +
 arch/i386/kernel/microcode.c              |    3 +
 arch/i386/kernel/msr.c                    |    2 +
 arch/ia64/kernel/err_inject.c             |    2 +
 arch/ia64/kernel/palinfo.c                |    2 +
 arch/ia64/kernel/salinfo.c                |    2 +
 arch/ia64/kernel/topology.c               |    2 +
 arch/powerpc/kernel/sysfs.c               |    2 +
 arch/powerpc/mm/numa.c                    |    3 +
 arch/s390/appldata/appldata_base.c        |    2 +
 arch/s390/kernel/smp.c                    |    2 +
 arch/x86_64/kernel/mce.c                  |    2 +
 arch/x86_64/kernel/mce_amd.c              |    2 +
 arch/x86_64/kernel/vsyscall.c             |    2 -
 block/ll_rw_blk.c                         |    2 -
 drivers/base/topology.c                   |    3 +
 drivers/cpufreq/cpufreq.c                 |    3 +
 drivers/cpufreq/cpufreq_stats.c           |    2 +
 drivers/cpuidle/cpuidle.c                 |    4 ++
 drivers/hwmon/coretemp.c                  |    2 +
 drivers/infiniband/hw/ehca/ehca_irq.c     |    6 +++
 drivers/kvm/kvm_main.c                    |    3 +
 fs/buffer.c                               |    2 -
 fs/xfs/xfs_mount.c                        |    3 +
 include/linux/notifier.h                  |   12 +++++++
 kernel/cpu.c                              |   34 ++++++++++----------
 kernel/hrtimer.c                          |    2 +
 kernel/profile.c                          |    4 ++
 kernel/rcupdate.c                         |    2 +
 kernel/relay.c                            |    2 +
 kernel/sched.c                            |   10 +++++
 kernel/softirq.c                          |    4 ++
 kernel/softlockup.c                       |    4 ++
 kernel/timer.c                            |    2 +
 kernel/workqueue.c                        |    5 ++
 lib/radix-tree.c                          |    2 -
 mm/page_alloc.c                           |    5 ++
 mm/slab.c                                 |    6 +++
 mm/slub.c                                 |    2 +
 mm/swap.c                                 |    2 -
 mm/vmscan.c                               |    2 -
 mm/vmstat.c                               |    3 +
 net/core/dev.c                            |    2 -
 net/core/flow.c                           |    2 -
 net/iucv/iucv.c                           |    6 +++
 48 files changed, 159 insertions(+), 27 deletions(-)

diff -puN Documentation/cpu-hotplug.txt~add-suspend-related-notificatio=
ns-for-cpu-hotplug Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt~add-suspend-related-notifications-f=
or-cpu-hotplug
+++ a/Documentation/cpu-hotplug.txt
@@ -217,14 +217,17 @@ Q: What happens when a CPU is being logi
 A: The following happen, listed in no particular order :-)
=20
 - A notification is sent to in-kernel registered modules by sending an=
 event
-  CPU_DOWN_PREPARE
+  CPU_DOWN_PREPARE or CPU_DOWN_PREPARE_FROZEN, depending on whether or=
 not the
+  CPU is being offlined while tasks are frozen due to a suspend operat=
ion in
+  progress
 - All process is migrated away from this outgoing CPU to a new CPU
 - All interrupts targeted to this CPU is migrated to a new CPU
 - timers/bottom half/task lets are also migrated to a new CPU
 - Once all services are migrated, kernel calls an arch specific routin=
e
   __cpu_disable() to perform arch specific cleanup.
 - Once this is successful, an event for successful cleanup is sent by =
an event
-  CPU_DEAD.
+  CPU_DEAD (or CPU_DEAD_FROZEN if tasks are frozen due to a suspend wh=
ile the
+  CPU is being offlined).
=20
   "It is expected that each service cleans up when the CPU_DOWN_PREPAR=
E
   notifier is called, when CPU_DEAD is called its expected there is no=
thing
@@ -242,9 +245,11 @@ A: This is what you would need in your k
=20
 		switch (action) {
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			foobar_online_action(cpu);
 			break;
 		case CPU_DEAD:
+		case CPU_DEAD_FROZEN:
 			foobar_dead_action(cpu);
 			break;
 		}
diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~add-suspend-related-no=
tifications-for-cpu-hotplug arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~add-suspend-related-notifi=
cations-for-cpu-hotplug
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -768,9 +768,11 @@ static int __cpuinit cacheinfo_cpu_callb
 	sys_dev =3D get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cache_add_dev(sys_dev);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cache_remove_dev(sys_dev);
 		break;
 	}
diff -puN arch/i386/kernel/cpu/mcheck/therm_throt.c~add-suspend-related=
-notifications-for-cpu-hotplug arch/i386/kernel/cpu/mcheck/therm_throt.=
c
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c~add-suspend-related-not=
ifications-for-cpu-hotplug
+++ a/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -137,10 +137,12 @@ static __cpuinit int thermal_throttle_cp
 	mutex_lock(&therm_cpu_lock);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		err =3D thermal_throttle_add_dev(sys_dev);
 		WARN_ON(err);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		thermal_throttle_remove_dev(sys_dev);
 		break;
 	}
diff -puN arch/i386/kernel/cpuid.c~add-suspend-related-notifications-fo=
r-cpu-hotplug arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~add-suspend-related-notifications-for-cp=
u-hotplug
+++ a/arch/i386/kernel/cpuid.c
@@ -169,9 +169,11 @@ static int cpuid_class_cpu_callback(stru
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpuid_device_create(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
 		break;
 	}
diff -puN arch/i386/kernel/microcode.c~add-suspend-related-notification=
s-for-cpu-hotplug arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~add-suspend-related-notifications-fo=
r-cpu-hotplug
+++ a/arch/i386/kernel/microcode.c
@@ -775,10 +775,13 @@ mc_cpu_callback(struct notifier_block *n
 	sys_dev =3D get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mc_sysdev_add(sys_dev);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mc_sysdev_remove(sys_dev);
 		break;
 	}
diff -puN arch/i386/kernel/msr.c~add-suspend-related-notifications-for-=
cpu-hotplug arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~add-suspend-related-notifications-for-cpu-=
hotplug
+++ a/arch/i386/kernel/msr.c
@@ -251,9 +251,11 @@ static int msr_class_cpu_callback(struct
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		msr_device_create(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 		break;
 	}
diff -puN arch/ia64/kernel/err_inject.c~add-suspend-related-notificatio=
ns-for-cpu-hotplug arch/ia64/kernel/err_inject.c
--- a/arch/ia64/kernel/err_inject.c~add-suspend-related-notifications-f=
or-cpu-hotplug
+++ a/arch/ia64/kernel/err_inject.c
@@ -236,9 +236,11 @@ static int __cpuinit err_inject_cpu_call
 	sys_dev =3D get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		err_inject_add_dev(sys_dev);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		err_inject_remove_dev(sys_dev);
 		break;
 	}
diff -puN arch/ia64/kernel/palinfo.c~add-suspend-related-notifications-=
for-cpu-hotplug arch/ia64/kernel/palinfo.c
--- a/arch/ia64/kernel/palinfo.c~add-suspend-related-notifications-for-=
cpu-hotplug
+++ a/arch/ia64/kernel/palinfo.c
@@ -975,9 +975,11 @@ static int palinfo_cpu_callback(struct n
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		create_palinfo_proc_entries(hotcpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		remove_palinfo_proc_entries(hotcpu);
 		break;
 	}
diff -puN arch/ia64/kernel/salinfo.c~add-suspend-related-notifications-=
for-cpu-hotplug arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~add-suspend-related-notifications-for-=
cpu-hotplug
+++ a/arch/ia64/kernel/salinfo.c
@@ -582,6 +582,7 @@ salinfo_cpu_callback(struct notifier_blo
 	struct salinfo_data *data;
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i =3D 0, data =3D salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
@@ -592,6 +593,7 @@ salinfo_cpu_callback(struct notifier_blo
 		spin_unlock_irqrestore(&data_saved_lock, flags);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i =3D 0, data =3D salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
diff -puN arch/ia64/kernel/topology.c~add-suspend-related-notifications=
-for-cpu-hotplug arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c~add-suspend-related-notifications-for=
-cpu-hotplug
+++ a/arch/ia64/kernel/topology.c
@@ -412,9 +412,11 @@ static int __cpuinit cache_cpu_callback(
 	sys_dev =3D get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cache_add_dev(sys_dev);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cache_remove_dev(sys_dev);
 		break;
 	}
diff -puN arch/powerpc/kernel/sysfs.c~add-suspend-related-notifications=
-for-cpu-hotplug arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c~add-suspend-related-notifications-for=
-cpu-hotplug
+++ a/arch/powerpc/kernel/sysfs.c
@@ -341,10 +341,12 @@ static int __cpuinit sysfs_cpu_notify(st
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		register_cpu_online(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		unregister_cpu_online(cpu);
 		break;
 #endif
diff -puN arch/powerpc/mm/numa.c~add-suspend-related-notifications-for-=
cpu-hotplug arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~add-suspend-related-notifications-for-cpu-=
hotplug
+++ a/arch/powerpc/mm/numa.c
@@ -252,12 +252,15 @@ static int __cpuinit cpu_numa_callback(s
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		numa_setup_cpu(lcpu);
 		ret =3D NOTIFY_OK;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
 		break;
 		ret =3D NOTIFY_OK;
diff -puN arch/s390/appldata/appldata_base.c~add-suspend-related-notifi=
cations-for-cpu-hotplug arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~add-suspend-related-notificati=
ons-for-cpu-hotplug
+++ a/arch/s390/appldata/appldata_base.c
@@ -567,9 +567,11 @@ appldata_cpu_notify(struct notifier_bloc
 {
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		appldata_online_cpu((long) hcpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		appldata_offline_cpu((long) hcpu);
 		break;
 	default:
diff -puN arch/s390/kernel/smp.c~add-suspend-related-notifications-for-=
cpu-hotplug arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~add-suspend-related-notifications-for-cpu-=
hotplug
+++ a/arch/s390/kernel/smp.c
@@ -789,10 +789,12 @@ static int __cpuinit smp_cpu_notify(stru
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		if (sysdev_create_file(s, &attr_capability))
 			return NOTIFY_BAD;
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		sysdev_remove_file(s, &attr_capability);
 		break;
 	}
diff -puN arch/x86_64/kernel/mce.c~add-suspend-related-notifications-fo=
r-cpu-hotplug arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~add-suspend-related-notifications-for-cp=
u-hotplug
+++ a/arch/x86_64/kernel/mce.c
@@ -704,9 +704,11 @@ mce_cpu_callback(struct notifier_block *
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		mce_create_device(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
diff -puN arch/x86_64/kernel/mce_amd.c~add-suspend-related-notification=
s-for-cpu-hotplug arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~add-suspend-related-notifications-fo=
r-cpu-hotplug
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -654,9 +654,11 @@ static int threshold_cpu_callback(struct
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		threshold_create_device(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		threshold_remove_device(cpu);
 		break;
 	default:
diff -puN arch/x86_64/kernel/vsyscall.c~add-suspend-related-notificatio=
ns-for-cpu-hotplug arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~add-suspend-related-notifications-f=
or-cpu-hotplug
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -327,7 +327,7 @@ static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, =
void *arg)
 {
 	long cpu =3D (long)arg;
-	if (action =3D=3D CPU_ONLINE)
+	if (action =3D=3D CPU_ONLINE || action =3D=3D CPU_ONLINE_FROZEN)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 0, 1);
 	return NOTIFY_DONE;
 }
diff -puN block/ll_rw_blk.c~add-suspend-related-notifications-for-cpu-h=
otplug block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~add-suspend-related-notifications-for-cpu-hotpl=
ug
+++ a/block/ll_rw_blk.c
@@ -3506,7 +3506,7 @@ static int blk_cpu_notify(struct notifie
 	 * If a CPU goes away, splice its entries to the current CPU
 	 * and trigger a run of the softirq
 	 */
-	if (action =3D=3D CPU_DEAD) {
+	if (action =3D=3D CPU_DEAD || action =3D=3D CPU_DEAD_FROZEN) {
 		int cpu =3D (unsigned long) hcpu;
=20
 		local_irq_disable();
diff -puN drivers/base/topology.c~add-suspend-related-notifications-for=
-cpu-hotplug drivers/base/topology.c
--- a/drivers/base/topology.c~add-suspend-related-notifications-for-cpu=
-hotplug
+++ a/drivers/base/topology.c
@@ -126,10 +126,13 @@ static int __cpuinit topology_cpu_callba
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		rc =3D topology_add_dev(cpu);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		topology_remove_dev(cpu);
 		break;
 	}
diff -puN drivers/cpufreq/cpufreq.c~add-suspend-related-notifications-f=
or-cpu-hotplug drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~add-suspend-related-notifications-for-c=
pu-hotplug
+++ a/drivers/cpufreq/cpufreq.c
@@ -1720,9 +1720,11 @@ static int cpufreq_cpu_callback(struct n
 	if (sys_dev) {
 		switch (action) {
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			cpufreq_add_dev(sys_dev);
 			break;
 		case CPU_DOWN_PREPARE:
+		case CPU_DOWN_PREPARE_FROZEN:
 			if (unlikely(lock_policy_rwsem_write(cpu)))
 				BUG();
=20
@@ -1734,6 +1736,7 @@ static int cpufreq_cpu_callback(struct n
 			__cpufreq_remove_dev(sys_dev);
 			break;
 		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
 			cpufreq_add_dev(sys_dev);
 			break;
 		}
diff -puN drivers/cpufreq/cpufreq_stats.c~add-suspend-related-notificat=
ions-for-cpu-hotplug drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~add-suspend-related-notifications=
-for-cpu-hotplug
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -317,9 +317,11 @@ static int cpufreq_stat_cpu_callback(str
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
 		break;
 	}
diff -puN drivers/cpuidle/cpuidle.c~add-suspend-related-notifications-f=
or-cpu-hotplug drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~add-suspend-related-notifications-for-c=
pu-hotplug
+++ a/drivers/cpuidle/cpuidle.c
@@ -227,16 +227,20 @@ static int cpuidle_cpu_callback(struct n
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpuidle_add_device(sys_dev);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mutex_lock(&cpuidle_lock);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		__cpuidle_remove_device(sys_dev);
 		mutex_unlock(&cpuidle_lock);
 		break;
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mutex_unlock(&cpuidle_lock);
 		break;
 	}
diff -puN drivers/hwmon/coretemp.c~add-suspend-related-notifications-fo=
r-cpu-hotplug drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~add-suspend-related-notifications-for-cp=
u-hotplug
+++ a/drivers/hwmon/coretemp.c
@@ -309,9 +309,11 @@ static int coretemp_cpu_callback(struct=20
=20
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		coretemp_device_add(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		coretemp_device_remove(cpu);
 		break;
 	}
diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~add-suspend-related-not=
ifications-for-cpu-hotplug drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~add-suspend-related-notific=
ations-for-cpu-hotplug
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -745,6 +745,7 @@ static int comp_pool_callback(struct not
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
 		if(!create_comp_task(pool, cpu)) {
 			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
@@ -752,24 +753,29 @@ static int comp_pool_callback(struct not
 		}
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
 		cct =3D per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 		kthread_bind(cct->task, any_online_cpu(cpu_online_map));
 		destroy_comp_task(pool, cpu);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_ONLINE)", cpu);
 		cct =3D per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 		kthread_bind(cct->task, cpu);
 		wake_up_process(cct->task);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_DOWN_PREPARE)", cpu);
 		break;
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_DOWN_FAILED)", cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_DEAD)", cpu);
 		destroy_comp_task(pool, cpu);
 		take_over_work(pool, cpu);
diff -puN drivers/kvm/kvm_main.c~add-suspend-related-notifications-for-=
cpu-hotplug drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~add-suspend-related-notifications-for-cpu-=
hotplug
+++ a/drivers/kvm/kvm_main.c
@@ -2896,7 +2896,9 @@ static int kvm_cpu_hotplug(struct notifi
=20
 	switch (val) {
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		decache_vcpus_on_cpu(cpu);
@@ -2904,6 +2906,7 @@ static int kvm_cpu_hotplug(struct notifi
 					 NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
diff -puN fs/buffer.c~add-suspend-related-notifications-for-cpu-hotplug=
 fs/buffer.c
--- a/fs/buffer.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/fs/buffer.c
@@ -2950,7 +2950,7 @@ static void buffer_exit_cpu(int cpu)
 static int buffer_cpu_notify(struct notifier_block *self,
 			      unsigned long action, void *hcpu)
 {
-	if (action =3D=3D CPU_DEAD)
+	if (action =3D=3D CPU_DEAD || action =3D=3D CPU_DEAD_FROZEN)
 		buffer_exit_cpu((unsigned long)hcpu);
 	return NOTIFY_OK;
 }
diff -puN fs/xfs/xfs_mount.c~add-suspend-related-notifications-for-cpu-=
hotplug fs/xfs/xfs_mount.c
--- a/fs/xfs/xfs_mount.c~add-suspend-related-notifications-for-cpu-hotp=
lug
+++ a/fs/xfs/xfs_mount.c
@@ -1734,11 +1734,13 @@ xfs_icsb_cpu_notify(
 			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		/* Easy Case - initialize the area and locks, and
 		 * then rebalance when online does everything else for us. */
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
 		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
@@ -1746,6 +1748,7 @@ xfs_icsb_cpu_notify(
 		xfs_icsb_unlock(mp);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/* Disable all the counters, then fold the dead cpu's
 		 * count into the total on the global superblock and
 		 * re-enable the counters. */
diff -puN include/linux/notifier.h~add-suspend-related-notifications-fo=
r-cpu-hotplug include/linux/notifier.h
--- a/include/linux/notifier.h~add-suspend-related-notifications-for-cp=
u-hotplug
+++ a/include/linux/notifier.h
@@ -197,5 +197,17 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
 #define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
=20
+/* Used for CPU hotplug events occuring while tasks are frozen due to =
a suspend
+ * operation in progress
+ */
+#define CPU_TASKS_FROZEN	0x0010
+
+#define CPU_ONLINE_FROZEN	(CPU_ONLINE | CPU_TASKS_FROZEN)
+#define CPU_UP_PREPARE_FROZEN	(CPU_UP_PREPARE | CPU_TASKS_FROZEN)
+#define CPU_UP_CANCELED_FROZEN	(CPU_UP_CANCELED | CPU_TASKS_FROZEN)
+#define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
+#define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
+#define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN kernel/cpu.c~add-suspend-related-notifications-for-cpu-hotplu=
g kernel/cpu.c
--- a/kernel/cpu.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/kernel/cpu.c
@@ -120,12 +120,13 @@ static int take_cpu_down(void *unused)
 }
=20
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu)
+static int _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls =3D 0;
 	struct task_struct *p;
 	cpumask_t old_allowed, tmp;
 	void *hcpu =3D (void *)(long)cpu;
+	unsigned long mod =3D tasks_frozen ? CPU_TASKS_FROZEN : 0;
=20
 	if (num_online_cpus() =3D=3D 1)
 		return -EBUSY;
@@ -134,11 +135,11 @@ static int _cpu_down(unsigned int cpu)
 		return -EINVAL;
=20
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
-	err =3D __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
+	err =3D __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err =3D=3D NOTIFY_BAD) {
-		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED, hcpu,
-					  nr_calls, NULL);
+		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
+					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__FUNCTION__, cpu);
 		err =3D -EINVAL;
@@ -157,7 +158,7 @@ static int _cpu_down(unsigned int cpu)
=20
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED,
+		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) =3D=3D NOTIFY_BAD)
 			BUG();
=20
@@ -180,7 +181,8 @@ static int _cpu_down(unsigned int cpu)
 	put_cpu();
=20
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD, hcpu) =3D=3D NOTIFY=
_BAD)
+	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
+				    hcpu) =3D=3D NOTIFY_BAD)
 		BUG();
=20
 	check_for_tasks(cpu);
@@ -190,8 +192,7 @@ out_thread:
 out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE,
-						(void *)(long)cpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 	return err;
 }
=20
@@ -203,7 +204,7 @@ int cpu_down(unsigned int cpu)
 	if (cpu_hotplug_disabled)
 		err =3D -EBUSY;
 	else
-		err =3D _cpu_down(cpu);
+		err =3D _cpu_down(cpu, 0);
=20
 	mutex_unlock(&cpu_add_remove_lock);
 	return err;
@@ -211,16 +212,17 @@ int cpu_down(unsigned int cpu)
 #endif /*CONFIG_HOTPLUG_CPU*/
=20
 /* Requires cpu_add_remove_lock to be held */
-static int __cpuinit _cpu_up(unsigned int cpu)
+static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	int ret, nr_calls =3D 0;
 	void *hcpu =3D (void *)(long)cpu;
+	unsigned long mod =3D tasks_frozen ? CPU_TASKS_FROZEN : 0;
=20
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
=20
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
-	ret =3D __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu,
+	ret =3D __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, h=
cpu,
 							-1, &nr_calls);
 	if (ret =3D=3D NOTIFY_BAD) {
 		printk("%s: attempt to bring up CPU %u failed\n",
@@ -238,12 +240,12 @@ static int __cpuinit _cpu_up(unsigned in
 	BUG_ON(!cpu_online(cpu));
=20
 	/* Now call notifier in preparation. */
-	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE, hcpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
=20
 out_notify:
 	if (ret !=3D 0)
 		__raw_notifier_call_chain(&cpu_chain,
-				CPU_UP_CANCELED, hcpu, nr_calls, NULL);
+				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
=20
 	return ret;
@@ -257,7 +259,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (cpu_hotplug_disabled)
 		err =3D -EBUSY;
 	else
-		err =3D _cpu_up(cpu);
+		err =3D _cpu_up(cpu, 0);
=20
 	mutex_unlock(&cpu_add_remove_lock);
 	return err;
@@ -287,7 +289,7 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu =3D=3D first_cpu)
 			continue;
-		error =3D _cpu_down(cpu);
+		error =3D _cpu_down(cpu, 1);
 		if (!error) {
 			cpu_set(cpu, frozen_cpus);
 			printk("CPU%d is down\n", cpu);
@@ -322,7 +324,7 @@ void enable_nonboot_cpus(void)
 	suspend_cpu_hotplug =3D 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
-		error =3D _cpu_up(cpu);
+		error =3D _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
 			continue;
diff -puN kernel/hrtimer.c~add-suspend-related-notifications-for-cpu-ho=
tplug kernel/hrtimer.c
--- a/kernel/hrtimer.c~add-suspend-related-notifications-for-cpu-hotplu=
g
+++ a/kernel/hrtimer.c
@@ -1408,11 +1408,13 @@ static int __cpuinit hrtimer_cpu_notify(
 	switch (action) {
=20
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		init_hrtimers_cpu(cpu);
 		break;
=20
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
 		migrate_hrtimers(cpu);
 		break;
diff -puN kernel/profile.c~add-suspend-related-notifications-for-cpu-ho=
tplug kernel/profile.c
--- a/kernel/profile.c~add-suspend-related-notifications-for-cpu-hotplu=
g
+++ a/kernel/profile.c
@@ -340,6 +340,7 @@ static int __devinit profile_cpu_callbac
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		node =3D cpu_to_node(cpu);
 		per_cpu(cpu_profile_flip, cpu) =3D 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
@@ -365,10 +366,13 @@ static int __devinit profile_cpu_callbac
 		__free_page(page);
 		return NOTIFY_BAD;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpu_set(cpu, prof_cpu_mask);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cpu_clear(cpu, prof_cpu_mask);
 		if (per_cpu(cpu_profile_hits, cpu)[0]) {
 			page =3D virt_to_page(per_cpu(cpu_profile_hits, cpu)[0]);
diff -puN kernel/rcupdate.c~add-suspend-related-notifications-for-cpu-h=
otplug kernel/rcupdate.c
--- a/kernel/rcupdate.c~add-suspend-related-notifications-for-cpu-hotpl=
ug
+++ a/kernel/rcupdate.c
@@ -558,9 +558,11 @@ static int __cpuinit rcu_cpu_notify(stru
 	long cpu =3D (long)hcpu;
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		rcu_offline_cpu(cpu);
 		break;
 	default:
diff -puN kernel/relay.c~add-suspend-related-notifications-for-cpu-hotp=
lug kernel/relay.c
--- a/kernel/relay.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/kernel/relay.c
@@ -490,6 +490,7 @@ static int __cpuinit relay_hotcpu_callba
=20
 	switch(action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&relay_channels_mutex);
 		list_for_each_entry(chan, &relay_channels, list) {
 			if (chan->buf[hotcpu])
@@ -506,6 +507,7 @@ static int __cpuinit relay_hotcpu_callba
 		mutex_unlock(&relay_channels_mutex);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/* No need to flush the cpu : will be flushed upon
 		 * final relay_flush() call. */
 		break;
diff -puN kernel/sched.c~add-suspend-related-notifications-for-cpu-hotp=
lug kernel/sched.c
--- a/kernel/sched.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/kernel/sched.c
@@ -5484,6 +5484,7 @@ migration_call(struct notifier_block *nf
 		break;
=20
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		p =3D kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
@@ -5497,12 +5498,14 @@ migration_call(struct notifier_block *nf
 		break;
=20
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		/* Strictly unneccessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
 		break;
=20
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!cpu_rq(cpu)->migration_thread)
 			break;
 		/* Unbind it from offline cpu so it can run.  Fall thru. */
@@ -5513,6 +5516,7 @@ migration_call(struct notifier_block *nf
 		break;
=20
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		migrate_live_tasks(cpu);
 		rq =3D cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -6975,14 +6979,20 @@ static int update_sched_domains(struct n
 {
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
 		return NOTIFY_OK;
=20
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/*
 		 * Fall through and re-initialise the domains.
 		 */
diff -puN kernel/softirq.c~add-suspend-related-notifications-for-cpu-ho=
tplug kernel/softirq.c
--- a/kernel/softirq.c~add-suspend-related-notifications-for-cpu-hotplu=
g
+++ a/kernel/softirq.c
@@ -595,6 +595,7 @@ static int __cpuinit cpu_callback(struct
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		p =3D kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
@@ -604,16 +605,19 @@ static int __cpuinit cpu_callback(struct
   		per_cpu(ksoftirqd, hotcpu) =3D p;
  		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(ksoftirqd, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(ksoftirqd, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		p =3D per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) =3D NULL;
 		kthread_stop(p);
diff -puN kernel/softlockup.c~add-suspend-related-notifications-for-cpu=
-hotplug kernel/softlockup.c
--- a/kernel/softlockup.c~add-suspend-related-notifications-for-cpu-hot=
plug
+++ a/kernel/softlockup.c
@@ -148,6 +148,7 @@ cpu_callback(struct notifier_block *nfb,
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		BUG_ON(per_cpu(watchdog_task, hotcpu));
 		p =3D kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
@@ -159,16 +160,19 @@ cpu_callback(struct notifier_block *nfb,
 		kthread_bind(p, hotcpu);
  		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(watchdog_task, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(watchdog_task, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		p =3D per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) =3D NULL;
 		kthread_stop(p);
diff -puN kernel/timer.c~add-suspend-related-notifications-for-cpu-hotp=
lug kernel/timer.c
--- a/kernel/timer.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/kernel/timer.c
@@ -1291,11 +1291,13 @@ static int __cpuinit timer_cpu_notify(st
 	long cpu =3D (long)hcpu;
 	switch(action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (init_timers_cpu(cpu) < 0)
 			return NOTIFY_BAD;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		migrate_timers(cpu);
 		break;
 #endif
diff -puN kernel/workqueue.c~add-suspend-related-notifications-for-cpu-=
hotplug kernel/workqueue.c
--- a/kernel/workqueue.c~add-suspend-related-notifications-for-cpu-hotp=
lug
+++ a/kernel/workqueue.c
@@ -757,6 +757,7 @@ static int __devinit workqueue_cpu_callb
 		return NOTIFY_OK;
=20
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		cpu_set(cpu, cpu_populated_map);
 	}
=20
@@ -765,19 +766,23 @@ static int __devinit workqueue_cpu_callb
=20
 		switch (action) {
 		case CPU_UP_PREPARE:
+		case CPU_UP_PREPARE_FROZEN:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue for %i failed\n", cpu);
 			return NOTIFY_BAD;
=20
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			wake_up_process(cwq->thread);
 			break;
=20
 		case CPU_UP_CANCELED:
+		case CPU_UP_CANCELED_FROZEN:
 			if (cwq->thread)
 				wake_up_process(cwq->thread);
 		case CPU_DEAD:
+		case CPU_DEAD_FROZEN:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
 		}
diff -puN lib/radix-tree.c~add-suspend-related-notifications-for-cpu-ho=
tplug lib/radix-tree.c
--- a/lib/radix-tree.c~add-suspend-related-notifications-for-cpu-hotplu=
g
+++ a/lib/radix-tree.c
@@ -1006,7 +1006,7 @@ static int radix_tree_callback(struct no
        struct radix_tree_preload *rtp;
=20
        /* Free per-cpu pool of perloaded nodes */
-       if (action =3D=3D CPU_DEAD) {
+       if (action =3D=3D CPU_DEAD || action =3D=3D CPU_DEAD_FROZEN) {
                rtp =3D &per_cpu(radix_tree_preloads, cpu);
                while (rtp->nr) {
                        kmem_cache_free(radix_tree_node_cachep,
diff -puN mm/page_alloc.c~add-suspend-related-notifications-for-cpu-hot=
plug mm/page_alloc.c
--- a/mm/page_alloc.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/mm/page_alloc.c
@@ -2494,11 +2494,14 @@ static int __cpuinit pageset_cpuup_callb
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (process_zones(cpu))
 			ret =3D NOTIFY_BAD;
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		free_zone_pagesets(cpu);
 		break;
 	default:
@@ -3605,7 +3608,7 @@ static int page_alloc_cpu_notify(struct=20
 {
 	int cpu =3D (unsigned long)hcpu;
=20
-	if (action =3D=3D CPU_DEAD) {
+	if (action =3D=3D CPU_DEAD || action =3D=3D CPU_DEAD_FROZEN) {
 		local_irq_disable();
 		__drain_pages(cpu);
 		vm_events_fold_cpu(cpu);
diff -puN mm/slab.c~add-suspend-related-notifications-for-cpu-hotplug m=
m/slab.c
--- a/mm/slab.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/mm/slab.c
@@ -1186,6 +1186,7 @@ static int __cpuinit cpuup_callback(stru
 		mutex_lock(&cache_chain_mutex);
 		break;
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		/*
 		 * We need to do this right in the beginning since
 		 * alloc_arraycache's are going to use this list.
@@ -1272,10 +1273,12 @@ static int __cpuinit cpuup_callback(stru
 		}
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
   	case CPU_DOWN_PREPARE:
+  	case CPU_DOWN_PREPARE_FROZEN:
 		/*
 		 * Shutdown cache reaper. Note that the cache_chain_mutex is
 		 * held so that if cache_reap() is invoked it cannot do
@@ -1287,9 +1290,11 @@ static int __cpuinit cpuup_callback(stru
 		per_cpu(reap_work, cpu).work.func =3D NULL;
   		break;
   	case CPU_DOWN_FAILED:
+  	case CPU_DOWN_FAILED_FROZEN:
 		start_cpu_timer(cpu);
   		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
 		 * kmem_list3 of any cache. This to avoid a race between
@@ -1301,6 +1306,7 @@ static int __cpuinit cpuup_callback(stru
 		/* fall thru */
 #endif
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
 			struct array_cache *shared;
diff -puN mm/slub.c~add-suspend-related-notifications-for-cpu-hotplug m=
m/slub.c
--- a/mm/slub.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/mm/slub.c
@@ -2367,7 +2367,9 @@ static int __cpuinit slab_cpuup_callback
=20
 	switch (action) {
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		for_all_slabs(__flush_cpu_slab, cpu);
 		break;
 	default:
diff -puN mm/swap.c~add-suspend-related-notifications-for-cpu-hotplug m=
m/swap.c
--- a/mm/swap.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/mm/swap.c
@@ -547,7 +547,7 @@ static int cpu_swap_callback(struct noti
 	long *committed;
=20
 	committed =3D &per_cpu(committed_space, (long)hcpu);
-	if (action =3D=3D CPU_DEAD) {
+	if (action =3D=3D CPU_DEAD || action =3D=3D CPU_DEAD_FROZEN) {
 		atomic_add(*committed, &vm_committed_space);
 		*committed =3D 0;
 		__lru_add_drain((long)hcpu);
diff -puN mm/vmscan.c~add-suspend-related-notifications-for-cpu-hotplug=
 mm/vmscan.c
--- a/mm/vmscan.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/mm/vmscan.c
@@ -1651,7 +1651,7 @@ static int __devinit cpu_callback(struct
 	pg_data_t *pgdat;
 	cpumask_t mask;
=20
-	if (action =3D=3D CPU_ONLINE) {
+	if (action =3D=3D CPU_ONLINE || action =3D=3D CPU_ONLINE_FROZEN) {
 		for_each_online_pgdat(pgdat) {
 			mask =3D node_to_cpumask(pgdat->node_id);
 			if (any_online_cpu(mask) !=3D NR_CPUS)
diff -puN mm/vmstat.c~add-suspend-related-notifications-for-cpu-hotplug=
 mm/vmstat.c
--- a/mm/vmstat.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/mm/vmstat.c
@@ -650,8 +650,11 @@ static int __cpuinit vmstat_cpuup_callba
 {
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
 		break;
 	default:
diff -puN net/core/dev.c~add-suspend-related-notifications-for-cpu-hotp=
lug net/core/dev.c
--- a/net/core/dev.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/net/core/dev.c
@@ -3463,7 +3463,7 @@ static int dev_cpu_callback(struct notif
 	unsigned int cpu, oldcpu =3D (unsigned long)ocpu;
 	struct softnet_data *sd, *oldsd;
=20
-	if (action !=3D CPU_DEAD)
+	if (action !=3D CPU_DEAD && action !=3D CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
=20
 	local_irq_disable();
diff -puN net/core/flow.c~add-suspend-related-notifications-for-cpu-hot=
plug net/core/flow.c
--- a/net/core/flow.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/net/core/flow.c
@@ -338,7 +338,7 @@ static int flow_cache_cpu(struct notifie
 			  unsigned long action,
 			  void *hcpu)
 {
-	if (action =3D=3D CPU_DEAD)
+	if (action =3D=3D CPU_DEAD || action =3D=3D CPU_DEAD_FROZEN)
 		__flow_cache_shrink((unsigned long)hcpu, 0);
 	return NOTIFY_OK;
 }
diff -puN net/iucv/iucv.c~add-suspend-related-notifications-for-cpu-hot=
plug net/iucv/iucv.c
--- a/net/iucv/iucv.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/net/iucv/iucv.c
@@ -527,6 +527,7 @@ static int __cpuinit iucv_cpu_notify(str
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (!percpu_populate(iucv_irq_data,
 				     sizeof(struct iucv_irq_data),
 				     GFP_KERNEL|GFP_DMA, cpu))
@@ -538,15 +539,20 @@ static int __cpuinit iucv_cpu_notify(str
 		}
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		percpu_depopulate(iucv_param, cpu);
 		percpu_depopulate(iucv_irq_data, cpu);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		smp_call_function_on(iucv_declare_cpu, NULL, 0, 1, cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpumask =3D iucv_buffer_cpumask;
 		cpu_clear(cpu, cpumask);
 		if (cpus_empty(cpumask))
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patc=
h
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race.patch
freezer-document-task_lock-in-thaw_process.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
