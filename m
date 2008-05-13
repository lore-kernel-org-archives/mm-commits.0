From: akpm@linux-foundation.org
Subject: - revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch removed from -mm tree
Date: Tue, 13 May 2008 09:24:21 -0700
Message-ID: <200805131624.m4DGOLdG021009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756849AbYEMQYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 12:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arges@linux.vnet.ibm.com, gxt@cs.nott.ac.uk, maynardj@us.ibm.com, phil.el@wanadoo.fr, torvalds@linux-foundation.org, travis@sgi.com, vegard.nossum@gmail.com


The patch titled
     revert "oprofile: change cpu_buffer from array to per_cpu variable"
has been removed from the -mm tree.  Its filename was
     revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "oprofile: change cpu_buffer from array to per_cpu variable"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 608dfddd845da5ab6accef70154c8910529699f7
Author: Mike Travis <travis@sgi.com>
Date:   Mon Apr 28 02:14:15 2008 -0700

    oprofile: change cpu_buffer from array to per_cpu variable
    
    Change cpu_buffer from array to per_cpu variable in oprofile functions.
    
    [akpm@linux-foundation.org: coding-style fixes]
    Cc: Philippe Elie <phil.el@wanadoo.fr>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Due to this:

On Mon, 12 May 2008 13:02:36 +0100 Gianni Tedesco <gxt@cs.nott.ac.uk> wrote:
>
> This is from Linus' git tree, pulled this morning. To reproduce simply
> opcontrol --start
> 
> oprofile: using NMI interrupt.
> BUG: unable to handle kernel paging request at eff86d58
> IP: [<eeb9d508>] :oprofile:alloc_cpu_buffers+0x42/0xd6
> *pde = 00000000 
> Oops: 0002 [#1] SMP 
> Modules linked in: oprofile af_packet i915 drm binfmt_misc kvm_intel kvm cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_ondemand cpufreq_conservative sbs fan sbshc iptable_filter ip_tables x_tables ipcomp authenc esp4 aead ah4 xfrm4_mode_transport deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc sha256_generic sha1_generic md5 hmac crypto_hash crypto_null af_key sierra usbserial snd_usb_audio snd_usb_lib snd_hwdep fuse arc4 ecb crypto_blkcipher cryptomgr crypto_algapi snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq yenta_socket iwl3945 mac80211 rsrc_nonstatic ehci_hcd snd_timer snd_seq_device uhci_hcd cfg80211 snd pcmcia_core usbcore s
 oundcore snd_page_alloc battery ac thinkpad_acpi backlight button led_class thermal evdev nvram
> 
> Pid: 4589, comm: oprofiled Not tainted (2.6.26-rc2 #37)
> EIP: 0060:[<eeb9d508>] EFLAGS: 00010286 CPU: 1
> EIP is at alloc_cpu_buffers+0x42/0xd6 [oprofile]
> EAX: eeba5000 EBX: eff86d40 ECX: eeb9d506 EDX: 00000000
> ESI: 00000000 EDI: eeba2d40 EBP: 00002000 ESP: e6824e94
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process oprofiled (pid: 4589, ti=e6824000 task=ed109560 task.ti=e6824000)
> Stack: 00010000 ffffffea d04eaec0 e6824f14 eeb9dcc5 eeb9d114 ffffffea d04eaec0 
>        eeb9dcfe d04eaec0 d0d7fcf4 b0158a50 ec9379c0 d0ddbc6c e6824f14 d04eaec0 
>        e6824f14 00000001 b0158b55 d04eaec0 00000000 00000000 e6824f14 b01628fd 
> Call Trace:
>  [<eeb9dcc5>] event_buffer_open+0x0/0x55 [oprofile]
>  [<eeb9d114>] oprofile_setup+0x11/0x85 [oprofile]
>  [<eeb9dcfe>] event_buffer_open+0x39/0x55 [oprofile]
>  [<b0158a50>] __dentry_open+0xfd/0x1e6
>  [<b0158b55>] nameidata_to_filp+0x1c/0x2c
>  [<b01628fd>] do_filp_open+0x31c/0x676
>  [<b014a4cc>] handle_mm_fault+0x1c6/0x48d
>  [<b0158875>] do_sys_open+0x3d/0xb5
>  [<b0111723>] do_page_fault+0x206/0x523
>  [<b0158931>] sys_open+0x1e/0x23
>  [<b0102a79>] sysenter_past_esp+0x6a/0x91
>  [<b02e0000>] lock_kernel+0x2f/0x31
>  =======================
> Code: e8 db 77 63 c1 89 c6 8d 04 ed 00 00 00 00 89 04 24 e9 8b 00 00 00 8b 04 24 31 d2 89 fb 03 1c b5 80 de 39 b0 e8 9d 28 5b c1 85 c0 <89> 43 18 74 7e 8d 43 34 c7 43 04 00 00 00 00 89 73 2c 89 43 34 
> EIP: [<eeb9d508>] alloc_cpu_buffers+0x42/0xd6 [oprofile] SS:ESP
> 0068:e6824e94

Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: Mike Travis <travis@sgi.com>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: Gianni Tedesco <gxt@cs.nott.ac.uk>
Cc: Maynard Johnson <maynardj@us.ibm.com>
Cc: Chris J Arges <arges@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/buffer_sync.c    |    2 +-
 drivers/oprofile/cpu_buffer.c     |   16 ++++++++--------
 drivers/oprofile/cpu_buffer.h     |    3 +--
 drivers/oprofile/oprofile_stats.c |    4 ++--
 4 files changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/buffer_sync.c
@@ -491,7 +491,7 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[cpu];
 	struct mm_struct *mm = NULL;
 	struct task_struct * new;
 	unsigned long cookie = 0;
diff -puN drivers/oprofile/cpu_buffer.c~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/cpu_buffer.c
@@ -27,7 +27,7 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer);
+struct oprofile_cpu_buffer cpu_buffer[NR_CPUS] __cacheline_aligned;
 
 static void wq_sync_buffer(struct work_struct *work);
 
@@ -39,7 +39,7 @@ void free_cpu_buffers(void)
 	int i;
  
 	for_each_online_cpu(i)
-		vfree(per_cpu(cpu_buffer, i).buffer);
+		vfree(cpu_buffer[i].buffer);
 }
 
 int alloc_cpu_buffers(void)
@@ -49,7 +49,7 @@ int alloc_cpu_buffers(void)
 	unsigned long buffer_size = fs_cpu_buffer_size;
  
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
  
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
 			cpu_to_node(i));
@@ -83,7 +83,7 @@ void start_cpu_work(void)
 	work_enabled = 1;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
 
 		/*
 		 * Spread the work by 1 jiffy per cpu so they dont all
@@ -100,7 +100,7 @@ void end_cpu_work(void)
 	work_enabled = 0;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
 
 		cancel_delayed_work(&b->work);
 	}
@@ -227,7 +227,7 @@ static void oprofile_end_trace(struct op
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
 
 	if (!backtrace_depth) {
 		log_sample(cpu_buf, pc, is_kernel, event);
@@ -254,13 +254,13 @@ void oprofile_add_sample(struct pt_regs 
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
 	log_sample(cpu_buf, pc, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
 
 	if (!cpu_buf->tracing)
 		return;
diff -puN drivers/oprofile/cpu_buffer.h~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/cpu_buffer.h
--- a/drivers/oprofile/cpu_buffer.h~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/cpu_buffer.h
@@ -14,7 +14,6 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/cache.h>
-#include <linux/sched.h>
  
 struct task_struct;
  
@@ -48,7 +47,7 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 } ____cacheline_aligned;
 
-DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
+extern struct oprofile_cpu_buffer cpu_buffer[];
 
 void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
 
diff -puN drivers/oprofile/oprofile_stats.c~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/oprofile_stats.c
--- a/drivers/oprofile/oprofile_stats.c~revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/oprofile_stats.c
@@ -23,7 +23,7 @@ void oprofile_reset_stats(void)
 	int i;
  
 	for_each_possible_cpu(i) {
-		cpu_buf = &per_cpu(cpu_buffer, i);
+		cpu_buf = &cpu_buffer[i];
 		cpu_buf->sample_received = 0;
 		cpu_buf->sample_lost_overflow = 0;
 		cpu_buf->backtrace_aborted = 0;
@@ -49,7 +49,7 @@ void oprofile_create_stats_files(struct 
 		return;
 
 	for_each_possible_cpu(i) {
-		cpu_buf = &per_cpu(cpu_buffer, i);
+		cpu_buf = &cpu_buffer[i];
 		snprintf(buf, 10, "cpu%d", i);
 		cpudir = oprofilefs_mkdir(sb, dir, buf);
  
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off.patch
fix-hfsplus-oops-on-image-without-extents.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
atmel_lcdfb-fix-pixclok-divider-calculation.patch
memcg-fix-possible-panic-when-config_mm_owner=y.patch
drivers-char-synclink_gtc-dont-return-an-uninitialised-local.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
ia64-kvm-dont-delete-files-which-we-need.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
revert-oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-early_init_centaur-use-set_cpu_cap.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fix-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix-2.patch
git-ubifs.patch
hysdn-no-longer-broken-on-smp.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
selinux-dopey-hack.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
revert-git-block.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

