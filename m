From: akpm@linux-foundation.org
Subject: + vmscan-force-scan-offline-memory-cgroups-fix.patch added to -mm tree
Date: Thu, 15 Jan 2015 15:33:10 -0800
Message-ID: <54b84e36.syWfkDgcsIW066KZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbAOXdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan-force-scan-offline-memory-cgroups-fix
has been added to the -mm tree.  Its filename is
     vmscan-force-scan-offline-memory-cgroups-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-force-scan-offline-memory-cgroups-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-force-scan-offline-memory-cgroups-fix.patch

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
Subject: vmscan-force-scan-offline-memory-cgroups-fix

thou shalt memorize Documentation/SubmitChecklist

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~vmscan-force-scan-offline-memory-cgroups-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-force-scan-offline-memory-cgroups-fix
+++ a/include/linux/memcontrol.h
@@ -267,7 +267,7 @@ mem_cgroup_inactive_anon_is_low(struct l
 	return 1;
 }
 
-bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
+static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
 {
 	return true;
 }
diff -puN mm/memcontrol.c~vmscan-force-scan-offline-memory-cgroups-fix mm/memcontrol.c
diff -puN mm/vmscan.c~vmscan-force-scan-offline-memory-cgroups-fix mm/vmscan.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
dax-add-dax_zero_page_range-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

