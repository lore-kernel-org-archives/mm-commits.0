From: akpm@linux-foundation.org
Subject: [folded] panic-dont-print-redundant-backtraces-on-oops-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:58:18 -0800
Message-ID: <20120113005819.1400E5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36893 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2AMA6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:58:21 -0500
Received: by wibhq12 with SMTP id hq12so87123wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:58:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, holzheu@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic-dont-print-redundant-backtraces-on-oops-fix
has been removed from the -mm tree.  Its filename was
     panic-dont-print-redundant-backtraces-on-oops-fix.patch

This patch was dropped because it was folded into panic-dont-print-redundant-backtraces-on-oops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-dont-print-redundant-backtraces-on-oops-fix

add comment

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/panic.c~panic-dont-print-redundant-backtraces-on-oops-fix kernel/panic.c
--- a/kernel/panic.c~panic-dont-print-redundant-backtraces-on-oops-fix
+++ a/kernel/panic.c
@@ -94,6 +94,9 @@ void panic(const char *fmt, ...)
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
+	/*
+	 * Avoid nested stack-dumping if a panic occurs during oops processing
+	 */
 	if (!oops_in_progress)
 		dump_stack();
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

