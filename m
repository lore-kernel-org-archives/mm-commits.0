From: akpm@linux-foundation.org
Subject: + tsacct-fix-bacct_add_tsks-use-of-do_div.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:30:29 -0700
Message-ID: <200807130530.m6D5UTwh006040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbYGMFbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:31:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jlan@engr.sgi.com


The patch titled
     tsacct: fix bacct_add_tsk()'s use of do_div()
has been added to the -mm tree.  Its filename is
     tsacct-fix-bacct_add_tsks-use-of-do_div.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tsacct: fix bacct_add_tsk()'s use of do_div()
From: David Howells <dhowells@redhat.com>

Fix bacct_add_tsk()'s use of do_div() on an s64 by making ac_etime a u64
instead and dividing that.

Possibly this should be guarded lest the interval calculation turn up
negative, but the possible negativity of the result of the division is
cast away, and it shouldn't end up negative anyway.

This was introduced by patch f3cef7a99469afc159fec3a61b42dc7ca5b6824f.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/tsacct.c~tsacct-fix-bacct_add_tsks-use-of-do_div kernel/tsacct.c
--- a/kernel/tsacct.c~tsacct-fix-bacct_add_tsks-use-of-do_div
+++ a/kernel/tsacct.c
@@ -28,14 +28,14 @@
 void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 {
 	struct timespec uptime, ts;
-	s64 ac_etime;
+	u64 ac_etime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
 	ts = timespec_sub(uptime, tsk->start_time);
-	/* rebase elapsed time to usec */
+	/* rebase elapsed time to usec (should never be negative) */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
 	stats->ac_etime = ac_etime;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-fix-irqs_disabled-to-return-an-int-not-an-unsigned-long.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

