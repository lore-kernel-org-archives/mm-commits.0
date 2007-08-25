From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:16 -0700
Message-ID: <200708250519.l7P5JG8H031961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbXHYFcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     timer_stats slimmed down: statistics prereq, labels
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: timer_stats slimmed down: statistics prereq, labels
From: Martin Peschke <mp3@de.ibm.com>

This patch allows clients of the statistics infrastructure to be called back
when an entry of a statistic is printed and if the client might want to add
some kind of label to the output string.  A line would look like this then:

<statistic name> <basket> <hits> <label>

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/statistic.h |    5 ++
 lib/statistic.c           |   68 +++++++++++++++++++++++++-----------
 2 files changed, 53 insertions(+), 20 deletions(-)

diff -puN include/linux/statistic.h~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels include/linux/statistic.h
--- a/include/linux/statistic.h~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels
+++ a/include/linux/statistic.h
@@ -55,6 +55,7 @@ struct statistic_info {
 	int  flags;
 #define STATISTIC_FLAGS_NOINCR	0x01	/* no incremental data */
 #define STATISTIC_FLAGS_NOFLEX	0x02	/* type can't be altered by user */
+#define STATISTIC_FLAGS_LABEL	0x04	/* client want's to label buckets */
 	char *defaults;
 };
 
@@ -106,6 +107,7 @@ struct statistic {
  * @info: a struct statistic_info array describing the struct statistic array
  * @number: number of entries in both arrays
  * @pull: an optional function called when user reads data from file
+ * @label: an optional function retrieving a label for each statistics entry
  * @private: optional data pointer reserved for use by clients
  *
  * Exploiters must setup a struct statistic_interface prior to calling
@@ -122,6 +124,9 @@ struct statistic_interface {
 	struct statistic_info	*info;
 	int			 number;
 	int			(*pull)(struct statistic_interface *interface);
+	void			(*label)(struct statistic_interface *interface,
+					 int i, s64 value,
+					 struct seq_file *seq);
 	void			*private;
 };
 
diff -puN lib/statistic.c~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels
+++ a/lib/statistic.c
@@ -95,7 +95,7 @@ struct statistic_discipline {
 	void (*merge)(struct statistic *stat, void *dst, void *src);
 	void (*def)(struct statistic *stat, struct seq_file *seq);
 	void (*data)(struct statistic *stat, struct seq_file *seq,
-		     const char *name);
+		     struct statistic_interface *interface, int i);
 	void (*add)(struct statistic *stat, s64 value, u64 incr);
 	void (*set)(struct statistic *stat, s64 value, u64 total);
 	char *name;
@@ -559,13 +559,11 @@ static int statistic_seq_show_def(struct
 static int statistic_seq_show_data(struct seq_file *seq, void *_seq_priv)
 {
 	struct statistic_seq_private *seq_priv = _seq_priv;
-	struct statistic_interface *interface = seq_priv->interface;
 	struct statistic *stat = &seq_priv->stat[seq_priv->i];
-	struct statistic_info *info = &interface->info[seq_priv->i];
 	struct statistic_discipline *disc = &statistic_discs[stat->type];
 
 	if (stat->state >= STATISTIC_STATE_OFF)
-		disc->data(stat, seq, info->name);
+		disc->data(stat, seq, seq_priv->interface, seq_priv->i);
 	return 0;
 }
 
@@ -783,9 +781,12 @@ static void statistic_merge_counter(stru
 }
 
 static void statistic_data_counter(struct statistic *stat, struct seq_file *seq,
-				   const char *name)
+				   struct statistic_interface *interface, int i)
 {
-	seq_printf(seq, "%s %Lu\n", name, *(unsigned long long *)stat->data);
+	struct statistic_info *info = &interface->info[i];
+
+	seq_printf(seq, "%s %Lu\n",
+		   info->name, *(unsigned long long *)stat->data);
 }
 
 /* code concerned with utilisation indicator statistic */
@@ -869,8 +870,9 @@ static int statistic_div(signed long lon
 }
 
 static void statistic_data_util(struct statistic *stat, struct seq_file *seq,
-				const char *name)
+				struct statistic_interface *interface, int i)
 {
+	struct statistic_info *info = &interface->info[i];
 	struct statistic_entry_util *util = stat->data;
 	unsigned long long mean_w = 0, mean_d = 0, var_w = 0, var_d = 0,
 			   num = util->num, acc = util->acc, sqr = util->sqr;
@@ -881,8 +883,12 @@ static void statistic_data_util(struct s
 	statistic_div(&var_w, &var_d, sqr - mean_w * mean_w, num, 3);
 	seq_printf(seq, "%s samples %Lu\n%s minimum %Ld\n"
 		   "%s average %Ld.%03Ld\n%s maximum %Ld\n"
-		   "%s variance %Ld.%03Ld\n", name, num, name, min,
-		   name, mean_w, mean_d, name, max, name, var_w, var_d);
+		   "%s variance %Ld.%03Ld\n",
+		   info->name, num,
+		   info->name, min,
+		   info->name, mean_w, mean_d,
+		   info->name, max,
+		   info->name, var_w, var_d);
 }
 
 /* code concerned with histogram statistics */
@@ -977,19 +983,36 @@ static void statistic_merge_histogram(st
 		dst[i] += src[i];
 }
 
+static void _statistic_data_histogram(struct seq_file *seq, const char *prefix,
+				      signed long long bound,
+				      unsigned long long hits,
+				      struct statistic_info *info,
+				      struct statistic_interface *interface,
+				      int i)
+{
+	seq_printf(seq, "%s %s%Ld %Lu ", info->name, prefix, bound, hits);
+	if (info->flags & STATISTIC_FLAGS_LABEL)
+		interface->label(interface, i, bound, seq);
+	seq_printf(seq, "\n");
+}
+
 static void statistic_data_histogram(struct statistic *stat,
-				     struct seq_file *seq, const char *name)
+				     struct seq_file *seq,
+				     struct statistic_interface *interface,
+				     int i)
 {
-	int i;
+	struct statistic_info *info = &interface->info[i];
+	int j;
 	signed long long bound = 0;
 	unsigned long long hits = 0;
 
-	for (i = 0; i < (stat->u.histogram.last_index); i++) {
-		bound = statistic_histogram_calc_value(stat, i);
-		hits = ((u64*)stat->data)[i];
-		seq_printf(seq, "%s <=%Ld %Lu\n", name, bound, hits);
+	for (j = 0; j < (stat->u.histogram.last_index); j++) {
+		bound = statistic_histogram_calc_value(stat, j);
+		hits = ((u64*)stat->data)[j];
+		_statistic_data_histogram(seq, "<=", bound, hits, info,
+					  interface, i);
 	}
-	seq_printf(seq, "%s >%Ld %Lu\n", name, bound, hits);
+	_statistic_data_histogram(seq, ">", bound, hits, info, interface, i);
 }
 
 static void statistic_def_histogram(struct statistic *stat,
@@ -1169,17 +1192,22 @@ static void statistic_merge_sparse(struc
 }
 
 static void statistic_data_sparse(struct statistic *stat, struct seq_file *seq,
-				  const char *name)
+				  struct statistic_interface *interface, int i)
 {
+	struct statistic_info *info = &interface->info[i];
 	struct statistic_sparse_list *slist = stat->data;
 	struct statistic_entry_sparse *entry;
 
-	seq_printf(seq, "%s missed 0x%Lu\n", name,
+	seq_printf(seq, "%s missed 0x%Lu\n", info->name,
 		   (unsigned long long)slist->hits_missed);
-	list_for_each_entry(entry, &slist->entry_lh, list)
-		seq_printf(seq, "%s 0x%Lx %Lu\n", name,
+	list_for_each_entry(entry, &slist->entry_lh, list) {
+		seq_printf(seq, "%s 0x%Lx %Lu ", info->name,
 			   (signed long long)entry->value,
 			   (unsigned long long)entry->hits);
+		if (info->flags & STATISTIC_FLAGS_LABEL)
+			interface->label(interface, i, entry->value, seq);
+		seq_printf(seq, "\n");
+	}
 }
 
 static void statistic_def_sparse(struct statistic *stat, struct seq_file *seq)
_

Patches currently in -mm which might be from mp3@de.ibm.com are
