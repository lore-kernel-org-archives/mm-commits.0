From: akpm@linux-foundation.org
Subject: + statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:18:12 -0700
Message-ID: <200704210018.l3L0ICUO027178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbXDUASr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     timer_stats slimmed down: statistics prereq, cleanup
has been added to the -mm tree.  Its filename is
     statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timer_stats slimmed down: statistics prereq, cleanup
From: Martin Peschke <mp3@de.ibm.com>

Small cleanup

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/statistic.h |    6 +++---
 lib/statistic.c           |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/statistic.h~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup include/linux/statistic.h
--- a/include/linux/statistic.h~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup
+++ a/include/linux/statistic.h
@@ -106,7 +106,7 @@ struct statistic {
  * @info: a struct statistic_info array describing the struct statistic array
  * @number: number of entries in both arrays
  * @pull: an optional function called when user reads data from file
- * @pull_private: optional data pointer passed to pull function
+ * @private: optional data pointer reserved for use by clients
  *
  * Exploiters must setup a struct statistic_interface prior to calling
  * statistic_create().
@@ -121,8 +121,8 @@ struct statistic_interface {
 	struct statistic	*stat;
 	struct statistic_info	*info;
 	int			 number;
-	int			(*pull)(void*);
-	void			*pull_private;
+	int			(*pull)(struct statistic_interface *interface);
+	void			*private;
 };
 
 #ifdef CONFIG_STATISTICS
diff -puN lib/statistic.c~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup
+++ a/lib/statistic.c
@@ -663,7 +663,7 @@ static int statistic_open_data(struct in
 	int size, i, j, retval = -ENOMEM;
 
 	if (interface->pull)
-		interface->pull(interface->pull_private);
+		interface->pull(interface);
 
 	size = interface->number * sizeof(struct statistic);
 	seq_priv = kzalloc(sizeof(struct statistic_seq_private), GFP_KERNEL);
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
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch
statistics-infrastructure-exploitation-zfcp.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
