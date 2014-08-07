From: akpm@linux-foundation.org
Subject: [merged]
 klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:07:35 -0700
Message-ID: <53e3dc87.gfii8PiunAM+NhEy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:59849 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbaHGUHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:36 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so839786obb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenhelias@firemail.de, hch@infradead.org, hughd@google.com, jeffrey.t.kirsher@intel.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: klist: use same naming scheme as hlist for klist_add_after()
has been removed from the -mm tree.  Its filename was
     klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ken Helias <kenhelias@firemail.de>
Subject: klist: use same naming scheme as hlist for klist_add_after()

The name was modified from hlist_add_after() to hlist_add_behind() when
adjusting the order of arguments to match the one with klist_add_after(). 
This is necessary to break old code when it would use it the wrong way.

Make klist follow this naming scheme for consistency.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/klist.h |    2 +-
 lib/klist.c           |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/klist.h~klist-use-same-naming-scheme-as-hlist-for-klist_add_after include/linux/klist.h
--- a/include/linux/klist.h~klist-use-same-naming-scheme-as-hlist-for-klist_add_after
+++ a/include/linux/klist.h
@@ -44,7 +44,7 @@ struct klist_node {
 
 extern void klist_add_tail(struct klist_node *n, struct klist *k);
 extern void klist_add_head(struct klist_node *n, struct klist *k);
-extern void klist_add_after(struct klist_node *n, struct klist_node *pos);
+extern void klist_add_behind(struct klist_node *n, struct klist_node *pos);
 extern void klist_add_before(struct klist_node *n, struct klist_node *pos);
 
 extern void klist_del(struct klist_node *n);
diff -puN lib/klist.c~klist-use-same-naming-scheme-as-hlist-for-klist_add_after lib/klist.c
--- a/lib/klist.c~klist-use-same-naming-scheme-as-hlist-for-klist_add_after
+++ a/lib/klist.c
@@ -140,11 +140,11 @@ void klist_add_tail(struct klist_node *n
 EXPORT_SYMBOL_GPL(klist_add_tail);
 
 /**
- * klist_add_after - Init a klist_node and add it after an existing node
+ * klist_add_behind - Init a klist_node and add it after an existing node
  * @n: node we're adding.
  * @pos: node to put @n after
  */
-void klist_add_after(struct klist_node *n, struct klist_node *pos)
+void klist_add_behind(struct klist_node *n, struct klist_node *pos)
 {
 	struct klist *k = knode_klist(pos);
 
@@ -153,7 +153,7 @@ void klist_add_after(struct klist_node *
 	list_add(&n->n_node, &pos->n_node);
 	spin_unlock(&k->k_lock);
 }
-EXPORT_SYMBOL_GPL(klist_add_after);
+EXPORT_SYMBOL_GPL(klist_add_behind);
 
 /**
  * klist_add_before - Init a klist_node and add it before an existing node
_

Patches currently in -mm which might be from kenhelias@firemail.de are

origin.patch

