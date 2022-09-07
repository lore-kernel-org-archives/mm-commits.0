Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D0EC54EE9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIGWUA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIGWT7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFDC21E3A
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B0061A74
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A50C433C1;
        Wed,  7 Sep 2022 22:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662589195;
        bh=E1xMQgSslHcdFipvaWA3CU2q4LCyo1uQSzmZpsJi5mw=;
        h=Date:To:From:Subject:From;
        b=IgpKMaWq92wgi2AqnZtIExZC6kv+QU3JZ+x01BXyT1sApNi8WTZDvYN9sVoNLpap6
         1sYBj0LFQo0V2ublTulmsAGfJeCGiFmPp/ceZK7dUWzUMiXSOMaOwhhQ+bLoOpNwiL
         MmFr6T8qWcrtR0ihs3j+eKsgWdA3pscbtQ8zs65A=
Date:   Wed, 07 Sep 2022 15:19:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch added to mm-unstable branch
Message-Id: <20220907221955.13A50C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: add flag to enforce shmem THP in hugepage_vma_check()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/shmem: add flag to enforce shmem THP in hugepage_vma_check()
Date: Wed, 7 Sep 2022 07:45:12 -0700

Patch series "mm: add file/shmem support to MADV_COLLAPSE", v3.

This series builds on top of the previous "mm: userspace hugepage
collapse" series which introduced the MADV_COLLAPSE madvise mode and added
support for private, anonymous mappings[1], by adding support for file and
shmem backed memory to CONFIG_READ_ONLY_THP_FOR_FS=y kernels.

File and shmem support have been added with effort to align with existing
MADV_COLLAPSE semantics and policy decisions[2].  Collapse of shmem-backed
memory ignores kernel-guiding directives and heuristics including all
sysfs settings (transparent_hugepage/shmem_enabled), and tmpfs huge= mount
options (shmem always supports large folios).  Like anonymous mappings, on
successful return of MADV_COLLAPSE on file/shmem memory, the contents of
memory mapped by the addresses provided will be synchronously pmd-mapped
THPs.

This functionality unlocks two important uses:

(1)	Immediately back executable text by THPs.  Current support provided
	by CONFIG_READ_ONLY_THP_FOR_FS may take a long time on a large
	system which might impair services from serving at their full rated
	load after (re)starting.  Tricks like mremap(2)'ing text onto
	anonymous memory to immediately realize iTLB performance prevents
	page sharing and demand paging, both of which increase steady state
	memory footprint.  Now, we can have the best of both worlds: Peak
	upfront performance and lower RAM footprints.

(2)	userfaultfd-based live migration of virtual machines satisfy UFFD
	faults by fetching native-sized pages over the network (to avoid
	latency of transferring an entire hugepage).  However, after guest
	memory has been fully copied to the new host, MADV_COLLAPSE can
	be used to immediately increase guest performance.

khugepaged has received a small improvement by association and can now
detect and collapse pte-mapped THPs.  However, there is still work to be
done along the file collapse path.  Compound pages of arbitrary order
still needs to be supported and THP collapse needs to be converted to
using folios in general.  Eventually, we'd like to move away from the
read-only and executable-mapped constraints currently imposed on eligible
files and support any inode claiming huge folio support.  That said, I
think the series as-is covers enough to claim that MADV_COLLAPSE supports
file/shmem memory.

Patches 1-3	Implement the guts of the series.
Patch 4 	Is a tracepoint for debugging.
Patches 5-9 	Refactor existing khugepaged selftests to work with new
		memory types + new collapse tests.
Patch 10 	Adds a userfaultfd selftest mode to mimic a functional test
		of UFFDIO_REGISTER_MODE_MINOR+MADV_COLLAPSE live migration.
		(v3 note: "userfaultfd shmem" selftest is failing as of
		Sep 5 mm-unstable)

[1] https://lore.kernel.org/linux-mm/20220706235936.2197195-1-zokeefe@google.com/
[2] https://lore.kernel.org/linux-mm/YtBmhaiPHUTkJml8@google.com/

Previous versions:
v1: https://lore.kernel.org/linux-mm/20220812012843.3948330-1-zokeefe@google.com/
v2: https://lore.kernel.org/linux-mm/20220826220329.1495407-1-zokeefe@google.com/

This patch (of 10):

Extend 'mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()' to
shmem, allowing callers to ignore
/sys/kernel/transparent_hugepage/shmem_enabled and tmpfs huge= mount.

This is intended to be used by MADV_COLLAPSE, and the rationale is
analogous to the anon/file case: MADV_COLLAPSE is not coupled to
directives that advise the kernel's decisions on when THPs should be
considered eligible.  shmem/tmpfs always claims large folio support,
regardless of sysfs or mount options.

Link: https://lkml.kernel.org/r/20220907144521.3115321-2-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   10 ++++++----
 mm/huge_memory.c         |    2 +-
 mm/shmem.c               |   18 +++++++++---------
 3 files changed, 16 insertions(+), 14 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check
+++ a/include/linux/shmem_fs.h
@@ -92,11 +92,13 @@ extern struct page *shmem_read_mapping_p
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
-extern bool shmem_is_huge(struct vm_area_struct *vma,
-			  struct inode *inode, pgoff_t index);
-static inline bool shmem_huge_enabled(struct vm_area_struct *vma)
+extern bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
+			  pgoff_t index, bool shmem_huge_force);
+static inline bool shmem_huge_enabled(struct vm_area_struct *vma,
+				      bool shmem_huge_force)
 {
-	return shmem_is_huge(vma, file_inode(vma->vm_file), vma->vm_pgoff);
+	return shmem_is_huge(vma, file_inode(vma->vm_file), vma->vm_pgoff,
+			     shmem_huge_force);
 }
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
--- a/mm/huge_memory.c~mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check
+++ a/mm/huge_memory.c
@@ -119,7 +119,7 @@ bool hugepage_vma_check(struct vm_area_s
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file))
-		return shmem_huge_enabled(vma);
+		return shmem_huge_enabled(vma, !enforce_sysfs);
 
 	/* Enforce sysfs THP requirements as necessary */
 	if (enforce_sysfs &&
--- a/mm/shmem.c~mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check
+++ a/mm/shmem.c
@@ -461,20 +461,20 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-bool shmem_is_huge(struct vm_area_struct *vma,
-		   struct inode *inode, pgoff_t index)
+bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
+		   pgoff_t index, bool shmem_huge_force)
 {
 	loff_t i_size;
 
 	if (!S_ISREG(inode->i_mode))
 		return false;
-	if (shmem_huge == SHMEM_HUGE_DENY)
-		return false;
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return false;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
+	if (shmem_huge == SHMEM_HUGE_FORCE || shmem_huge_force)
 		return true;
+	if (shmem_huge == SHMEM_HUGE_DENY)
+		return false;
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
@@ -669,8 +669,8 @@ static long shmem_unused_huge_count(stru
 
 #define shmem_huge SHMEM_HUGE_DENY
 
-bool shmem_is_huge(struct vm_area_struct *vma,
-		   struct inode *inode, pgoff_t index)
+bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
+		   pgoff_t index, bool shmem_huge_force)
 {
 	return false;
 }
@@ -1056,7 +1056,7 @@ static int shmem_getattr(struct user_nam
 			STATX_ATTR_NODUMP);
 	generic_fillattr(&init_user_ns, inode, stat);
 
-	if (shmem_is_huge(NULL, inode, 0))
+	if (shmem_is_huge(NULL, inode, 0, false))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -1888,7 +1888,7 @@ repeat:
 		return 0;
 	}
 
-	if (!shmem_is_huge(vma, inode, index))
+	if (!shmem_is_huge(vma, inode, index, false))
 		goto alloc_nohuge;
 
 	huge_gfp = vma_thp_gfp_mask(vma);
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

