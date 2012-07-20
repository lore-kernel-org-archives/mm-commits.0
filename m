From: akpm@linux-foundation.org
Subject: + fs-gfs2-filec-fix-32-bit-build.patch added to -mm tree
Date: Fri, 20 Jul 2012 15:09:55 -0700
Message-ID: <20120720225642.635BA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61760 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTW4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jul 2012 18:56:44 -0400
Received: by ggeh3 with SMTP id h3so505376gge.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jul 2012 15:56:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, swhiteho@redhat.com


The patch titled
     Subject: fs/gfs2/file.c: fix 32-bit build
has been added to the -mm tree.  Its filename is
     fs-gfs2-filec-fix-32-bit-build.patch

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
Subject: fs/gfs2/file.c: fix 32-bit build

Avoid emitting a reference to the non-existent __divdi3()

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/gfs2/file.c~fs-gfs2-filec-fix-32-bit-build fs/gfs2/file.c
--- a/fs/gfs2/file.c~fs-gfs2-filec-fix-32-bit-build
+++ a/fs/gfs2/file.c
@@ -770,6 +770,8 @@ static long gfs2_fallocate(struct file *
 	loff_t bsize_mask = ~((loff_t)sdp->sd_sb.sb_bsize - 1);
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	loff_t max_chunk_size = UINT_MAX & bsize_mask;
+	u32 rs_sizehint;
+
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
 	/* We only support the FALLOC_FL_KEEP_SIZE mode */
@@ -795,7 +797,9 @@ static long gfs2_fallocate(struct file *
 	if (unlikely(error))
 		goto out_uninit;
 
-	atomic_set(&ip->i_res->rs_sizehint, len / sdp->sd_sb.sb_bsize);
+	rs_sizehint = len;
+	do_div(rs_sizehint, sdp->sd_sb.sb_bsize);
+	atomic_set(&ip->i_res->rs_sizehint, rs_sizehint);
 
 	while (len > 0) {
 		if (len < bytes)
_
Subject: Subject: fs/gfs2/file.c: fix 32-bit build

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-ddc-debork.patch
fs-gfs2-filec-fix-32-bit-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

