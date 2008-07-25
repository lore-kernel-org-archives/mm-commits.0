From: akpm@linux-foundation.org
Subject: - tsacct-fix-bacct_add_tsks-use-of-do_div.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:12 -0700
Message-ID: <200807252303.m6PN3CjX003935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbYGYXEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jlan@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     tsacct: fix bacct_add_tsk()'s use of do_div()
has been removed from the -mm tree.  Its filename was
     tsacct-fix-bacct_add_tsks-use-of-do_div.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
mutex-subsystem-synchro-test-module.patch

