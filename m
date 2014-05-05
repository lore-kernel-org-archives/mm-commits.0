From: akpm@linux-foundation.org
Subject: + kernel-cpuc-convert-printk-to-pr_foo.patch added to -mm tree
Date: Mon, 05 May 2014 13:14:00 -0700
Message-ID: <5367f108.LBa8ZTM63UZPUZY0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEEUOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com, peterz@infradead.org, mingo@elte.hu, fabf@skynet.be

Subject: + kernel-cpuc-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,mingo@elte.hu,peterz@infradead.org,rafael.j.wysocki@intel.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:14:00 -0700


The patch titled
     Subject: kernel/cpu.c: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     kernel-cpuc-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuc-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuc-convert-printk-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/cpu.c: convert printk to pr_foo()

no level printk converted to pr_warn (if err)
no level printk converted to pr_info (disabling non-boot cpus)
Other printk converted to respective level.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff -puN kernel/cpu.c~kernel-cpuc-convert-printk-to-pr_foo kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-convert-printk-to-pr_foo
+++ a/kernel/cpu.c
@@ -283,8 +283,7 @@ static inline void check_for_tasks(int c
 		task_cputime(p, &utime, &stime);
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (utime || stime))
-			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
-				"(state = %ld, flags = %x)\n",
+			pr_warn("Task %s (pid = %d) is on cpu %d (state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
 				p->state, p->flags);
 	}
@@ -336,8 +335,8 @@ static int __ref _cpu_down(unsigned int
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
-				__func__, cpu);
+		pr_warn("%s: attempt to take down CPU %u failed\n",
+			__func__, cpu);
 		goto out_release;
 	}
 
@@ -444,8 +443,8 @@ static int _cpu_up(unsigned int cpu, int
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
-		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
-				__func__, cpu);
+		pr_warn("%s: attempt to bring up CPU %u failed\n",
+			__func__, cpu);
 		goto out_notify;
 	}
 
@@ -475,11 +474,10 @@ int cpu_up(unsigned int cpu)
 	int err = 0;
 
 	if (!cpu_possible(cpu)) {
-		printk(KERN_ERR "can't online cpu %d because it is not "
-			"configured as may-hotadd at boot time\n", cpu);
+		pr_err("can't online cpu %d because it is not configured as may-hotadd at boot time\n",
+		       cpu);
 #if defined(CONFIG_IA64)
-		printk(KERN_ERR "please check additional_cpus= boot "
-				"parameter\n");
+		pr_err("please check additional_cpus= boot parameter\n");
 #endif
 		return -EINVAL;
 	}
@@ -518,7 +516,7 @@ int disable_nonboot_cpus(void)
 	 */
 	cpumask_clear(frozen_cpus);
 
-	printk("Disabling non-boot CPUs ...\n");
+	pr_info("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
@@ -526,8 +524,7 @@ int disable_nonboot_cpus(void)
 		if (!error)
 			cpumask_set_cpu(cpu, frozen_cpus);
 		else {
-			printk(KERN_ERR "Error taking CPU%d down: %d\n",
-				cpu, error);
+			pr_err("Error taking CPU%d down: %d\n", cpu, error);
 			break;
 		}
 	}
@@ -537,7 +534,7 @@ int disable_nonboot_cpus(void)
 		/* Make sure the CPUs won't be enabled by someone else */
 		cpu_hotplug_disabled = 1;
 	} else {
-		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
+		pr_err("Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
 	return error;
@@ -561,17 +558,17 @@ void __ref enable_nonboot_cpus(void)
 	if (cpumask_empty(frozen_cpus))
 		goto out;
 
-	printk(KERN_INFO "Enabling non-boot CPUs ...\n");
+	pr_info("Enabling non-boot CPUs ...\n");
 
 	arch_enable_nonboot_cpus_begin();
 
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
-			printk(KERN_INFO "CPU%d is up\n", cpu);
+			pr_info("CPU%d is up\n", cpu);
 			continue;
 		}
-		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
+		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
 	}
 
 	arch_enable_nonboot_cpus_end();
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
kernel-exec_domainc-code-clean-up.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch

