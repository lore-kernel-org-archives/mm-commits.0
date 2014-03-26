From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 26 Mar 2014 12:30:08 -0700
Message-ID: <53332ac0./Qlc0JJZCImM5657%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaCZTaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 15:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 12:30:08 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_ddi.c |    5 -----
 drivers/gpu/drm/i915/intel_dp.c  |   18 ------------------
 include/trace/ftrace.h           |    9 ---------
 kernel/trace/trace_export.c      |    7 -------
 4 files changed, 39 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_ddi.c
--- a/drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ddi.c
@@ -1340,13 +1340,8 @@ static void intel_ddi_post_disable(struc
 	if (type == INTEL_OUTPUT_DISPLAYPORT || type == INTEL_OUTPUT_EDP) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 		intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_OFF);
-<<<<<<< HEAD
-		ironlake_edp_panel_vdd_on(intel_dp);
-		ironlake_edp_panel_off(intel_dp);
-=======
 		intel_edp_panel_vdd_on(intel_dp);
 		intel_edp_panel_off(intel_dp);
->>>>>>> linux-next/akpm-base
 	}
 
 	I915_WRITE(PORT_CLK_SEL(port), PORT_CLK_SEL_NONE);
diff -puN drivers/gpu/drm/i915/intel_dp.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_dp.c
--- a/drivers/gpu/drm/i915/intel_dp.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_dp.c
@@ -1214,22 +1214,15 @@ void intel_edp_panel_off(struct intel_dp
 
 	DRM_DEBUG_KMS("Turn eDP power off\n");
 
-<<<<<<< HEAD
-=======
 	edp_wait_backlight_off(intel_dp);
 
->>>>>>> linux-next/akpm-base
 	WARN(!intel_dp->want_panel_vdd, "Need VDD to turn off panel\n");
 
 	pp = ironlake_get_pp_control(intel_dp);
 	/* We need to switch off panel power _and_ force vdd, for otherwise some
 	 * panels get very unhappy and cease to work. */
-<<<<<<< HEAD
-	pp &= ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_ENABLE);
-=======
 	pp &= ~(POWER_TARGET_ON | PANEL_POWER_RESET | EDP_FORCE_VDD |
 		EDP_BLC_ENABLE);
->>>>>>> linux-next/akpm-base
 
 	pp_ctrl_reg = _pp_ctrl_reg(intel_dp);
 
@@ -1238,14 +1231,8 @@ void intel_edp_panel_off(struct intel_dp
 	I915_WRITE(pp_ctrl_reg, pp);
 	POSTING_READ(pp_ctrl_reg);
 
-<<<<<<< HEAD
-	intel_dp->want_panel_vdd = false;
-
-	ironlake_wait_panel_off(intel_dp);
-=======
 	intel_dp->last_power_cycle = jiffies;
 	wait_panel_off(intel_dp);
->>>>>>> linux-next/akpm-base
 
 	/* We got a reference when we enabled the VDD. */
 	intel_runtime_pm_put(dev_priv);
@@ -1779,13 +1766,8 @@ static void intel_disable_dp(struct inte
 
 	/* Make sure the panel is off before trying to change the mode. But also
 	 * ensure that we have vdd while we switch off the panel. */
-<<<<<<< HEAD
-	ironlake_edp_panel_vdd_on(intel_dp);
-	ironlake_edp_backlight_off(intel_dp);
-=======
 	intel_edp_panel_vdd_on(intel_dp);
 	intel_edp_backlight_off(intel_dp);
->>>>>>> linux-next/akpm-base
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_OFF);
 	intel_edp_panel_off(intel_dp);
 
diff -puN include/trace/ftrace.h~linux-next-git-rejects include/trace/ftrace.h
--- a/include/trace/ftrace.h~linux-next-git-rejects
+++ a/include/trace/ftrace.h
@@ -302,20 +302,11 @@ static struct trace_event_functions ftra
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
-<<<<<<< HEAD
-		char *type_str = #type"["__stringify(len)"]";		\
-		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		ret = trace_define_field(event_call, type_str, #item,	\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
-=======
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
 		ret = ftrace_event_define_field(event_call, #type, len,	\
 				#item, offsetof(typeof(field), item),   \
 				sizeof(field.item),			\
 			 	is_signed_type(type), FILTER_OTHER); \
->>>>>>> linux-next/akpm-base
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff -puN kernel/trace/trace_export.c~linux-next-git-rejects kernel/trace/trace_export.c
--- a/kernel/trace/trace_export.c~linux-next-git-rejects
+++ a/kernel/trace/trace_export.c
@@ -97,17 +97,10 @@ static void __always_unused ____ftrace_c
 	do {								\
 		char *type_str = #type"["__stringify(len)"]";		\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-<<<<<<< HEAD
-		ret = trace_define_field(event_call, type_str, #item,	\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), filter_type);	\
-=======
 		ret = ftrace_event_define_field(event_call, #type, len,	\
 				#item, offsetof(typeof(field), item),   \
 				sizeof(field.item),			\
 			 	is_signed_type(type), filter_type);	\
->>>>>>> linux-next/akpm-base
 		if (ret)						\
 			return ret;					\
 	} while (0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

