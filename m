From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch added to -mm tree
Date: Mon, 30 Jun 2008 23:49:49 -0700
Message-ID: <200807010649.m616nnqL013523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYGAGuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 02:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     unevictable-lru-infrastructure: remove redundant page->mapping check
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -728,13 +728,7 @@ unlock:
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

memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch

