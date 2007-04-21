From: akpm@linux-foundation.org
Subject: + statistics-infrastructure-statistics-fix-sorted-list.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:20:35 -0700
Message-ID: <200704210020.l3L0KZsq027233@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbXDUAVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     statistics: fix sorted list
has been added to the -mm tree.  Its filename is
     statistics-infrastructure-statistics-fix-sorted-list.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

diff -puN lib/statistic.c~statistics-infrastructure-statistics-fix-sorted-list lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-statistics-fix-sorted-list
+++ a/lib/statistic.c
@@ -1113,6 +1113,7 @@ static int statistic_add_sparse_new(stru
 	entry->hits = incr;
 	slist->entries++;
 	list_add_tail(&entry->list, &slist->entry_lh);
+	statistic_sort_sparse(&slist->entry_lh, entry);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mp3@de.ibm.com are

sunrpc-cleanup-use-seq_release_private-where-appropriate.patch
kallsyms-cleanup-use-seq_release_private-where-appropriate.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-parser-fix.patch
add-for_each_substring-and-match_substring.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch
statistics-infrastructure-simplify-statistics-debugfs-write-function.patch
statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch
statistics-infrastructure-fix-string-termination.patch
statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch
statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch
statistics-infrastructure-statistics-fix-sorted-list.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch
statistics-infrastructure-exploitation-zfcp.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
