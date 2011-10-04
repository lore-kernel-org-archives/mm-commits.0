From: akpm@google.com
Subject: [obsolete] cgroups-create-a-workqueue-for-cgroup-fix.patch removed from -mm tree
Date: Tue, 04 Oct 2011 14:10:36 -0700
Message-ID: <201110042110.p94LAarU002603@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:27508 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab1JDVLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, miaox@cn.fujitsu.com, mingo@redhat.com, nishimura@mxp.nes.nec.co.jp, paul@paulmenage.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups-create-a-workqueue-for-cgroup-fix
has been removed from the -mm tree.  Its filename was
     cgroups-create-a-workqueue-for-cgroup-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cgroups-create-a-workqueue-for-cgroup-fix

s/queue_cgroup_work/cgroup_queue_work/

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/cgroup.h |    2 +-
 kernel/cgroup.c        |    4 ++--
 kernel/cpuset.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-create-a-workqueue-for-cgroup-fix include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-create-a-workqueue-for-cgroup-fix
+++ a/include/linux/cgroup.h
@@ -28,7 +28,7 @@ struct css_id;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_wq_init(void);
-extern void queue_cgroup_work(struct work_struct *work);
+extern void cgroup_queue_work(struct work_struct *work);
 extern void cgroup_lock(void);
 extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
diff -puN kernel/cgroup.c~cgroups-create-a-workqueue-for-cgroup-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-create-a-workqueue-for-cgroup-fix
+++ a/kernel/cgroup.c
@@ -4388,7 +4388,7 @@ void __init cgroup_wq_init(void)
 	BUG_ON(!cgroup_wq);
 }
 
-void queue_cgroup_work(struct work_struct *work)
+void cgroup_queue_work(struct work_struct *work)
 {
 	queue_work(cgroup_wq, work);
 }
@@ -4701,7 +4701,7 @@ static void check_for_release(struct cgr
 		}
 		raw_spin_unlock(&release_list_lock);
 		if (need_schedule_work)
-			queue_cgroup_work(&release_agent_work);
+			cgroup_queue_work(&release_agent_work);
 	}
 }
 
diff -puN kernel/cpuset.c~cgroups-create-a-workqueue-for-cgroup-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-create-a-workqueue-for-cgroup-fix
+++ a/kernel/cpuset.c
@@ -759,7 +759,7 @@ static DECLARE_WORK(rebuild_sched_domain
  */
 static void async_rebuild_sched_domains(void)
 {
-	queue_cgroup_work(&rebuild_sched_domains_work);
+	cgroup_queue_work(&rebuild_sched_domains_work);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

