From: akpm@linux-foundation.org
Subject: + list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes.patch added to -mm tree
Date: Mon, 13 Sep 2010 16:14:28 -0700
Message-ID: <201009132314.o8DNESIB026874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0IMXO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 19:14:29 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o8DNET4x026426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 13 Sep 2010 16:14:29 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#139: FILE: include/linux/list.h:419:
+^I     list_prefetch(pos->member.next), &pos->member != (head); ^I\$

WARNING: please, no space before tabs
#148: FILE: include/linux/list.h:430:
+^I     list_prefetch(pos->member.prev), &pos->member != (head); ^I\$

WARNING: line over 80 characters
#193: FILE: include/linux/list.h:672:
+	     pos && ({ list_prefetch(pos->next); 1;}) &&			 \

ERROR: space required after that ';' (ctx:VxV)
#193: FILE: include/linux/list.h:672:
+	     pos && ({ list_prefetch(pos->next); 1;}) &&			 \
 	                                          ^

ERROR: space required after that ';' (ctx:VxV)
#202: FILE: include/linux/list.h:684:
+	     pos && ({ list_prefetch(pos->next); 1;}) &&		 \
 	                                          ^

ERROR: space required after that ';' (ctx:VxV)
#211: FILE: include/linux/list.h:695:
+	for (; pos && ({ list_prefetch(pos->next); 1;}) &&		 \
 	                                            ^

WARNING: line over 80 characters
#328: FILE: include/linux/skbuff.h:1774:
+		for (; list_prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\

WARNING: line over 80 characters
#337: FILE: include/linux/skbuff.h:1784:
+		     list_prefetch(skb->prev), (skb != (struct sk_buff *)(queue));	\

total: 3 errors, 5 warnings, 242 lines checked

./patches/list-remove-explicit-list-prefetches-for-most-cases.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/list.h~list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes include/linux/list.h
--- a/include/linux/list.h~list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes
+++ a/include/linux/list.h
@@ -416,7 +416,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     list_prefetch(pos->member.next), &pos->member != (head); 	\
+	     list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -427,7 +427,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     list_prefetch(pos->member.prev), &pos->member != (head); 	\
+	     list_prefetch(pos->member.prev), &pos->member != (head);	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
@@ -667,10 +667,10 @@ static inline void hlist_move_list(struc
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry(tpos, pos, head, member)			 \
-	for (pos = (head)->first;					 \
-	     pos && ({ list_prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+#define hlist_for_each_entry(tpos, pos, head, member)			\
+	for (pos = (head)->first;					\
+	     pos && ({ list_prefetch(pos->next); 1;}) &&		\
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;});\
 	     pos = pos->next)
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc_test-move-files-from-sysfs-to-debugfs-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

