From: akpm@linux-foundation.org
Subject: - something-goes-wrong-with-timer-statistics.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:36 -0700
Message-ID: <200706011748.l51HmZrG015220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323AbXFARtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: B.Steinbrink@gmx.de, dada1@cosmosbay.com, mingo@elte.hu, pomac@vapor.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer statistics: fix race
has been removed from the -mm tree.  Its filename was
     something-goes-wrong-with-timer-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: timer statistics: fix race
From: Bjorn Steinbrink <B.Steinbrink@gmx.de>

Fix two races in the timer stats lookup code.  One by ensuring that the
initialization of a new entry is finished upon insertion of that entry. 
The other by cleaning up the hash table when the entries array is cleared,
so that we don't have any "pre-inserted" entries.

Thanks to Eric Dumazet for reminding me of the memory barriers.

Signed-off-by: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Ian Kumlien <pomac@vapor.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_stats.c |   37 ++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff -puN kernel/time/timer_stats.c~something-goes-wrong-with-timer-statistics kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~something-goes-wrong-with-timer-statistics
+++ a/kernel/time/timer_stats.c
@@ -117,21 +117,6 @@ static struct entry entries[MAX_ENTRIES]
 
 static atomic_t overflow_count;
 
-static void reset_entries(void)
-{
-	nr_entries = 0;
-	memset(entries, 0, sizeof(entries));
-	atomic_set(&overflow_count, 0);
-}
-
-static struct entry *alloc_entry(void)
-{
-	if (nr_entries >= MAX_ENTRIES)
-		return NULL;
-
-	return entries + nr_entries++;
-}
-
 /*
  * The entries are in a hash-table, for fast lookup:
  */
@@ -149,6 +134,22 @@ static struct entry *alloc_entry(void)
 
 static struct entry *tstat_hash_table[TSTAT_HASH_SIZE] __read_mostly;
 
+static void reset_entries(void)
+{
+	nr_entries = 0;
+	memset(entries, 0, sizeof(entries));
+	memset(tstat_hash_table, 0, sizeof(tstat_hash_table));
+	atomic_set(&overflow_count, 0);
+}
+
+static struct entry *alloc_entry(void)
+{
+	if (nr_entries >= MAX_ENTRIES)
+		return NULL;
+
+	return entries + nr_entries++;
+}
+
 static int match_entries(struct entry *entry1, struct entry *entry2)
 {
 	return entry1->timer       == entry2->timer	  &&
@@ -202,12 +203,15 @@ static struct entry *tstat_lookup(struct
 	if (curr) {
 		*curr = *entry;
 		curr->count = 0;
+		curr->next = NULL;
 		memcpy(curr->comm, comm, TASK_COMM_LEN);
+
+		smp_mb(); /* Ensure that curr is initialized before insert */
+
 		if (prev)
 			prev->next = curr;
 		else
 			*head = curr;
-		curr->next = NULL;
 	}
  out_unlock:
 	spin_unlock(&table_lock);
@@ -360,6 +364,7 @@ static ssize_t tstats_write(struct file 
 		if (!active) {
 			reset_entries();
 			time_start = ktime_get();
+			smp_mb();
 			active = 1;
 		}
 		break;
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

origin.patch
