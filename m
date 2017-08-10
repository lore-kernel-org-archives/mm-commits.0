From: akpm@linux-foundation.org
Subject: + bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch added
 to -mm tree
Date: Thu, 10 Aug 2017 13:53:21 -0700
Message-ID: <598cc7c1.Hd0TTQ+5O7UKnuFY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40114 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752800AbdHJUxW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 16:53:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch

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
Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes

tweak code comment

Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes
+++ a/include/linux/bitmap.h
@@ -363,27 +363,27 @@ static inline int bitmap_parse(const cha
 /*
  * BITMAP_FROM_U64() - Represent u64 value in the format suitable for bitmap.
  *
- * Linux bitmaps are internally the arrays on unsigned longs, i.e. 32-bit
+ * Linux bitmaps are internally arrays of unsigned longs, i.e. 32-bit
  * integers in 32-bit environment, and 64-bit integers in 64-bit one.
  *
- * There are four combinations of endianess and length of the word in linux ABIs:
- * LE64, BE64, LE32 and BE32.
+ * There are four combinations of endianess and length of the word in linux
+ * ABIs: LE64, BE64, LE32 and BE32.
  *
  * On 64-bit kernels 64-bit LE and BE numbers are naturally ordered in
  * bitmaps and therefore don't require any special handling.
  *
- * On 32-bit kernels 32-bit LE ABI orders lo word of 64-bit number in the memory
- * prior to hi, and 32-bit BE orders hi word prior to lo. The bitmap in other
- * hand is represented as the array of 32-bit words, and the position of the
+ * On 32-bit kernels 32-bit LE ABI orders lo word of 64-bit number in memory
+ * prior to hi, and 32-bit BE orders hi word prior to lo. The bitmap on the
+ * other hand is represented as an array of 32-bit words and the position of
  * bit N may therefore be calculated as: word #(N/32) and bit #(N%32) in that
- * word. For example, bit #42 is located at 10th position of 2nd word.
+ * word.  For example, bit #42 is located at 10th position of 2nd word.
  * It matches 32-bit LE ABI, and we can simply let the compiler store 64-bit
- * value on the memory as it usually does. But for BE we therefore need to swap
- * hi and lo words manually.
+ * values in memory as it usually does. But for BE we need to swap hi and lo
+ * words manually.
  *
- * With all that, the macro BITMAP_FROM_U64() does explicit reorder of hi and lo
- * parts of u64. For LE32 it does nothing in fact, and for BE environment it
- * swaps hi and lo words, as it expected by bitmap.
+ * With all that, the macro BITMAP_FROM_U64() does explicit reordering of hi and
+ * lo parts of u64.  For LE32 it does nothing, and for BE environment it swaps
+ * hi and lo words, as is expected by bitmap.
  */
 #if __BITS_PER_LONG == 64
 #define BITMAP_FROM_U64(n) (n)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

