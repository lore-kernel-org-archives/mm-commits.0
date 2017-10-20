From: akpm@linux-foundation.org
Subject: + mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
 added to -mm tree
Date: Thu, 19 Oct 2017 17:00:25 -0700
Message-ID: <59e93c99.ImuhzhgzyxEAs4bg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdJTAA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 20:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix
has been added to the -mm tree.  Its filename is
     mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch

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
Subject: mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix

make vmemmap_alloc_block_zero() private to sparse-vmemmap.c

Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   11 -----------
 mm/sparse-vmemmap.c |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix
+++ a/include/linux/mm.h
@@ -2529,17 +2529,6 @@ static inline void *vmemmap_alloc_block_
 	return __vmemmap_alloc_block_buf(size, node, NULL);
 }
 
-static inline void *vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
 			       int node);
diff -puN mm/sparse-vmemmap.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix
+++ a/mm/sparse-vmemmap.c
@@ -178,6 +178,17 @@ pte_t * __meminit vmemmap_pte_populate(p
 	return pte;
 }
 
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
 pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-deferred_init_memmap-improvements-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

