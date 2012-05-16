From: akpm@linux-foundation.org
Subject: + ipc-mqueue-add-rbtree-node-caching-support-fix.patch added to -mm tree
Date: Wed, 16 May 2012 15:12:57 -0700
Message-ID: <20120516221257.CCA91A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:48403 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759542Ab2EPWM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 18:12:58 -0400
Received: by qabg24 with SMTP id g24so174788qab.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 15:12:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dledford@redhat.com, fweisbec@gmail.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au


The patch titled
     Subject: ipc-mqueue-add-rbtree-node-caching-support-fix
has been added to the -mm tree.  Its filename is
     ipc-mqueue-add-rbtree-node-caching-support-fix.patch

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
Subject: ipc-mqueue-add-rbtree-node-caching-support-fix

coding-style fixes

Cc: Doug Ledford <dledford@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support-fix
+++ a/ipc/mqueue.c
@@ -141,16 +141,18 @@ static int msg_insert(struct msg_msg *ms
 	} else if (new_leaf) {
 		leaf = *new_leaf;
 		*new_leaf = NULL;
-	} else
+	} else {
 		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
+	}
 	if (!leaf)
 		return -ENOMEM;
 	if (!info->node_cache) {
 		rb_init_node(&leaf->rb_node);
 		INIT_LIST_HEAD(&leaf->msg_list);
 		info->qsize += sizeof(*leaf);
-	} else
+	} else {
 		info->node_cache = NULL;
+	}
 	leaf->priority = msg->m_type;
 	rb_link_node(&leaf->rb_node, parent, p);
 	rb_insert_color(&leaf->rb_node, &info->msg_tree);
@@ -196,8 +198,9 @@ try_again:
 		if (info->node_cache) {
 			info->qsize -= sizeof(*leaf);
 			kfree(leaf);
-		} else
+		} else {
 			info->node_cache = leaf;
+		}
 		goto try_again;
 	} else {
 		msg = list_first_entry(&leaf->msg_list,
@@ -208,8 +211,9 @@ try_again:
 			if (info->node_cache) {
 				info->qsize -= sizeof(*leaf);
 				kfree(leaf);
-			} else
+			} else {
 				info->node_cache = leaf;
+			}
 		}
 	}
 	info->attr.mq_curmsgs--;
@@ -1033,9 +1037,11 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	msg_ptr->m_ts = msg_len;
 	msg_ptr->m_type = msg_prio;
 
-	/* msg_insert really wants us to have a valid, spare node struct so
-	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
-	 * fall back to that if necessary. */
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so it
+	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
+	 * back to that if necessary.
+	 */
 	if (!info->node_cache)
 		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
 
@@ -1058,8 +1064,10 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 			wait.msg = (void *) msg_ptr;
 			wait.state = STATE_NONE;
 			ret = wq_sleep(info, SEND, timeout, &wait);
-			/* wq_sleep must be called with info->lock held, and
-			 * returns with the lock released */
+			/*
+			 * wq_sleep must be called with info->lock held, and
+			 * returns with the lock released
+			 */
 			goto out_free;
 		}
 	} else {
@@ -1136,9 +1144,11 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		goto out_fput;
 	}
 
-	/* msg_insert really wants us to have a valid, spare node struct so
-	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
-	 * fall back to that if necessary. */
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so it
+	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
+	 * back to that if necessary.
+	 */
 	if (!info->node_cache)
 		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
 
_
Subject: Subject: ipc-mqueue-add-rbtree-node-caching-support-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation-fix.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-page_allocc-cleanups.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-fix.patch
ipc-mqueue-add-rbtree-node-caching-support-fix-fix.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

