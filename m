From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch added to -mm tree
Date: Wed, 20 Jun 2012 14:07:57 -0700
Message-ID: <20120620210758.0FC40A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:64587 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2FTVH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 17:07:59 -0400
Received: by yenl3 with SMTP id l3so776359yen.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 14:07:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, qiuxishi@huawei.com, rientjes@google.com


The patch titled
     Subject: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch

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
Subject: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix

add pglist_data.kswapd locking comments

Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
+++ a/include/linux/mmzone.h
@@ -693,7 +693,7 @@ typedef struct pglist_data {
 					     range, including holes */
 	int node_id;
 	wait_queue_head_t kswapd_wait;
-	struct task_struct *kswapd;
+	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 } pg_data_t;
diff -puN mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix mm/vmscan.c
--- a/mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
+++ a/mm/vmscan.c
@@ -2955,7 +2955,8 @@ int kswapd_run(int nid)
 }
 
 /*
- * Called by memory hotplug when all memory in a node is offlined.
+ * Called by memory hotplug when all memory in a node is offlined.  Caller must
+ * hold lock_memory_hotplug().
  */
 void kswapd_stop(int nid)
 {
_
Subject: Subject: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

