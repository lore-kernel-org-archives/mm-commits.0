From: akpm@linux-foundation.org
Subject: [merged] include-linux-aioh-cpp-c-conversions.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:31 -0700
Message-ID: <20120731185432.2323C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53898 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2GaSye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:34 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so295563lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, jmoyer@redhat.com, junxiao.bi@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/aio.h: cpp->C conversions
has been removed from the -mm tree.  Its filename was
     include-linux-aioh-cpp-c-conversions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/aio.h: cpp->C conversions

Convert init_sync_kiocb() from a nasty macro into a nice C function.  The
struct assignment trick takes care of zeroing all unmentioned fields. 
Shrinks fs/read_write.o's .text from 9857 bytes to 9714.

Also demacroize is_sync_kiocb() and aio_ring_avail().  The latter fixes an
arg-referenced-multiple-times hand grenade.

Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN include/linux/aio.h~include-linux-aioh-cpp-c-conversions include/linux/aio.h
--- a/include/linux/aio.h~include-linux-aioh-cpp-c-conversions
+++ a/include/linux/aio.h
@@ -126,22 +126,20 @@ struct kiocb {
 	struct eventfd_ctx	*ki_eventfd;
 };
 
-#define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
-#define init_sync_kiocb(x, filp)			\
-	do {						\
-		struct task_struct *tsk = current;	\
-		(x)->ki_flags = 0;			\
-		(x)->ki_users = 1;			\
-		(x)->ki_key = KIOCB_SYNC_KEY;		\
-		(x)->ki_filp = (filp);			\
-		(x)->ki_ctx = NULL;			\
-		(x)->ki_cancel = NULL;			\
-		(x)->ki_retry = NULL;			\
-		(x)->ki_dtor = NULL;			\
-		(x)->ki_obj.tsk = tsk;			\
-		(x)->ki_user_data = 0;                  \
-		(x)->private = NULL;			\
-	} while (0)
+static inline bool is_sync_kiocb(struct kiocb *kiocb)
+{
+	return kiocb->ki_key == KIOCB_SYNC_KEY;
+}
+
+static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
+{
+	*kiocb = (struct kiocb) {
+			.ki_users = 1,
+			.ki_key = KIOCB_SYNC_KEY,
+			.ki_filp = filp,
+			.ki_obj.tsk = current,
+		};
+}
 
 #define AIO_RING_MAGIC			0xa10a10a1
 #define AIO_RING_COMPAT_FEATURES	1
@@ -161,8 +159,6 @@ struct aio_ring {
 	struct io_event		io_events[0];
 }; /* 128 bytes + ring size */
 
-#define aio_ring_avail(info, ring)	(((ring)->head + (info)->nr - 1 - (ring)->tail) % (info)->nr)
-
 #define AIO_RING_PAGES	8
 struct aio_ring_info {
 	unsigned long		mmap_base;
@@ -177,6 +173,12 @@ struct aio_ring_info {
 	struct page		*internal_pages[AIO_RING_PAGES];
 };
 
+static inline unsigned aio_ring_avail(struct aio_ring_info *info,
+					struct aio_ring *ring)
+{
+	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
+}
+
 struct kioctx {
 	atomic_t		users;
 	int			dead;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

