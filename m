From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:11 -0700
Message-ID: <200708250519.l7P5JBQd031955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817AbXHYFas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     timer_stats slimmed down: statistics prereq, cleanup
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch

This patch was dropped because it isn't in the present -mm lineup

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
