From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch removed
 from -mm tree
Date: Thu, 21 Apr 2016 13:46:09 -0700
Message-ID: <57193c11.N5+Wq7HVsfOxgqUw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcDUUqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: disband split huge pmds on race or memory failure
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: disband split huge pmds on race or memory failure

Andres L-C has pointed out that the single-page unmap_mapping_range()
fallback in truncate_inode_page() cannot protect against the case when a
huge page was faulted in after the full-range unmap_mapping_range():
because page_mapped(page) checks tail page's mapcount, not the head's.

So, there's a danger that hole-punching (and maybe even truncation) can
free pages while they are mapped into userspace with a huge pmd.  And I
don't believe that the CVE-2014-4171 protection in shmem_fault() can fully
protect from this, although it does make it much harder.

Fix that by adding a duplicate single-page unmap_mapping_range() into
shmem_disband_hugeteam() (called when punching or truncating a PageTeam),
at the point when we also hold the head's page lock (without which there
would still be races): which will then split all huge pmd mappings
covering the page into team pte mappings.

This is also just what's needed to handle memory_failure() correctly:
provide custom shmem_error_remove_page(), call shmem_disband_hugeteam()
from that before proceeding to generic_error_remove_page(), then this
additional unmap_mapping_range() will remap team by ptes as needed.

(There is an unlikely case that we're racing with another disbander, or
disband didn't get trylock on head page at first: memory_failure() has
almost finished with the page, so it's safe to unlock and relock before
retrying.)

But there is one further change needed in hwpoison_user_mappings(): it
must recognize a hugely mapped team before concluding that the page is not
mapped.  (And still no support for soft_offline(), which will have to wait
for page migration of teams.)

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++++-
 mm/shmem.c          |   30 +++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure mm/memory-failure.c
--- a/mm/memory-failure.c~huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure
+++ a/mm/memory-failure.c
@@ -45,6 +45,7 @@
 #include <linux/rmap.h>
 #include <linux/export.h>
 #include <linux/pagemap.h>
+#include <linux/pageteam.h>
 #include <linux/swap.h>
 #include <linux/backing-dev.h>
 #include <linux/migrate.h>
@@ -902,6 +903,7 @@ static int hwpoison_user_mappings(struct
 	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
+	bool mapped;
 	int ret;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
@@ -919,7 +921,10 @@ static int hwpoison_user_mappings(struct
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
-	if (!page_mapped(hpage))
+	mapped = page_mapped(hpage);
+	if (PageTeam(p) && team_pmd_mapped(team_head(p)))
+		mapped = true;
+	if (!mapped)
 		return SWAP_SUCCESS;
 
 	if (PageKsm(p)) {
diff -puN mm/shmem.c~huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure
+++ a/mm/shmem.c
@@ -605,6 +605,19 @@ static void shmem_disband_hugeteam(struc
 	}
 
 	/*
+	 * truncate_inode_page() will unmap page if page_mapped(page),
+	 * but there's a race by which the team could be hugely mapped,
+	 * with page_mapped(page) saying false.  So check here if the
+	 * head is hugely mapped, and if so unmap page to remap team.
+	 * Use a loop because there is no good locking against a
+	 * concurrent remap_team_by_ptes().
+	 */
+	while (team_pmd_mapped(head)) {
+		unmap_mapping_range(page->mapping,
+			(loff_t)page->index << PAGE_SHIFT, PAGE_SIZE, 0);
+	}
+
+	/*
 	 * Disable preemption because truncation may end up spinning until a
 	 * tail PageTeam has been cleared: we hold the lock as briefly as we
 	 * can (splitting disband in two stages), but better not be preempted.
@@ -1305,6 +1318,21 @@ static int shmem_getattr(struct vfsmount
 	return 0;
 }
 
+static int shmem_error_remove_page(struct address_space *mapping,
+				   struct page *page)
+{
+	if (PageTeam(page)) {
+		shmem_disband_hugeteam(page);
+		while (unlikely(PageTeam(page))) {
+			unlock_page(page);
+			cond_resched();
+			lock_page(page);
+			shmem_disband_hugeteam(page);
+		}
+	}
+	return generic_error_remove_page(mapping, page);
+}
+
 static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
@@ -4088,7 +4116,7 @@ static const struct address_space_operat
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_page = shmem_error_remove_page,
 };
 
 static const struct file_operations shmem_file_operations = {
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

