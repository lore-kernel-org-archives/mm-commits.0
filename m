From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-support-multiple-probes-update.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:43:54 -0800
Message-ID: <200802080843.m188hZi0016119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbYBHIoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:44:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-support-multiple-probes update
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-support-multiple-probes-update.patch

This patch was dropped because it was folded into linux-kernel-markers-support-multiple-probes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-kernel-markers-support-multiple-probes update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

- Add comments requested by Andrew.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/marker.c~linux-kernel-markers-support-multiple-probes-update kernel/marker.c
--- a/kernel/marker.c~linux-kernel-markers-support-multiple-probes-update
+++ a/kernel/marker.c
@@ -49,6 +49,7 @@ static DEFINE_MUTEX(markers_mutex);
  * between two consecutive operation (add or remove) on a given marker.  It is
  * also used to delay the free of multiple probes array until a quiescent state
  * is reached.
+ * marker entries modifications are protected by the markers_mutex.
  */
 struct marker_entry {
 	struct hlist_node hlist;
@@ -102,6 +103,11 @@ void marker_probe_cb(const struct marker
 	va_list args;
 	char ptype;
 
+	/*
+	 * disabling preemption to make sure the teardown of the callbacks can
+	 * be done correctly when they are in modules and they insure RCU read
+	 * coherency.
+	 */
 	preempt_disable();
 	ptype = ACCESS_ONCE(mdata->ptype);
 	if (likely(!ptype)) {
@@ -196,7 +202,7 @@ static void free_old_closure(struct rcu_
 	entry->rcu_pending = 0;
 }
 
-static inline void debug_print_probes(struct marker_entry *entry)
+static void debug_print_probes(struct marker_entry *entry)
 {
 	int i;
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
