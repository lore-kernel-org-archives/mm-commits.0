From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-statistics-fix-sorted-list.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:09 -0700
Message-ID: <200708250519.l7P5J96L031947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755571AbXHYF3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics: fix sorted list
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-statistics-fix-sorted-list.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics: fix sorted list
From: Martin Peschke <mp3@de.ibm.com>

The list of statistics entries maintained by type 'sparse' might have shown
unsorted entries with regard to the number of reported hits.  The reason
was that new entries were always added at the tail of the list regardless
of the number of hits they came with.  Unsorted lists might suffer a
performance loss.

Fix is to sort the list by hits after entry insertion, i.e.  moving entries
added at the tail up the chain, which should not be required very often
(usually just when merging per-cpu lists).

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/statistic.c~statistics-infrastructure-statistics-fix-sorted-list lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-statistics-fix-sorted-list
+++ a/lib/statistic.c
@@ -1138,6 +1138,7 @@ static int statistic_new_sparse(struct s
 	entry->hits = incr;
 	slist->entries++;
 	list_add_tail(&entry->list, &slist->entry_lh);
+	statistic_sort_sparse(&slist->entry_lh, entry);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mp3@de.ibm.com are
