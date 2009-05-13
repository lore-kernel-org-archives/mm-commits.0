From: akpm@linux-foundation.org
Subject: + migration-only-migrate_prep-once-per-move_pages.patch added to -mm tree
Date: Wed, 13 May 2009 12:01:48 -0700
Message-ID: <200905131901.n4DJ1mWD006331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759697AbZEMTJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 15:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Brice.Goglin@ens-lyon.org, Brice.Goglin@inria.fr, cl@linux-foundation.org, heiko.carstens@de.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     migration: only migrate_prep() once per move_pages()
has been added to the -mm tree.  Its filename is
     migration-only-migrate_prep-once-per-move_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: migration: only migrate_prep() once per move_pages()
From: Brice Goglin <Brice.Goglin@ens-lyon.org>

migrate_prep() is fairly expensive (72us on 16-core barcelona 1.9GHz). 
Commit 3140a2273009c01c27d316f35ab76a37e105fdd8 improved move_pages()
throughput by breaking it into chunks, but it also made migrate_prep() be
called once per chunk (every 128pages or so) instead of once per
move_pages().

This patch reverts to calling migrate_prep() only once per chunk as we did
before 2.6.29.  It is also a followup to commit
0aedadf91a70a11c4a3e7c7d99b21e5528af8d5d ("mm: move migrate_prep out from
under mmap_sem").

This improves migration throughput on the above machine from 600MB/s to
750MB/s.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~migration-only-migrate_prep-once-per-move_pages mm/migrate.c
--- a/mm/migrate.c~migration-only-migrate_prep-once-per-move_pages
+++ a/mm/migrate.c
@@ -820,7 +820,6 @@ static int do_move_page_to_node_array(st
 	struct page_to_node *pp;
 	LIST_HEAD(pagelist);
 
-	migrate_prep();
 	down_read(&mm->mmap_sem);
 
 	/*
@@ -907,6 +906,9 @@ static int do_pages_move(struct mm_struc
 	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
 	if (!pm)
 		goto out;
+
+	migrate_prep();
+
 	/*
 	 * Store a chunk of page_to_node array in a page,
 	 * but keep the last one as a marker
_

Patches currently in -mm which might be from Brice.Goglin@ens-lyon.org are

migration-only-migrate_prep-once-per-move_pages.patch

