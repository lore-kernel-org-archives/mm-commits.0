From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch removed from -mm
 tree
Date: Mon, 02 Nov 2015 14:51:03 -0800
Message-ID: <5637e8d7.a6yEUF6HyD42FT/a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbbKBWvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: dont split thp page when syscall is called fix 4
has been removed from the -mm tree.  Its filename was
     mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

This patch was dropped because it was folded into mm-dont-split-thp-page-when-syscall-is-called.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: dont split thp page when syscall is called fix 4

Compiler gives helpful warnings that madvise_free_pte_range()
has the args to split_huge_pmd() the wrong way round.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-4 mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-4
+++ a/mm/madvise.c
@@ -275,7 +275,7 @@ static int madvise_free_pte_range(pmd_t
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd)) {
 		if (next - addr != HPAGE_PMD_SIZE)
-			split_huge_pmd(vma, addr, pmd);
+			split_huge_pmd(vma, pmd, addr);
 		else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
 			goto next;
 		/* fall through */
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch

