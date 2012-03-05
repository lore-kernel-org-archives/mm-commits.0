From: akpm@linux-foundation.org
Subject: + memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page.patch added to -mm tree
Date: Mon, 05 Mar 2012 12:14:08 -0800
Message-ID: <20120305201410.39E74A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48918 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2CEUOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Mar 2012 15:14:18 -0500
Received: by ggnd2 with SMTP id d2so527606ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Mar 2012 12:14:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     Subject: memcg: fix mapcount check in move charge code for anonymous page
has been added to the -mm tree.  Its filename is
     memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5071,7 +5071,7 @@ static struct page *mc_handle_present_pt
 		return NULL;
 	if (PageAnon(page)) {
 		/* we don't move shared anon */
-		if (!move_anon() || page_mapcount(page) > 2)
+		if (!move_anon() || page_mapcount(page) > 1)
 			return NULL;
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
_
Subject: Subject: memcg: fix mapcount check in move charge code for anonymous page

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memcg-fix-mapcount-check-in-move-charge-code-for-anonymous-page.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

