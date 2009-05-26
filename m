From: akpm@linux-foundation.org
Subject: + proc-merge-arrayc-into-basec-checkpatch-fixes.patch added to -mm tree
Date: Tue, 26 May 2009 13:34:55 -0700
Message-ID: <200905262034.n4QKYuDT015324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757356AbZEZUgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 16:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amwang@redhat.com


The patch titled
     proc-merge-arrayc-into-basec-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-merge-arrayc-into-basec-checkpatch-fixes.patch

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
Subject: proc-merge-arrayc-into-basec-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing statements should be on next line
#755: FILE: fs/proc/base.c:2629:
+		if (sigismember(set, i+1)) x |= 1;
+		if (sigismember(set, i+1)) x |= 1;
ERROR: trailing statements should be on next line
#756: FILE: fs/proc/base.c:2630:
+		if (sigismember(set, i+2)) x |= 2;
+		if (sigismember(set, i+2)) x |= 2;
ERROR: trailing statements should be on next line
#757: FILE: fs/proc/base.c:2631:
+		if (sigismember(set, i+3)) x |= 4;
+		if (sigismember(set, i+3)) x |= 4;
ERROR: trailing statements should be on next line
#758: FILE: fs/proc/base.c:2632:
+		if (sigismember(set, i+4)) x |= 8;
+		if (sigismember(set, i+4)) x |= 8;
total: 4 errors, 0 warnings, 519 lines checked

./patches/proc-merge-arrayc-into-basec.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-merge-arrayc-into-basec-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~proc-merge-arrayc-into-basec-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -2626,10 +2626,14 @@ static void render_sigset_t(struct seq_f
 		int x = 0;
 
 		i -= 4;
-		if (sigismember(set, i+1)) x |= 1;
-		if (sigismember(set, i+2)) x |= 2;
-		if (sigismember(set, i+3)) x |= 4;
-		if (sigismember(set, i+4)) x |= 8;
+		if (sigismember(set, i+1))
+			x |= 1;
+		if (sigismember(set, i+2))
+			x |= 2;
+		if (sigismember(set, i+3))
+			x |= 4;
+		if (sigismember(set, i+4))
+			x |= 8;
 		seq_printf(m, "%x", x);
 	} while (i >= 4);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
drivers-usb-serial-sierrac-fix-printk-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
revert-fbdev-uninline-lock_fb_info.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

