From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:23 -0800
Message-ID: <20120306193523.71CD2A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:37287 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248Ab2CFTfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:24 -0500
Received: by yenq2 with SMTP id q2so679930yen.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix mapcount check in move charge code for anonymous page
has been removed from the -mm tree.  Its filename was
     memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: memcg: fix mapcount check in move charge code for anonymous page

Currently the charge on shared anonyous pages is supposed not to moved in
task migration.  To implement this, we need to check that mapcount > 1,
instread of > 2.  So this patch fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page
+++ a/mm/memcontrol.c
@@ -5075,7 +5075,7 @@ static struct page *mc_handle_present_pt
 		return NULL;
 	if (PageAnon(page)) {
 		/* we don't move shared anon */
-		if (!move_anon() || page_mapcount(page) > 2)
+		if (!move_anon() || page_mapcount(page) > 1)
 			return NULL;
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

