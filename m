From: akpm@linux-foundation.org
Subject: + include-linux-aioh-cpp-c-conversions.patch added to -mm tree
Date: Thu, 28 Jun 2012 15:48:30 -0700
Message-ID: <20120628224830.A1201A01CE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:63509 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab2F1Wsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 18:48:32 -0400
Received: by yenl3 with SMTP id l3so267819yen.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 15:48:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoyer@redhat.com, junxiao.bi@oracle.com, mfasheh@suse.com


The patch titled
     Subject: include/linux/aio.h: cpp->C conversions
has been added to the -mm tree.  Its filename is
     include-linux-aioh-cpp-c-conversions.patch

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
Subject: include/linux/aio.h: cpp->C conversions

Convert init_sync_kiocb() from a nasty macro into a nice C function.  The
struct assignment trick takes care of zeroing all unmentioned fields. 
Shrinks fs/read_write.o's .text from 9857 bytes to 9714.

Also demacroize is_sync_kiocb() and aio_ring_avail().  The latter fixes an
arg-referenced-multiple-times hand grenade.

Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff -puN include/linux/aio.h~include-linux-aioh-cpp-c-conversions include/linux/aio.h
--- a/include/linux/aio.h~include-linux-aioh-cpp-c-conversions
+++ a/include/linux/aio.h
@@ -126,21 +126,20 @@ struct kiocb {
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
@@ -160,8 +159,6 @@ struct aio_ring {
 	struct io_event		io_events[0];
 }; /* 128 bytes + ring size */
 
-#define aio_ring_avail(info, ring)	(((ring)->head + (info)->nr - 1 - (ring)->tail) % (info)->nr)
-
 #define AIO_RING_PAGES	8
 struct aio_ring_info {
 	unsigned long		mmap_base;
@@ -176,6 +173,12 @@ struct aio_ring_info {
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
Subject: Subject: include/linux/aio.h: cpp->C conversions

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
tmpfs-implement-numa-node-interleaving-fix.patch
isolate_freepages-check-that-high_pfn-is-aligned-as-expected.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

