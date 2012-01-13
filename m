From: akpm@linux-foundation.org
Subject: [folded] mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:57:18 -0800
Message-ID: <20120113005719.B540420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37964 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab2AMA5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:57:21 -0500
Received: by werg1 with SMTP id g1so28wer.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:57:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, consul.kautuk@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch

This patch was dropped because it was folded into mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix

remove now-unneeded tests

Cc: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix
+++ a/mm/vmalloc.c
@@ -2476,10 +2476,8 @@ found:
 
 err_free:
 	for (area = 0; area < nr_vms; area++) {
-		if (vas)
-			kfree(vas[area]);
-		if (vms)
-			kfree(vms[area]);
+		kfree(vas[area]);
+		kfree(vms[area]);
 	}
 err_free2:
 	kfree(vas);
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
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

