From: akpm@linux-foundation.org
Subject: + swap-add-per-partition-lock-for-swapfile-fix.patch added to -mm tree
Date: Tue, 22 Jan 2013 16:23:56 -0800
Message-ID: <20130123002356.775EB5A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:56928 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3AWAX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 19:23:58 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so788960vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 16:23:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dan.magenheimer@oracle.com, gregkh@linuxfoundation.org, hughd@google.com, konrad.wilk@oracle.com, minchan.kim@gmail.com, riel@redhat.com, shli@fusionio.com, shli@kernel.org, sjenning@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: swap-add-per-partition-lock-for-swapfile-fix
has been added to the -mm tree.  Its filename is
     swap-add-per-partition-lock-for-swapfile-fix.patch

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
Subject: swap-add-per-partition-lock-for-swapfile-fix

drop zcache parts, per Dan - zcache counters needn't be atomic

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zcache-main.c |    8 ++++----
 drivers/staging/zcache/zcache.c      |   15 ++-------------
 2 files changed, 6 insertions(+), 17 deletions(-)

diff -puN drivers/staging/zcache/zcache-main.c~swap-add-per-partition-lock-for-swapfile-fix drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~swap-add-per-partition-lock-for-swapfile-fix
+++ a/drivers/staging/zcache/zcache-main.c
@@ -158,8 +158,8 @@ static atomic_t zcache_pers_zpages_atomi
 static long zcache_pers_zpages_max;
 
 /* but for the rest of these, counting races are ok */
-static atomic_long_t zcache_flush_total;
-static atomic_long_t zcache_flush_found;
+static unsigned long zcache_flush_total;
+static unsigned long zcache_flush_found;
 static unsigned long zcache_flobj_total;
 static unsigned long zcache_flobj_found;
 static unsigned long zcache_failed_eph_puts;
@@ -1217,7 +1217,7 @@ int zcache_flush_page(int cli_id, int po
 	unsigned long flags;
 
 	local_irq_save(flags);
-	atomic_long_inc(&zcache_flush_total);
+	zcache_flush_total++;
 	pool = zcache_get_pool_by_id(cli_id, pool_id);
 	if (ramster_enabled)
 		ramster_do_preload_flnode(pool);
@@ -1227,7 +1227,7 @@ int zcache_flush_page(int cli_id, int po
 		zcache_put_pool(pool);
 	}
 	if (ret >= 0)
-		atomic_long_inc(&zcache_flush_found);
+		zcache_flush_found++;
 	local_irq_restore(flags);
 	return ret;
 }
diff -puN drivers/staging/zcache/zcache.c~swap-add-per-partition-lock-for-swapfile-fix drivers/staging/zcache/zcache.c
--- a/drivers/staging/zcache/zcache.c~swap-add-per-partition-lock-for-swapfile-fix
+++ a/drivers/staging/zcache/zcache.c
@@ -1089,17 +1089,6 @@ static struct notifier_block zcache_cpu_
 		.show = zcache_##_name##_show, \
 	}
 
-#define ZCACHE_SYSFS_RO_ATOMIC_LONG(_name) \
-	static ssize_t zcache_##_name##_show(struct kobject *kobj, \
-				struct kobj_attribute *attr, char *buf) \
-	{ \
-	    return sprintf(buf, "%lu\n", atomic_long_read(&zcache_##_name)); \
-	} \
-	static struct kobj_attribute zcache_##_name##_attr = { \
-		.attr = { .name = __stringify(_name), .mode = 0444 }, \
-		.show = zcache_##_name##_show, \
-	}
-
 #define ZCACHE_SYSFS_RO_CUSTOM(_name, _func) \
 	static ssize_t zcache_##_name##_show(struct kobject *kobj, \
 				struct kobj_attribute *attr, char *buf) \
@@ -1113,8 +1102,8 @@ static struct notifier_block zcache_cpu_
 
 ZCACHE_SYSFS_RO(curr_obj_count_max);
 ZCACHE_SYSFS_RO(curr_objnode_count_max);
-ZCACHE_SYSFS_RO_ATOMIC_LONG(flush_total);
-ZCACHE_SYSFS_RO_ATOMIC_LONG(flush_found);
+ZCACHE_SYSFS_RO(flush_total);
+ZCACHE_SYSFS_RO(flush_found);
 ZCACHE_SYSFS_RO(flobj_total);
 ZCACHE_SYSFS_RO(flobj_found);
 ZCACHE_SYSFS_RO(failed_eph_puts);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-dont-inline-page_mapping.patch
swap-add-per-partition-lock-for-swapfile-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

