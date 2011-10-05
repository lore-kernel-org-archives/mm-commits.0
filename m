From: akpm@google.com
Subject: [merged] llist-move-cpu_relax-after-cmpxchg.patch removed from -mm tree
Date: Wed, 05 Oct 2011 12:12:50 -0700
Message-ID: <201110051912.p95JCoYU020707@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29313 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427Ab1JETNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, andi@firstfloor.org, mathieu.desnoyers@efficios.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: llist: move cpu_relax after cmpxchg
has been removed from the -mm tree.  Its filename was
     llist-move-cpu_relax-after-cmpxchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: llist: move cpu_relax after cmpxchg

If the first cmpxchg call succeeds, it is not necessary to use cpu_relax
before cmpxchg.  So cpu_relax in a busy loop involving cmpxchg should go
after cmpxchg instead of before that.  This patch fixes this in llist.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN include/linux/llist.h~llist-move-cpu_relax-after-cmpxchg include/linux/llist.h
--- a/include/linux/llist.h~llist-move-cpu_relax-after-cmpxchg
+++ a/include/linux/llist.h
@@ -158,11 +158,14 @@ static inline void llist_add(struct llis
 	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
-	do {
+	for (;;) {
 		old_entry = entry;
 		new->next = entry;
+		entry = cmpxchg(&head->first, old_entry, new);
+		if (entry == old_entry)
+			break;
 		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
+	}
 }
 
 /**
@@ -180,11 +183,14 @@ static inline void llist_add_batch(struc
 	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
-	do {
+	for (;;) {
 		old_entry = entry;
 		new_last->next = entry;
+		entry = cmpxchg(&head->first, old_entry, new_first);
+		if (entry == old_entry)
+			break;
 		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
+	}
 }
 
 /**
@@ -208,13 +214,16 @@ static inline struct llist_node *llist_d
 	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
-	do {
+	for (;;) {
 		if (entry == NULL)
 			return NULL;
 		old_entry = entry;
 		next = entry->next;
+		entry = cmpxchg(&head->first, old_entry, next);
+		if (entry == old_entry)
+			break;
 		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
+	}
 
 	return entry;
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch

