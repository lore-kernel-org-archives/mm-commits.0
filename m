From: akpm@linux-foundation.org
Subject: + mm-remove-shmem_mapping-shmem_zero_setup-duplicates.patch added to -mm tree
Date: Wed, 08 Feb 2017 17:22:07 -0800
Message-ID: <589bc43f.ogYP/5l3YzGC65Rg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdBIBbC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 20:31:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, monstr@monstr.eu, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove shmem_mapping() shmem_zero_setup() duplicates
has been added to the -mm tree.  Its filename is
     mm-remove-shmem_mapping-shmem_zero_setup-duplicates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-shmem_mapping-shmem_zero_setup-duplicates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-shmem_mapping-shmem_zero_setup-duplicates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove shmem_mapping() shmem_zero_setup() duplicates

Remove the prototypes for shmem_mapping() and shmem_zero_setup() from
linux/mm.h, since they are already provided in linux/shmem_fs.h.  But
shmem_fs.h must then provide the inline stub for shmem_mapping() when
CONFIG_SHMEM is not set, and a few more cfiles now need to #include it.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1702081658250.1549@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/pci/pci-common.c |    1 +
 arch/powerpc/kernel/pci-common.c |    1 +
 include/linux/mm.h               |   10 ----------
 include/linux/shmem_fs.h         |    7 +++++++
 mm/madvise.c                     |    1 +
 mm/memcontrol.c                  |    1 +
 mm/mincore.c                     |    1 +
 mm/truncate.c                    |    1 +
 mm/workingset.c                  |    1 +
 9 files changed, 14 insertions(+), 10 deletions(-)

diff -puN arch/microblaze/pci/pci-common.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates arch/microblaze/pci/pci-common.c
--- a/arch/microblaze/pci/pci-common.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/arch/microblaze/pci/pci-common.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
+#include <linux/shmem_fs.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
 #include <linux/irq.h>
diff -puN arch/powerpc/kernel/pci-common.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates arch/powerpc/kernel/pci-common.c
--- a/arch/powerpc/kernel/pci-common.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/arch/powerpc/kernel/pci-common.c
@@ -25,6 +25,7 @@
 #include <linux/of_address.h>
 #include <linux/of_pci.h>
 #include <linux/mm.h>
+#include <linux/shmem_fs.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
 #include <linux/irq.h>
diff -puN include/linux/mm.h~mm-remove-shmem_mapping-shmem_zero_setup-duplicates include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/include/linux/mm.h
@@ -1164,16 +1164,6 @@ extern void pagefault_out_of_memory(void
 
 extern void show_free_areas(unsigned int flags, nodemask_t *nodemask);
 
-int shmem_zero_setup(struct vm_area_struct *);
-#ifdef CONFIG_SHMEM
-bool shmem_mapping(struct address_space *mapping);
-#else
-static inline bool shmem_mapping(struct address_space *mapping)
-{
-	return false;
-}
-#endif
-
 extern bool can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
diff -puN include/linux/shmem_fs.h~mm-remove-shmem_mapping-shmem_zero_setup-duplicates include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/include/linux/shmem_fs.h
@@ -57,7 +57,14 @@ extern int shmem_zero_setup(struct vm_ar
 extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+#ifdef CONFIG_SHMEM
 extern bool shmem_mapping(struct address_space *mapping);
+#else
+static inline bool shmem_mapping(struct address_space *mapping)
+{
+	return false;
+}
+#endif /* CONFIG_SHMEM */
 extern void shmem_unlock_mapping(struct address_space *mapping);
 extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
diff -puN mm/madvise.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates mm/madvise.c
--- a/mm/madvise.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/mm/madvise.c
@@ -21,6 +21,7 @@
 #include <linux/backing-dev.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
 
 #include <asm/tlb.h>
diff -puN mm/memcontrol.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/mm/memcontrol.c
@@ -35,6 +35,7 @@
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
 #include <linux/mm.h>
+#include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
 #include <linux/smp.h>
diff -puN mm/mincore.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates mm/mincore.c
--- a/mm/mincore.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/mm/mincore.c
@@ -14,6 +14,7 @@
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 
 #include <linux/uaccess.h>
diff -puN mm/truncate.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates mm/truncate.c
--- a/mm/truncate.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/mm/truncate.c
@@ -20,6 +20,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
 				   do_invalidatepage */
+#include <linux/shmem_fs.h>
 #include <linux/cleancache.h>
 #include <linux/rmap.h>
 #include "internal.h"
diff -puN mm/workingset.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates mm/workingset.c
--- a/mm/workingset.c~mm-remove-shmem_mapping-shmem_zero_setup-duplicates
+++ a/mm/workingset.c
@@ -6,6 +6,7 @@
 
 #include <linux/memcontrol.h>
 #include <linux/writeback.h>
+#include <linux/shmem_fs.h>
 #include <linux/pagemap.h>
 #include <linux/atomic.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-change-shmem_mapping-to-test-shmem_aops.patch
mm-remove-shmem_mapping-shmem_zero_setup-duplicates.patch

