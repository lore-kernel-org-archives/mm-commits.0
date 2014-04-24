From: akpm@linux-foundation.org
Subject: + fs-pstore-logging-clean-up-fix.patch added to -mm tree
Date: Thu, 24 Apr 2014 10:53:57 -0700
Message-ID: <53594fb5.TMdq2uwe2mx7npKN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbaDXRx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 13:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be, ccross@android.com, anton@enomsg.org, akpm@linux-foundation.org

Subject: + fs-pstore-logging-clean-up-fix.patch added to -mm tree
To: akpm@linux-foundation.org,anton@enomsg.org,ccross@android.com,fabf@skynet.be,joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 10:53:57 -0700


The patch titled
     Subject: fs-pstore-logging-clean-up-fix
has been added to the -mm tree.  Its filename is
     fs-pstore-logging-clean-up-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-pstore-logging-clean-up-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-pstore-logging-clean-up-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-pstore-logging-clean-up-fix

missed a couple of prefix removals

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/platform.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/pstore/platform.c~fs-pstore-logging-clean-up-fix fs/pstore/platform.c
--- a/fs/pstore/platform.c~fs-pstore-logging-clean-up-fix
+++ a/fs/pstore/platform.c
@@ -455,8 +455,7 @@ int pstore_register(struct pstore_info *
 		add_timer(&pstore_timer);
 	}
 
-	pr_info("pstore: Registered %s as persistent store backend\n",
-		psi->name);
+	pr_info("Registered %s as persistent store backend\n", psi->name);
 
 	return 0;
 }
@@ -502,7 +501,7 @@ void pstore_get_records(int quiet)
 				size = unzipped_len;
 				compressed = false;
 			} else {
-				pr_err("pstore: decompression failed;returned %d\n",
+				pr_err("decompression failed;returned %d\n",
 				       unzipped_len);
 				compressed = true;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
fs-pstore-logging-clean-up-fix.patch
sysrq-rcu-ify-__handle_sysrq-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

