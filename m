From: akpm@linux-foundation.org
Subject: [merged] mm-madvise-update-comment-on-sys_madvise.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:56:33 -0700
Message-ID: <56e9ba71.CEBfas/loaYkXqx1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbcCPT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gong.chen@linux.intel.com, jbaron@redhat.com, kirill@shutemov.name, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: update comment on sys_madvise()
has been removed from the -mm tree.  Its filename was
     mm-madvise-update-comment-on-sys_madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/madvise: update comment on sys_madvise()

Some new MADV_* advices are not documented in sys_madvise() comment.
So let's update it.

[akpm@linux-foundation.org: modifications suggested by Michal]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN mm/madvise.c~mm-madvise-update-comment-on-sys_madvise mm/madvise.c
--- a/mm/madvise.c~mm-madvise-update-comment-on-sys_madvise
+++ a/mm/madvise.c
@@ -639,14 +639,28 @@ madvise_behavior_valid(int behavior)
  *		some pages ahead.
  *  MADV_DONTNEED - the application is finished with the given range,
  *		so the kernel can free resources associated with it.
+ *  MADV_FREE - the application marks pages in the given range as lazy free,
+ *		where actual purges are postponed until memory pressure happens.
  *  MADV_REMOVE - the application wants to free up the given range of
  *		pages and associated backing store.
  *  MADV_DONTFORK - omit this area from child's address space when forking:
  *		typically, to avoid COWing pages pinned by get_user_pages().
  *  MADV_DOFORK - cancel MADV_DONTFORK: no longer omit this area when forking.
+ *  MADV_HWPOISON - trigger memory error handler as if the given memory range
+ *		were corrupted by unrecoverable hardware memory failure.
+ *  MADV_SOFT_OFFLINE - try to soft-offline the given range of memory.
  *  MADV_MERGEABLE - the application recommends that KSM try to merge pages in
  *		this area with pages of identical content from other such areas.
  *  MADV_UNMERGEABLE- cancel MADV_MERGEABLE: no longer merge pages with others.
+ *  MADV_HUGEPAGE - the application wants to back the given range by transparent
+ *		huge pages in the future. Existing pages might be coalesced and
+ *		new pages might be allocated as THP.
+ *  MADV_NOHUGEPAGE - mark the given range as not worth being backed by
+ *		transparent huge pages so the existing pages will not be
+ *		coalesced into THP and new pages will not be allocated as THP.
+ *  MADV_DONTDUMP - the application wants to prevent pages in the given range
+ *		from being included in its core dump.
+ *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
  *
  * return values:
  *  zero    - success
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch
tools-vm-page-typesc-support-swap-entry.patch
tools-vm-page-typesc-avoid-memset-in-walk_pfn-when-count-==-1.patch

