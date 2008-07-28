From: akpm@linux-foundation.org
Subject: - unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:53:20 -0700
Message-ID: <200807282353.m6SNrKls002612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbYG1Xxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     unevictable-lru-infrastructure: remove redundant page->mapping check
has been removed from the -mm tree.  Its filename was
     unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable-lru-infrastructure: remove redundant page->mapping check
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Remove redundant mapping check.

We'd be doing exactly what putback_lru_page() is doing.  So, this code as
always unnecessary, duplicate code.  So, just let putback_lru_page()
handle this condition and conditionally unlock_page().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN mm/migrate.c~unevictable-lru-infrastructure-remove-redundant-page-mapping-check mm/migrate.c
--- a/mm/migrate.c~unevictable-lru-infrastructure-remove-redundant-page-mapping-check
+++ a/mm/migrate.c
@@ -713,13 +713,7 @@ unlock:
  		 * restored.
  		 */
  		list_del(&page->lru);
-		if (!page->mapping) {
-			VM_BUG_ON(page_count(page) != 1);
-			unlock_page(page);
-			put_page(page);		/* just free the old page */
-			goto end_migration;
-		} else
-			unlock = putback_lru_page(page);
+		unlock = putback_lru_page(page);
 	}
 
 	if (unlock)
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch

