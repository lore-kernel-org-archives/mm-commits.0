From: akpm@linux-foundation.org
Subject: + llist-move-cpu_relax-after-cmpxchg.patch added to -mm tree
Date: Tue, 06 Sep 2011 14:37:12 -0700
Message-ID: <201109062137.p86LbCpa002604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1IFVhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 17:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, andi@firstfloor.org, mathieu.desnoyers@efficios.com, peterz@infradead.org


The patch titled
     llist: move cpu_relax after cmpxchg
has been added to the -mm tree.  Its filename is
     llist-move-cpu_relax-after-cmpxchg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: llist: move cpu_relax after cmpxchg
From: Huang Ying <ying.huang@intel.com>

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
@@ -156,11 +156,14 @@ static inline void llist_add(struct llis
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
@@ -178,11 +181,14 @@ static inline void llist_add_batch(struc
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
@@ -206,13 +212,16 @@ static inline struct llist_node *llist_d
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

llist-make-all-llist-functions-inline.patch
llist-define-macro-to-check-nmi-safe-cmpxchg.patch
llist-move-cpu_relax-after-cmpxchg.patch
kernel-irq_workc-use-llist-in-irq_work.patch
net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch

