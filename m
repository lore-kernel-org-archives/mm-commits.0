From: akpm@linux-foundation.org
Subject: + net-sctp-socketc-squish-warning.patch added to -mm tree
Date: Mon, 21 Dec 2009 13:12:50 -0800
Message-ID: <200912212137.nBLLbKNI030268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326AbZLUVha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 16:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andrei@iptel.org, davem@davemloft.net, vladislav.yasevich@hp.com


The patch titled
     net/sctp/socket.c: squish warning
has been added to the -mm tree.  Its filename is
     net-sctp-socketc-squish-warning.patch

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
Subject: net/sctp/socket.c: squish warning
From: Andrew Morton <akpm@linux-foundation.org>

net/sctp/socket.c: In function 'sctp_setsockopt_autoclose':
net/sctp/socket.c:2090: warning: comparison is always false due to limited range of data type

Cc: Andrei Pelinescu-Onciul <andrei@iptel.org>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/sctp/socket.c~net-sctp-socketc-squish-warning net/sctp/socket.c
--- a/net/sctp/socket.c~net-sctp-socketc-squish-warning
+++ a/net/sctp/socket.c
@@ -2087,8 +2087,7 @@ static int sctp_setsockopt_autoclose(str
 	if (copy_from_user(&sp->autoclose, optval, optlen))
 		return -EFAULT;
 	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
-	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
-		sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;
+	sp->autoclose = min_t(long, sp->autoclose, MAX_SCHEDULE_TIMEOUT / HZ);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kfifo-move-struct-kfifo-in-place-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
net-sctp-socketc-squish-warning.patch

