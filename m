From: akpm@linux-foundation.org
Subject: + fix-sscanf-%n-match-at-end-of-input-string-tidy.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:17:06 -0800
Message-ID: <200703252217.l2PMH63d004057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60473 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXCYWRT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, johannes@sipsolutions.net


The patch titled
     fix-sscanf-%n-match-at-end-of-input-string-tidy
has been added to the -mm tree.  Its filename is
     fix-sscanf-%n-match-at-end-of-input-string-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-sscanf-%n-match-at-end-of-input-string-tidy
From: Andrew Morton <akpm@linux-foundation.org>

- Fix comment layout

- Fix coding style

- `i' is a funny identifier for a pointer.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN lib/vsprintf.c~fix-sscanf-%n-match-at-end-of-input-string-tidy lib/vsprintf.c
--- a/lib/vsprintf.c~fix-sscanf-%n-match-at-end-of-input-string-tidy
+++ a/lib/vsprintf.c
@@ -826,12 +826,14 @@ int vsscanf(const char * buf, const char
 		str = next;
 	}
 
-	/* Now we've come all the way through so either the input string or
-	 * the format ended. In the former case, there can be a %n at the
-	 * current position in the format that needs to be filled. */
-	if (*fmt == '%' && *(fmt+1) == 'n') {
-		int *i = (int *)va_arg(args,int*);
-		*i = str - buf;
+	/*
+	 * Now we've come all the way through so either the input string or the
+	 * format ended. In the former case, there can be a %n at the current
+	 * position in the format that needs to be filled.
+	 */
+	if (*fmt == '%' && *(fmt + 1) == 'n') {
+		int *p = (int *)va_arg(args, int *);
+		*p = str - buf;
 	}
 
 	return num;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ext-ea-block-reference-count-racing-fix-performance-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-net.patch
git-net-fixup.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
