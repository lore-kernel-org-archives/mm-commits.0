From: akpm@linux-foundation.org
Subject: [folded] radix-tree-introduce-bit-optimized-iterator-v3-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:33:28 -0700
Message-ID: <20120328213328.B7CCAA0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:60143 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab2C1Vd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:33:29 -0400
Received: by yhgm50 with SMTP id m50so192637yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:33:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, hughd@google.com, khlebnikov@openvz.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree-introduce-bit-optimized-iterator-v3-fix
has been removed from the -mm tree.  Its filename was
     radix-tree-introduce-bit-optimized-iterator-v3-fix.patch

This patch was dropped because it was folded into radix-tree-introduce-bit-optimized-iterator.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

