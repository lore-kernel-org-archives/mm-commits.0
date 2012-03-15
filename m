From: akpm@linux-foundation.org
Subject: + radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch added to -mm tree
Date: Wed, 14 Mar 2012 17:44:32 -0700
Message-ID: <20120315004433.1E34CA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:40380 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349Ab2COAoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 20:44:34 -0400
Received: by ghbz15 with SMTP id z15so404970ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 17:44:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, khlebnikov@openvz.org


The patch titled
     Subject: radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch

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
Subject: radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes

ERROR: space prohibited after that open parenthesis '('
#172: FILE: include/linux/radix-tree.h:341:
+	for ( slot = radix_tree_iter_init(iter, start) ;		\

ERROR: space prohibited before that close parenthesis ')'
#173: FILE: include/linux/radix-tree.h:342:
+	      (slot = radix_tree_next_chunk(root, iter, flags)) ; )

ERROR: space prohibited before that close parenthesis ')'
#183: FILE: include/linux/radix-tree.h:352:
+	for ( ; slot ; slot = radix_tree_next_slot(slot, iter, flags) )

ERROR: space prohibited after that open parenthesis '('
#194: FILE: include/linux/radix-tree.h:363:
+	for ( slot = radix_tree_iter_init(iter, start) ;	\

ERROR: space prohibited before that close parenthesis ')'
#196: FILE: include/linux/radix-tree.h:365:
+	      slot = radix_tree_next_slot(slot, iter, 0) )

ERROR: space prohibited after that open parenthesis '('
#207: FILE: include/linux/radix-tree.h:376:
+	for ( slot = radix_tree_iter_init(iter, start) ;		\

ERROR: space prohibited before that close parenthesis ')'
#211: FILE: include/linux/radix-tree.h:380:
+				RADIX_TREE_ITER_CONTIG) )

ERROR: space prohibited after that open parenthesis '('
#223: FILE: include/linux/radix-tree.h:392:
+	for ( slot = radix_tree_iter_init(iter, start) ;		\

ERROR: space prohibited before that close parenthesis ')'
#227: FILE: include/linux/radix-tree.h:396:
+				RADIX_TREE_ITER_TAGGED) )

ERROR: trailing statements should be on next line
#349: FILE: lib/radix-tree.c:713:
+				while (++i < RADIX_TREE_MAP_SIZE &&
+						!node->slots[i]);

total: 10 errors, 0 warnings, 314 lines checked

./patches/radix-tree-introduce-bit-optimized-iterator.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes
+++ a/include/linux/radix-tree.h
@@ -271,8 +271,8 @@ struct radix_tree_iter {
 void **radix_tree_next_chunk(struct radix_tree_root *root,
 			     struct radix_tree_iter *iter, unsigned flags);
 
-static inline
-void **radix_tree_iter_init(struct radix_tree_iter *iter, unsigned long start)
+static inline void **
+radix_tree_iter_init(struct radix_tree_iter *iter, unsigned long start)
 {
 	iter->index = 0; /* to bypass next_index overflow protection */
 	iter->next_index = start;
@@ -293,9 +293,8 @@ static inline unsigned long radix_tree_c
  *
  * Returns pointer to next slot, or NULL if no more left.
  */
-static __always_inline
-void **radix_tree_next_slot(void **slot, struct radix_tree_iter *iter,
-			    unsigned flags)
+static __always_inline void **
+radix_tree_next_slot(void **slot, struct radix_tree_iter *iter, unsigned flags)
 {
 	unsigned size, offset;
 
@@ -339,8 +338,8 @@ void **radix_tree_next_slot(void **slot,
  * Locks can be released and reasquired between iterations.
  */
 #define radix_tree_for_each_chunk(slot, root, iter, start, flags)	\
-	for ( slot = radix_tree_iter_init(iter, start) ;		\
-	      (slot = radix_tree_next_chunk(root, iter, flags)) ; )
+	for (slot = radix_tree_iter_init(iter, start);			\
+	      (slot = radix_tree_next_chunk(root, iter, flags)); )
 
 /**
  * radix_tree_for_each_chunk_slot - iterate over slots in one chunk
@@ -350,7 +349,7 @@ void **radix_tree_next_slot(void **slot,
  * @flags	RADIX_TREE_ITER_*
  */
 #define radix_tree_for_each_chunk_slot(slot, iter, flags)	\
-	for ( ; slot ; slot = radix_tree_next_slot(slot, iter, flags) )
+	for ( ; slot; slot = radix_tree_next_slot(slot, iter, flags))
 
 /**
  * radix_tree_for_each_slot - iterate over all slots
@@ -360,10 +359,10 @@ void **radix_tree_next_slot(void **slot,
  * @iter	the struct radix_tree_iter pointer
  * @start	starting index
  */
-#define radix_tree_for_each_slot(slot, root, iter, start)	\
-	for ( slot = radix_tree_iter_init(iter, start) ;	\
-	      slot || (slot = radix_tree_next_chunk(root, iter, 0)) ; \
-	      slot = radix_tree_next_slot(slot, iter, 0) )
+#define radix_tree_for_each_slot(slot, root, iter, start)		\
+	for (slot = radix_tree_iter_init(iter, start);			\
+	      slot || (slot = radix_tree_next_chunk(root, iter, 0));	\
+	      slot = radix_tree_next_slot(slot, iter, 0))
 
 /**
  * radix_tree_for_each_contig - iterate over all contiguous slots
@@ -374,11 +373,11 @@ void **radix_tree_next_slot(void **slot,
  * @start	starting index
  */
 #define radix_tree_for_each_contig(slot, root, iter, start)		\
-	for ( slot = radix_tree_iter_init(iter, start) ;		\
+	for (slot = radix_tree_iter_init(iter, start);			\
 	      slot || (slot = radix_tree_next_chunk(root, iter,		\
-				RADIX_TREE_ITER_CONTIG)) ;		\
+				RADIX_TREE_ITER_CONTIG));		\
 	      slot = radix_tree_next_slot(slot, iter,			\
-				RADIX_TREE_ITER_CONTIG) )
+				RADIX_TREE_ITER_CONTIG))
 
 /**
  * radix_tree_for_each_tagged - iterate over all tagged slots
@@ -390,10 +389,10 @@ void **radix_tree_next_slot(void **slot,
  * @tag		tag index
  */
 #define radix_tree_for_each_tagged(slot, root, iter, start, tag)	\
-	for ( slot = radix_tree_iter_init(iter, start) ;		\
+	for (slot = radix_tree_iter_init(iter, start);			\
 	      slot || (slot = radix_tree_next_chunk(root, iter,		\
-			      RADIX_TREE_ITER_TAGGED | tag)) ;		\
+			      RADIX_TREE_ITER_TAGGED | tag));		\
 	      slot = radix_tree_next_slot(slot, iter,			\
-				RADIX_TREE_ITER_TAGGED) )
+				RADIX_TREE_ITER_TAGGED))
 
 #endif /* _LINUX_RADIX_TREE_H */
_
Subject: Subject: radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

