From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:13 -0700
Message-ID: <200708250519.l7P5JDnQ031958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755980AbXHYFcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     timer_stats slimmed down: statistics prereq, keys
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: timer_stats slimmed down: statistics prereq, keys
From: Martin Peschke <mp3@de.ibm.com>

Client have statistics be updated by reporting (X, Y) data pairs, with X being
a certain characteristic and Y a qualifier, e.g.  (request size, number of new
requests of this size).  In a way, the role of X is the one of a primary key
for statistics entries, if the statistic comprises several "baskets" (think of
histograms).

X used to be an integer value.  For several applications it might be useful to
allow X to be an opaque binary blob.  This way, clients can use structures
with several members as keys.

Clients are called back when statistics entries are printed, so that they can
label entries using their interpretation of a key.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/statistic.h |  132 +++++++++++++++++++++++-
 lib/statistic.c           |  191 +++++++++++++++++++++++++++---------
 2 files changed, 272 insertions(+), 51 deletions(-)

diff -puN include/linux/statistic.h~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys include/linux/statistic.h
--- a/include/linux/statistic.h~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys
+++ a/include/linux/statistic.h
@@ -1,11 +1,9 @@
 /*
- * include/linux/statistic.h
+ * statistics facility
  *
- * Statistics facility
+ * Copyright IBM Corp. 2005, 2007
  *
- * (C) Copyright IBM Corp. 2005, 2006
- *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com>
+ * Author(s): Martin Peschke <mp3@de.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -35,6 +33,7 @@
  * @x_unit: pointer to string describing unit of X of (X, Y) data pair
  * @y_unit: pointer to string describing unit of Y of (X, Y) data pair
  * @flags: bits describing special settings
+ * @key_size: in bytes, only applicable if STATISTIC_FLAGS_KEY is used
  * @defaults: pointer to string describing defaults setting for attributes
  *
  * Exploiters must setup an array of struct statistic_info for a
@@ -56,6 +55,14 @@ struct statistic_info {
 #define STATISTIC_FLAGS_NOINCR	0x01	/* no incremental data */
 #define STATISTIC_FLAGS_NOFLEX	0x02	/* type can't be altered by user */
 #define STATISTIC_FLAGS_LABEL	0x04	/* client want's to label buckets */
+#define _STATISTIC_FLAGS_KEY	0x08	/* client uses opaque binary key
+					   instead of integer
+					   (flag not for direct use) */
+#define STATISTIC_FLAGS_KEY	_STATISTIC_FLAGS_KEY | STATISTIC_FLAGS_LABEL
+					/* client uses opaque binary key and
+					   labels buckets based on its
+					   interpretation of keys */
+	int  key_size;
 	char *defaults;
 };
 
@@ -89,6 +96,7 @@ struct statistic {
 	u64			 started;
 	u64			 stopped;
 	u64			 age;
+	int			 key_size; /* FIXME: not pretty */
 	union {
 		struct {
 			s64 range_min;
@@ -125,7 +133,7 @@ struct statistic_interface {
 	int			 number;
 	int			(*pull)(struct statistic_interface *interface);
 	void			(*label)(struct statistic_interface *interface,
-					 int i, s64 value,
+					 int i, void *key,
 					 struct seq_file *seq);
 	void			*private;
 };
@@ -136,9 +144,12 @@ extern int statistic_create(struct stati
 extern int statistic_remove(struct statistic_interface *);
 
 extern void statistic_set(struct statistic *, int, s64, u64);
+extern void statistic_set_key(struct statistic *, int, void *, u64);
 
 extern void _statistic_add(struct statistic *, int, s64, u64);
 extern void statistic_add(struct statistic *, int, s64, u64);
+extern void _statistic_add_key(struct statistic *, int, void *, u64);
+extern void statistic_add_key(struct statistic *, int, void *, u64);
 
 /*
  * Clients are not supposed to call these directly.
@@ -152,6 +163,8 @@ extern void statistic_add_histogram_lin(
 extern void statistic_add_histogram_log2(struct statistic *, s64, u64);
 extern void statistic_add_sparse(struct statistic *, s64, u64);
 
+extern void statistic_kadd_sparse(struct statistic *, void *, u64);
+
 /**
  * _statistic_add_as - update statistic with incremental data in (X, Y) pair
  * @type: data proessing mode to be used (must match statistic_info::defaults)
@@ -230,6 +243,76 @@ static inline void statistic_add_as(int 
 	local_irq_restore(flags);
 }
 
+/**
+ * _statistic_add_as_key - update statistic with incremental data in (X, Y) pair
+ * @type: data proessing mode to be used (must match statistic_info::defaults)
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @key: X (opaque binary blob)
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This function is faster than _statistic_add() because the data
+ * processing mode is already determined at compile time.
+ * Use this when you feel that the perfomance gain outweighs the loss
+ * of flexibility for your particular statistic.
+ *
+ * This variant leaves protecting per-cpu data to clients. It is preferred
+ * whenever clients update several statistics of the same entity in one go.
+ *
+ * You may want to use _statistic_inc_as_key() for (X, 1) data pairs.
+ */
+static inline void _statistic_add_as_key(int type, struct statistic *stat,
+					 int i, void *key, u64 incr)
+{
+	if (stat[i].state == STATISTIC_STATE_ON) {
+		switch (type) {
+		case STAT_CNTR_INC:
+		case STAT_CNTR_PROD:
+		case STAT_UTIL:
+		case STAT_HGRAM_LIN:
+		case STAT_HGRAM_LOG2:
+			_statistic_add_as(type, stat, i, 0, incr);
+			break;
+		case STAT_SPARSE:
+			statistic_kadd_sparse(&stat[i], key, incr);
+			break;
+		}
+	}
+}
+
+/**
+ * statistic_add_as_key - update statistic with incremental data in (X, Y) pair
+ * @type: data proessing mode to be used (must match statistic_info::defaults)
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @key: X (opaque binary blob)
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * the definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This function is faster than statistic_add() because the data
+ * processing mode is already determined at compile time.
+ * Use this when you feel that the perfomance gain outweighs the loss
+ * of flexibility for your particular statistic.
+ *
+ * This variant takes care of protecting per-cpu data. It is preferred whenever
+ * clients don't update several statistics of the same entity in one go.
+ *
+ * You may want to use statistic_inc_as_key() for (X, 1) data pairs.
+ */
+static inline void statistic_add_as_key(int type, struct statistic *stat,
+					int i, void *key, u64 incr)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	_statistic_add_as_key(type, stat, i, key, incr);
+	local_irq_restore(flags);
+}
+
 #else /* !CONFIG_STATISTICS */
 /* These NOP functions unburden clients from handling !CONFIG_STATISTICS. */
 
@@ -269,6 +352,31 @@ static inline void statistic_add_as(int 
 {
 }
 
+static inline void statistic_set_key(struct statistic *stat, int i,
+				     void *key, u64 total)
+{
+}
+
+static inline void _statistic_add_key(struct statistic *stat, int i,
+				      void *key, u64 incr)
+{
+}
+
+static inline void statistic_add_key(struct statistic *stat, int i,
+				     void *key, u64 incr)
+{
+}
+
+static inline void _statistic_add_as_key(int type, struct statistic *stat,
+					 int i, void *key, u64 incr)
+{
+}
+
+static inline void statistic_add_as_key(int type, struct statistic *stat,
+					int i, void *key, u64 incr)
+{
+}
+
 #endif /* CONFIG_STATISTICS */
 
 #define _statistic_inc(stat, i, value) \
@@ -283,4 +391,16 @@ static inline void statistic_add_as(int 
 #define statistic_inc_as(type, stat, i, value) \
 	statistic_add_as(type, stat, i, value, 1)
 
+#define _statistic_inc_key(stat, i, key) \
+	_statistic_add_key(stat, i, key, 1)
+
+#define statistic_inc_key(stat, i, key) \
+	statistic_add_key(stat, i, key, 1)
+
+#define _statistic_inc_as_key(type, stat, i, key) \
+	_statistic_add_as_key(type, stat, i, key, 1)
+
+#define statistic_inc_as_key(type, stat, i, key) \
+	statistic_add_as_key(type, stat, i, key, 1)
+
 #endif /* STATISTIC_H */
diff -puN lib/statistic.c~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys
+++ a/lib/statistic.c
@@ -1,12 +1,9 @@
 /*
- *  lib/statistic.c
- *    statistics facility
+ * statistics facility
  *
- *    Copyright (C) 2005, 2006
- *		IBM Deutschland Entwicklung GmbH,
- *		IBM Corporation
+ * Copyright IBM Corp. 2005, 2007
  *
- *    Author(s): Martin Peschke (mpeschke@de.ibm.com),
+ * Author(s): Martin Peschke (mp3@de.ibm.com),
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -38,10 +35,6 @@
  *	  to a struct statistic
  *	  (e.g. show histogram of requests sizes and history of megabytes/sec.
  *	  at the same time)
- *	- multi-dimensional statistic (combination of two or more
- *	  characteristics/discriminators); worth the effort??
- *	  (e.g. a matrix of occurences for latencies of requests of
- *	  particular sizes)
  *
  *	FIXME:
  *	- statistics file access when statistics are being removed
@@ -73,6 +66,8 @@
  * @data: prints content of a data area into buffer (mandatory)
  * @add: updates a data area for a statistic fed incremental data (mandatory)
  * @set: updates a data area for a statistic fed total numbers (mandatory)
+ * @kadd: updates a data area for a statistic fed incremental data (optional)
+ * @kset: updates a data area for a statistic fed total numbers (optional)
  * @name: pointer to name string (mandatory)
  *
  * Struct statistic_discipline describes a statistic infrastructure internal
@@ -86,6 +81,10 @@
  * users read data from files. Implementers of data processing modes
  * don't need to worry about the designation of a particular chunk of memory.
  * A data area of a data processing mode always has to look the same.
+ *
+ * While add() and set() use X of (X, Y) value pairs as primary key for
+ * statistics comprising several entries, kadd() and kset() take an opaque
+ * binary blob for the same purpose.
  */
 struct statistic_discipline {
 	int (*parse)(struct statistic * stat, struct statistic_info *info,
@@ -98,6 +97,8 @@ struct statistic_discipline {
 		     struct statistic_interface *interface, int i);
 	void (*add)(struct statistic *stat, s64 value, u64 incr);
 	void (*set)(struct statistic *stat, s64 value, u64 total);
+	void (*kadd)(struct statistic *stat, void *key, u64 incr);
+	void (*kset)(struct statistic *stat, void *key, u64 total);
 	char *name;
 };
 
@@ -992,7 +993,7 @@ static void _statistic_data_histogram(st
 {
 	seq_printf(seq, "%s %s%Ld %Lu ", info->name, prefix, bound, hits);
 	if (info->flags & STATISTIC_FLAGS_LABEL)
-		interface->label(interface, i, bound, seq);
+		interface->label(interface, i, &bound, seq);
 	seq_printf(seq, "\n");
 }
 
@@ -1074,8 +1075,8 @@ static int statistic_parse_histogram(str
 
 struct statistic_entry_sparse {
 	struct list_head list;
-	s64 value;
 	u64 hits;
+	char key[0];
 };
 
 struct statistic_sparse_list {
@@ -1108,8 +1109,8 @@ static void statistic_reset_sparse(struc
 	slist->hits_missed = 0;
 }
 
-static void statistic_add_sparse_sort(struct list_head *head,
-				      struct statistic_entry_sparse *entry)
+static void statistic_sort_sparse(struct list_head *head,
+				  struct statistic_entry_sparse *entry)
 {
 	struct statistic_entry_sparse *sort;
 
@@ -1122,63 +1123,66 @@ static void statistic_add_sparse_sort(st
 		list_move(&entry->list, &sort->list);
 }
 
-static int statistic_add_sparse_new(struct statistic_sparse_list *slist,
-				    s64 value, u64 incr)
+static int statistic_new_sparse(struct statistic_sparse_list *slist,
+				int key_size, void *key, u64 incr)
 {
 	struct statistic_entry_sparse *entry;
+	int entry_size = sizeof(struct statistic_entry_sparse) + key_size;
 
 	if (unlikely(slist->entries == slist->entries_max))
 		return -ENOMEM;
-	entry = kmalloc(sizeof(struct statistic_entry_sparse), GFP_ATOMIC);
+	entry = kmalloc(entry_size, GFP_ATOMIC);
 	if (unlikely(!entry))
 		return -ENOMEM;
-	entry->value = value;
+	memcpy(entry->key, key, key_size);
 	entry->hits = incr;
 	slist->entries++;
 	list_add_tail(&entry->list, &slist->entry_lh);
 	return 0;
 }
 
-static void _statistic_add_sparse(struct statistic_sparse_list *slist,
-				  s64 value, u64 incr)
+static void statistic_do_sparse(int add, struct statistic_sparse_list *slist,
+				int key_size, void *key, u64 incr)
 {
 	struct list_head *head = &slist->entry_lh;
 	struct statistic_entry_sparse *entry;
 
 	list_for_each_entry(entry, head, list) {
-		if (likely(entry->value == value)) {
-			entry->hits += incr;
-			statistic_add_sparse_sort(head, entry);
+		if (likely(!memcmp(entry->key, key, key_size))) {
+			if (add)
+				entry->hits += incr;
+			else
+				entry->hits = incr;
+			statistic_sort_sparse(head, entry);
 			return;
 		}
 	}
-	if (unlikely(statistic_add_sparse_new(slist, value, incr)))
+	if (unlikely(statistic_new_sparse(slist, key_size, key, incr)))
 		slist->hits_missed += incr;
 }
 
 void statistic_add_sparse(struct statistic *stat, s64 value, u64 incr)
 {
-	struct statistic_sparse_list *slist;
-	slist = percpu_ptr(stat->data, smp_processor_id());
-	_statistic_add_sparse(slist, value, incr);
+	void *slist = percpu_ptr(stat->data, smp_processor_id());
+	statistic_do_sparse(1, slist, sizeof(value), &value, incr);
 }
 EXPORT_SYMBOL_GPL(statistic_add_sparse);
 
-static void statistic_set_sparse(struct statistic *stat, s64 value, u64 total)
+void statistic_kadd_sparse(struct statistic *stat, void *key, u64 incr)
 {
-	struct statistic_sparse_list *slist = stat->data;
-	struct list_head *head = &slist->entry_lh;
-	struct statistic_entry_sparse *entry;
+	void *slist = percpu_ptr(stat->data, smp_processor_id());
+	statistic_do_sparse(1, slist, stat->key_size, key, incr);
+}
+EXPORT_SYMBOL_GPL(statistic_kadd_sparse);
 
-	list_for_each_entry(entry, head, list) {
-		if (likely(entry->value == value)) {
-			entry->hits = total;
-			statistic_add_sparse_sort(head, entry);
-			return;
-		}
-	}
-	if (unlikely(statistic_add_sparse_new(slist, value, total)))
-		slist->hits_missed += total;
+void statistic_set_sparse(struct statistic *stat, s64 value, u64 incr)
+{
+	statistic_do_sparse(0, stat->data, sizeof(value), &value, incr);
+}
+
+void statistic_kset_sparse(struct statistic *stat, void *key, u64 incr)
+{
+	statistic_do_sparse(0, stat->data, stat->key_size, key, incr);
 }
 
 static void statistic_merge_sparse(struct statistic *stat,
@@ -1186,9 +1190,11 @@ static void statistic_merge_sparse(struc
 {
 	struct statistic_sparse_list *dst = _dst, *src = _src;
 	struct statistic_entry_sparse *entry;
+
 	dst->hits_missed += src->hits_missed;
 	list_for_each_entry(entry, &src->entry_lh, list)
-		_statistic_add_sparse(dst, entry->value, entry->hits);
+		statistic_do_sparse(1, dst, stat->key_size,
+				    entry->key, entry->hits);
 }
 
 static void statistic_data_sparse(struct statistic *stat, struct seq_file *seq,
@@ -1201,11 +1207,15 @@ static void statistic_data_sparse(struct
 	seq_printf(seq, "%s missed 0x%Lu\n", info->name,
 		   (unsigned long long)slist->hits_missed);
 	list_for_each_entry(entry, &slist->entry_lh, list) {
-		seq_printf(seq, "%s 0x%Lx %Lu ", info->name,
-			   (signed long long)entry->value,
-			   (unsigned long long)entry->hits);
+		seq_printf(seq, "%s ", info->name);
+		if (info->flags & _STATISTIC_FLAGS_KEY)
+			seq_printf(seq, "- ");
+		else
+			seq_printf(seq, "0x%Lx ",
+				   *(signed long long *)entry->key);
+		seq_printf(seq, "%Lu ", (unsigned long long)entry->hits);
 		if (info->flags & STATISTIC_FLAGS_LABEL)
-			interface->label(interface, i, entry->value, seq);
+			interface->label(interface, i, entry->key, seq);
 		seq_printf(seq, "\n");
 	}
 }
@@ -1297,6 +1307,8 @@ static struct statistic_discipline stati
 		.data	= statistic_data_sparse,
 		.add	= statistic_add_sparse,
 		.set	= statistic_set_sparse,
+		.kadd	= statistic_kadd_sparse,
+		.kset	= statistic_kset_sparse,
 		.name	= "sparse",
 	},
 	[STAT_NONE] = {}
@@ -1351,6 +1363,10 @@ int statistic_create(struct statistic_in
 	}
 
 	for (i = 0; i < interface->number; i++, stat++, info++) {
+		if (info->flags & _STATISTIC_FLAGS_KEY)
+			stat->key_size = info->key_size;
+		else
+			stat->key_size = sizeof(s64);
 		statistic_transition(stat, info, STATISTIC_STATE_UNCONFIGURED);
 		statistic_parse_match(stat, info, NULL);
 	}
@@ -1396,6 +1412,91 @@ int statistic_remove(struct statistic_in
 EXPORT_SYMBOL_GPL(statistic_remove);
 
 /**
+ * _statistic_add_key - update statistic with incremental data in (X, Y) pair
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @key: X (opaque binary blob)
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This variant leaves protecting per-cpu data to clients. It is preferred
+ * whenever clients update several statistics of the same entity in one go.
+ *
+ * You may want to use _statistic_inc_key() for (X, 1) data pairs.
+ */
+void _statistic_add_key(struct statistic *stat, int i, void *key, u64 incr)
+{
+	struct statistic_discipline *disc = &statistic_discs[stat[i].type];
+
+	if (stat[i].state == STATISTIC_STATE_ON) {
+		if (disc->kadd)
+			disc->kadd(&stat[i], key, incr);
+		else
+			disc->add(&stat[i], 0, incr);
+	}
+}
+EXPORT_SYMBOL_GPL(_statistic_add_key);
+
+/**
+ * statistic_add_key - update statistic with incremental data in (X, Y) pair
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X (opaque binary blob)
+ * @incr: Y
+ * @key: opaque binary blob used as primary key instead of X
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * the definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This variant takes care of protecting per-cpu data. It is preferred whenever
+ * clients don't update several statistics of the same entity in one go.
+ *
+ * You may want to use statistic_inc_key() for (X, 1) data pairs.
+ */
+void statistic_add_key(struct statistic *stat, int i, void *key, u64 incr)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	_statistic_add_key(stat, i, key, incr);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(statistic_add_key);
+
+/**
+ * statistic_set_key - set statistic using total numbers in (X, Y) data pair
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X (opaque binary blob)
+ * @total: Y
+ * @key: opaque binary blob used as primary key instead of X
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * There is no distinction between a concurrency protected and unprotected
+ * statistic_set_key() flavour needed. statistic_set_key() may only
+ * be called when we pull statistic updates from clients. The statistics
+ * infrastructure guarantees serialisation for that. Exploiters must not
+ * intermix statistic_set_key() and statistic_add/inc_key() anyway. That is why,
+ * concurrent updates won't happen and there is no additional protection
+ * required for statistics fed through statistic_set_key().
+ */
+void statistic_set_key(struct statistic *stat, int i, void *key, u64 total)
+{
+	struct statistic_discipline *disc = &statistic_discs[stat[i].type];
+
+	if (stat[i].state == STATISTIC_STATE_ON) {
+		if (disc->kset)
+			disc->kset(&stat[i], key, total);
+		else
+			disc->set(&stat[i], 0, total);
+	}
+}
+EXPORT_SYMBOL_GPL(statistic_set_key);
+
+/**
  * _statistic_add - update statistic with incremental data in (X, Y) pair
  * @stat: struct statistic array
  * @i: index of statistic to be updated
_

Patches currently in -mm which might be from mp3@de.ibm.com are
