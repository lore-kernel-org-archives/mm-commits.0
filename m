From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-madvise-update-comment-on-sys_madvise-fix.patch removed from -mm tree
Date: Tue, 15 Mar 2016 14:39:36 -0700
Message-ID: <56e88118.S2fGNV+MGHLsLzVr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbcCOVjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gong.chen@linux.intel.com, jbaron@redhat.com, kirill@shutemov.name, mhocko@suse.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-update-comment-on-sys_madvise-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-update-comment-on-sys_madvise-fix.patch

This patch was dropped because it was folded into mm-madvise-update-comment-on-sys_madvise.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-update-comment-on-sys_madvise-fix

modifications suggested by Michal

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/madvise.c~mm-madvise-update-comment-on-sys_madvise-fix mm/madvise.c
--- a/mm/madvise.c~mm-madvise-update-comment-on-sys_madvise-fix
+++ a/mm/madvise.c
@@ -639,7 +639,7 @@ madvise_behavior_valid(int behavior)
  *		some pages ahead.
  *  MADV_DONTNEED - the application is finished with the given range,
  *		so the kernel can free resources associated with it.
- *  MADV_FREE - the application marks pages in the given range as lasyfree,
+ *  MADV_FREE - the application marks pages in the given range as lazy free,
  *		where actual purges are postponed until memory pressure happens.
  *  MADV_REMOVE - the application wants to free up the given range of
  *		pages and associated backing store.
@@ -652,10 +652,12 @@ madvise_behavior_valid(int behavior)
  *  MADV_MERGEABLE - the application recommends that KSM try to merge pages in
  *		this area with pages of identical content from other such areas.
  *  MADV_UNMERGEABLE- cancel MADV_MERGEABLE: no longer merge pages with others.
- *  MADV_HUGEPAGE - the application wants to allocate transparent hugepages to
- *		load the content of the given memory range.
- *  MADV_NOHUGEPAGE - cancel MADV_HUGEPAGE: no longer allocate transparent
- *		hugepages.
+ *  MADV_HUGEPAGE - the application wants to back the given range by transparent
+ *		huge pages in the future. Existing pages might be coalesced and
+ *		new pages might be allocated as THP.
+ *  MADV_NOHUGEPAGE - mark the given range as not worth being backed by
+ *		transparent huge pages so the existing pages will not be
+ *		coalesced into THP and new pages will not be allocated as THP.
  *  MADV_DONTDUMP - the application wants to prevent pages in the given range
  *		from being included in its core dump.
  *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

