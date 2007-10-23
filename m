From: akpm@linux-foundation.org
Subject: + ia64-slim-down-__clear_bit_unlock.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:33:23 -0700
Message-ID: <200710231933.l9NJXNLY002905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbXJWTd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, nickpiggin@yahoo.com.au, tony.luck@intel.com


The patch titled
     IA64: Slim down __clear_bit_unlock
has been added to the -mm tree.  Its filename is
     ia64-slim-down-__clear_bit_unlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IA64: Slim down __clear_bit_unlock
From: Christoph Lameter <clameter@sgi.com>

__clear_bit_unlock does not need to perform atomic operations on the
variable.  Avoid a cmpxchg and simply do a store with release semantics. 
Add a barrier to be safe that the compiler does not do funky things.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/bitops.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN include/asm-ia64/bitops.h~ia64-slim-down-__clear_bit_unlock include/asm-ia64/bitops.h
--- a/include/asm-ia64/bitops.h~ia64-slim-down-__clear_bit_unlock
+++ a/include/asm-ia64/bitops.h
@@ -124,10 +124,21 @@ clear_bit_unlock (int nr, volatile void 
 /**
  * __clear_bit_unlock - Non-atomically clear a bit with release
  *
- * This is like clear_bit_unlock, but the implementation may use a non-atomic
- * store (this one uses an atomic, however).
+ * This is like clear_bit_unlock, but the implementation uses a store
+ * with release semantics. See also __raw_spin_unlock().
  */
-#define __clear_bit_unlock clear_bit_unlock
+static __inline__ void
+__clear_bit_unlock (int nr, volatile void *addr)
+{
+	__u32 mask, new;
+	volatile __u32 *m;
+
+	m = (volatile __u32 *) addr + (nr >> 5);
+	mask = ~(1 << (nr & 31));
+	new = *m & mask;
+	barrier();
+	asm volatile ("st4.rel.nta [%0] = %1\n\t" :: "r"(m), "r"(new));
+}
 
 /**
  * __clear_bit - Clears a bit in memory (non-atomic version)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ia64-slim-down-__clear_bit_unlock.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
