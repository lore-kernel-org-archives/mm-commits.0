From: akpm@linux-foundation.org
Subject: [merged] scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:26 -0700
Message-ID: <533f0942.rv/kVd5EH1LnpYDx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaDDTe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, rientjes@google.com, joe@perches.com, akpm@linux-foundation.org

Subject: [merged] scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch removed from -mm tree
To: akpm@linux-foundation.org,joe@perches.com,rientjes@google.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:26 -0700


The patch titled
     Subject: scripts/checkpatch.pl: __GFP_NOFAIL isn't going away
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/checkpatch.pl: __GFP_NOFAIL isn't going away

Revert 7e4915e78992eb ("checkpatch: add warning of future __GFP_NOFAIL use").

There are no plans to remove __GFP_NOFAIL.

__GFP_NOFAIL exists to

a) centralise the retry-allocation-for-ever operation into the core
   allocator, which is the appropriate implementation site and

b) permit us to identify code sites which aren't handling memory
   exhaustion appropriately.

Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ------
 1 file changed, 6 deletions(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-__gfp_nofail-isnt-going-away scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-__gfp_nofail-isnt-going-away
+++ a/scripts/checkpatch.pl
@@ -4330,12 +4330,6 @@ sub process {
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
 
-# check for GFP_NOWAIT use
-		if ($line =~ /\b__GFP_NOFAIL\b/) {
-			WARN("__GFP_NOFAIL",
-			     "Use of __GFP_NOFAIL is deprecated, no new users should be added\n" . $herecurr);
-		}
-
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			if (WARN("ONE_SEMICOLON",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

