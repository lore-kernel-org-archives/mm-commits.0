From: akpm@linux-foundation.org
Subject: + mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch added to -mm tree
Date: Tue, 02 Feb 2016 16:35:56 -0800
Message-ID: <56b14b6c.kRWFiaHio1ToA2ds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbcBCAf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 19:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch

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
Subject: mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix

hrm

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix
+++ a/mm/migrate.c
@@ -1845,7 +1845,7 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	mem_cgroup_migrate(page, newpage);
+	mem_cgroup_migrate(page, new_page);
 	page_remove_rmap(page, true);
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch
mm.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mmfsdax-change-pmd_fault-to-huge_fault-fix.patch
mm-add-support-for-pud-sized-transparent-hugepages-fix.patch
mm-add-support-for-pud-sized-transparent-hugepages-fix-2.patch
x86-add-support-for-pud-sized-transparent-hugepages-fix.patch
x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

