From: akpm@linux-foundation.org
Subject: + s390-handle-new-__get_cpu_var-calls-added-in-314.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:49 -0800
Message-ID: <53165365.Mx6Paf8hP9p5aCAs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbaCDW1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, cl@linux.com

Subject: + s390-handle-new-__get_cpu_var-calls-added-in-314.patch added to -mm tree
To: cl@linux.com,heiko.carstens@de.ibm.com,schwidefsky@de.ibm.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:49 -0800


The patch titled
     Subject: s390: handle new __get_cpu_var calls added in 3.14
has been added to the -mm tree.  Its filename is
     s390-handle-new-__get_cpu_var-calls-added-in-314.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-handle-new-__get_cpu_var-calls-added-in-314.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-handle-new-__get_cpu_var-calls-added-in-314.patch

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
Subject: s390: handle new __get_cpu_var calls added in 3.14

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/perf_cpum_sf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/s390/kernel/perf_cpum_sf.c~s390-handle-new-__get_cpu_var-calls-added-in-314 arch/s390/kernel/perf_cpum_sf.c
--- a/arch/s390/kernel/perf_cpum_sf.c~s390-handle-new-__get_cpu_var-calls-added-in-314
+++ a/arch/s390/kernel/perf_cpum_sf.c
@@ -562,7 +562,7 @@ static DEFINE_MUTEX(pmc_reserve_mutex);
 static void setup_pmc_cpu(void *flags)
 {
 	int err;
-	struct cpu_hw_sf *cpusf = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpusf = this_cpu_ptr(&cpu_hw_sf);
 
 	err = 0;
 	switch (*((int *) flags)) {
@@ -849,7 +849,7 @@ static int cpumsf_pmu_event_init(struct
 
 static void cpumsf_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hw_perf_event *hwc;
 	int err;
 
@@ -898,7 +898,7 @@ static void cpumsf_pmu_enable(struct pmu
 
 static void cpumsf_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hws_lsctl_request_block inactive;
 	struct hws_qsi_info_block si;
 	int err;
@@ -1306,7 +1306,7 @@ static void cpumsf_pmu_read(struct perf_
  */
 static void cpumsf_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
 		return;
@@ -1327,7 +1327,7 @@ static void cpumsf_pmu_start(struct perf
  */
 static void cpumsf_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	if (event->hw.state & PERF_HES_STOPPED)
 		return;
@@ -1346,7 +1346,7 @@ static void cpumsf_pmu_stop(struct perf_
 
 static int cpumsf_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	int err;
 
 	if (cpuhw->flags & PMU_F_IN_USE)
@@ -1397,7 +1397,7 @@ out:
 
 static void cpumsf_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	perf_pmu_disable(event->pmu);
 	cpumsf_pmu_stop(event, PERF_EF_UPDATE);
@@ -1470,7 +1470,7 @@ static void cpumf_measurement_alert(stru
 	if (!(alert & CPU_MF_INT_SF_MASK))
 		return;
 	inc_irq_stat(IRQEXT_CMS);
-	cpuhw = &__get_cpu_var(cpu_hw_sf);
+	cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	/* Measurement alerts are shared and might happen when the PMU
 	 * is not reserved.  Ignore these alerts in this case. */
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

