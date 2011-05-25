From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Tue, 24 May 2011 21:02:58 -0700
Message-ID: <201105250401.p4P41SNh002156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952Ab1EYEBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 00:01:30 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p4P41SXl031630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 24 May 2011 21:01:28 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN fs/proc/internal.h~linux-next-rejects fs/proc/internal.h
--- a/fs/proc/internal.h~linux-next-rejects
+++ a/fs/proc/internal.h
@@ -128,3 +128,17 @@ struct inode *proc_get_inode(struct supe
 int proc_readdir(struct file *, void *, filldir_t);
 struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
 
+/* Lookups */
+typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
+				struct task_struct *, const void *);
+int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
+	const char *name, int len,
+	instantiate_t instantiate, struct task_struct *task, const void *ptr);
+int pid_revalidate(struct dentry *dentry, struct nameidata *nd);
+struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *task);
+extern const struct dentry_operations pid_dentry_operations;
+int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
+int proc_setattr(struct dentry *dentry, struct iattr *attr);
+
+extern const struct inode_operations proc_ns_dir_inode_operations;
+extern const struct file_operations proc_ns_dir_operations;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
nommu-add-page-alignment-to-mmap.patch
alpha-hook-up-gpiolib-support.patch
cris-convert-old-cpumask-api-into-new-one.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch
printk-allocate-kernel-log-buffer-earlier-v2.patch
drivers-leds-leds-lm3530c-add-regulator.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation.patch
percpu_counter-change-return-value-and-add-comments.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
osst-wrong-index-used-in-inner-loop.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

