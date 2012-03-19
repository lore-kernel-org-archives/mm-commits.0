From: akpm@linux-foundation.org
Subject: + radix-tree-introduce-bit-optimized-iterator-v3-fix.patch added to -mm tree
Date: Mon, 19 Mar 2012 16:42:34 -0700
Message-ID: <20120319234234.CC4D3A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41520 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab2CSXmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 19:42:37 -0400
Received: by wibhj13 with SMTP id hj13so182733wib.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 16:42:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, hughd@google.com, khlebnikov@openvz.org, torvalds@linux-foundation.org


The patch titled
     Subject: radix-tree-introduce-bit-optimized-iterator-v3-fix
has been added to the -mm tree.  Its filename is
     radix-tree-introduce-bit-optimized-iterator-v3-fix.patch

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
Subject: radix-tree-introduce-bit-optimized-iterator-v3-fix

rework comments a bit

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   31 ++++++++++++++++---------------
 lib/radix-tree.c           |    4 ++--
 2 files changed, 18 insertions(+), 17 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-introduce-bit-optimized-iterator-v3-fix include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-introduce-bit-optimized-iterator-v3-fix
+++ a/include/linux/radix-tree.h
@@ -265,11 +265,12 @@ static inline void radix_tree_preload_en
  * @next_index:	next-to-last index for this chunk
  * @tags:	bit-mask for tag-iterating
  *
- * Radix tree iterator works in terms of "chunks" of slots.
- * Chunk is sub-interval of slots contained in one radix tree leaf node.
- * It described by pointer to its first slot and struct radix_tree_iter
- * which holds chunk position in tree and its size. For tagged iterating
- * radix_tree_iter also holds slots' bit-mask for one chosen radix tree tag.
+ * This radix tree iterator works in terms of "chunks" of slots.  A chunk is a
+ * subinterval of slots contained within one radix tree leaf node.  It is
+ * described by a pointer to its first slot and a struct radix_tree_iter
+ * which holds the chunk's position in the tree and its size.  For tagged
+ * iteration radix_tree_iter also holds the slots' bit-mask for one chosen
+ * radix tree tag.
  */
 struct radix_tree_iter {
 	unsigned long	index;
@@ -292,12 +293,12 @@ static __always_inline void **
 radix_tree_iter_init(struct radix_tree_iter *iter, unsigned long start)
 {
 	/*
-	 * Leave iter->tags unitialized. radix_tree_next_chunk()
-	 * anyway fill it in case successful tagged chunk lookup.
-	 * At unsuccessful or non-tagged lookup nobody cares about it.
+	 * Leave iter->tags uninitialized. radix_tree_next_chunk() will fill it
+	 * in the case of a successful tagged chunk lookup.  If the lookup was
+	 * unsuccessful or non-tagged then nobody cares about ->tags.
 	 *
 	 * Set index to zero to bypass next_index overflow protection.
-	 * See comment inside radix_tree_next_chunk() for details.
+	 * See the comment in radix_tree_next_chunk() for details.
 	 */
 	iter->index = 0;
 	iter->next_index = start;
@@ -312,10 +313,10 @@ radix_tree_iter_init(struct radix_tree_i
  * @flags:	RADIX_TREE_ITER_* flags and tag index
  * Returns:	pointer to chunk first slot, or NULL if there no more left
  *
- * This function lookup next chunk in the radix tree starting from
- * @iter->next_index, it returns pointer to chunk first slot.
+ * This function looks up the next chunk in the radix tree starting from
+ * @iter->next_index.  It returns a pointer to the chunk's first slot.
  * Also it fills @iter with data about chunk: position in the tree (index),
- * its end (next_index), and construct bit mask for tagged iterating (tags).
+ * its end (next_index), and constructs a bit mask for tagged iterating (tags).
  */
 void **radix_tree_next_chunk(struct radix_tree_root *root,
 			     struct radix_tree_iter *iter, unsigned flags);
@@ -340,7 +341,7 @@ radix_tree_chunk_size(struct radix_tree_
  * @flags:	RADIX_TREE_ITER_*, should be constant
  * Returns:	pointer to next slot, or NULL if there no more left
  *
- * This function updates @iter->index in case successful lookup.
+ * This function updates @iter->index in the case of a successful lookup.
  * For tagged lookup it also eats @iter->tags.
  */
 static __always_inline void **
@@ -396,8 +397,8 @@ radix_tree_next_slot(void **slot, struct
  * @iter:	the struct radix_tree_iter pointer
  * @flags:	RADIX_TREE_ITER_*, should be constant
  *
- * This macro supposed to be nested inside radix_tree_for_each_chunk().
- * @slot points to radix tree slot, @iter->index contains its index.
+ * This macro is designed to be nested inside radix_tree_for_each_chunk().
+ * @slot points to the radix tree slot, @iter->index contains its index.
  */
 #define radix_tree_for_each_chunk_slot(slot, iter, flags)		\
 	for (; slot ; slot = radix_tree_next_slot(slot, iter, flags))
diff -puN lib/radix-tree.c~radix-tree-introduce-bit-optimized-iterator-v3-fix lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-introduce-bit-optimized-iterator-v3-fix
+++ a/lib/radix-tree.c
@@ -670,8 +670,8 @@ void **radix_tree_next_chunk(struct radi
 
 	/*
 	 * Catch next_index overflow after ~0UL. iter->index never overflows
-	 * during iterating, it can be zero only at the beginning.
-	 * And we cannot overflow iter->next_index in single step,
+	 * during iterating; it can be zero only at the beginning.
+	 * And we cannot overflow iter->next_index in a single step,
 	 * because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG.
 	 */
 	index = iter->next_index;
_
Subject: Subject: radix-tree-introduce-bit-optimized-iterator-v3-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
drivers-platform-x86-samsung-laptopc-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
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
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
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
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

