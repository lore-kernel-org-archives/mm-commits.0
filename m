From: akpm@linux-foundation.org
Subject: [merged] mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:51 -0800
Message-ID: <201003091903.o29J3puf031000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0CITD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     mm/migrate.c: kill anon local variable from migrate_page_copy
has been removed from the -mm tree.  Its filename was
     mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/migrate.c: kill anon local variable from migrate_page_copy
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 01b1ae63c2 ("memcg: simple migration handling") removed
mem_cgroup_uncharge_cache_page() call from migrate_page_copy.  Local
variable `anon' is now unused.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/migrate.c~mm-migratec-kill-anon-local-variable-from-migrate_page_copy mm/migrate.c
--- a/mm/migrate.c~mm-migratec-kill-anon-local-variable-from-migrate_page_copy
+++ a/mm/migrate.c
@@ -275,8 +275,6 @@ static int migrate_page_move_mapping(str
  */
 static void migrate_page_copy(struct page *newpage, struct page *page)
 {
-	int anon;
