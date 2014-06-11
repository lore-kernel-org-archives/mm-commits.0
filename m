From: akpm@linux-foundation.org
Subject: + klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch added to -mm tree
Date: Wed, 11 Jun 2014 14:05:41 -0700
Message-ID: <5398c4a5.ea1C8UtOGp8wA3Cu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaFKVFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, jeffrey.t.kirsher@intel.com, hughd@google.com, hch@infradead.org, kenhelias@firemail.de

Subject: + klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch added to -mm tree
To: kenhelias@firemail.de,hch@infradead.org,hughd@google.com,jeffrey.t.kirsher@intel.com,paulmck@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:05:41 -0700


The patch titled
     Subject: klist: use same naming scheme as hlist for klist_add_after()
has been added to the -mm tree.  Its filename is
     klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch

