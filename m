From: akpm@linux-foundation.org
Subject: - markers-dont-risk-null-deref-in-marker.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:02 -0800
Message-ID: <200803050745.m257j2eZ021562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764815AbYCEHpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     markers: don't risk NULL deref in marker
has been removed from the -mm tree.  Its filename was
     markers-dont-risk-null-deref-in-marker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: don't risk NULL deref in marker
From: Jesper Juhl <jesper.juhl@gmail.com>

get_marker() may return NULL, so test for it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/marker.c~markers-dont-risk-null-deref-in-marker kernel/marker.c
--- a/kernel/marker.c~markers-dont-risk-null-deref-in-marker
+++ a/kernel/marker.c
@@ -698,14 +698,12 @@ int marker_probe_unregister(const char *
 {
 	struct marker_entry *entry;
 	struct marker_probe_closure *old;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
-	if (!entry) {
-		ret = -ENOENT;
+	if (!entry)
 		goto end;
-	}
 	if (entry->rcu_pending)
 		rcu_barrier();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
@@ -713,12 +711,15 @@ int marker_probe_unregister(const char *
 	marker_update_probes();		/* may update entry */
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
+	if (!entry)
+		goto end;
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
+	ret = 0;
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are


