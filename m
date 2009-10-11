From: akpm@linux-foundation.org
Subject: + hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch added to -mm tree
Date: Sun, 11 Oct 2009 00:52:20 -0700
Message-ID: <200910110752.n9B7qKF8019794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbZJKHyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Oct 2009 03:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ben@decadent.org.uk, snakebyte@gmx.de, stable@kernel.org, zippel@linux-m68k.org


The patch titled
     hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix
has been added to the -mm tree.  Its filename is
     hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch

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
Subject: hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix 32 and 64-bit issues

Cc: <stable@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix
+++ a/fs/hfsplus/wrapper.c
@@ -99,7 +99,7 @@ int hfsplus_read_wrapper(struct super_bl
 
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		return -EINVAL;
-	if (part_start + part_size > 0x100000000) {
+	if ((u64)part_start + part_size > 0x100000000ULL) {
 		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
munmap-dont-check-sysctl_max_mapcount-fix.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

