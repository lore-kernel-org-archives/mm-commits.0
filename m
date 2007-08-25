From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-prerequisite-list.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:52 -0700
Message-ID: <200708250518.l7P5IqLh031914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbXHYFS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure - prerequisite: list operation
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-prerequisite-list.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure - prerequisite: list operation
From: Martin Peschke <mp3@de.ibm.com>

This patch series is a proposal for a generic implementation of statistics. 
Envisioned exploiters include device drivers, and any other component.  It
provides both a unified programming interface for exploiters as well as a
unified user interface.  It comes with a set of disciplines that implement
various ways of data processing, like counters and histograms.

The recent rework addresses performance issues and memory footprint,
straightens some concepts out, streamlines the programming interface, removes
some weiredness from the user interface, and reduces the amount of code.

A few more keywords for the reader's convenience: based on per-cpu data;
spinlock-free protection of data; observes cpu-hot(un)plug for efficient
memory use; tiny state machine for switching-on, switching-off, releasing data
etc.; configurable by users at run-time; still sitting in debugfs; simple
addition of other disciplines.

Good places to start reading code are:

   statistic_create(), statistic_remove()
   statistic_add(), statistic_inc()
   struct statistic_interface, struct statistic
   struct statistic_discipline, statistic_*_counter()
   statistic_transition()



This patch:

Add another list_for_each_* derivate.  I can't work around it because there is
a list that I need to search both ways.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/linux/list.h~statistics-infrastructure-prerequisite-list include/linux/list.h
--- a/include/linux/list.h~statistics-infrastructure-prerequisite-list
+++ a/include/linux/list.h
@@ -525,6 +525,19 @@ static inline void list_splice_init_rcu(
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_each_entry_continue_reverse - list iterator variant
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Iterates backwards over list of given type continuing before given point.
+ */
+#define list_for_each_entry_continue_reverse(pos, head, member) 	\
+	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
+	     prefetch(pos->member.prev), &pos->member != (head);	\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+
+/**
  * list_for_each_entry_from - iterate over list of given type from the current point
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
_

Patches currently in -mm which might be from mp3@de.ibm.com are
