From: akpm@google.com
Subject: [merged] llist-define-macro-to-check-nmi-safe-cmpxchg.patch removed from -mm tree
Date: Wed, 05 Oct 2011 12:12:46 -0700
Message-ID: <201110051912.p95JCkgq029391@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934720Ab1JETNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, andi@firstfloor.org, mathieu.desnoyers@efficios.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: llist: define macro to check NMI safe cmpxchg
has been removed from the -mm tree.  Its filename was
     llist-define-macro-to-check-nmi-safe-cmpxchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: llist: define macro to check NMI safe cmpxchg

To make code cleaner and reduce code duplication.  Thanks Peter
Zijlstra for reminding.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN include/linux/llist.h~llist-define-macro-to-check-nmi-safe-cmpxchg include/linux/llist.h
--- a/include/linux/llist.h~llist-define-macro-to-check-nmi-safe-cmpxchg
+++ a/include/linux/llist.h
@@ -72,6 +72,12 @@ struct llist_node {
 #define LLIST_HEAD_INIT(name)	{ NULL }
 #define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
 
+#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+#define CHECK_NMI_SAFE_CMPXCHG()
+#else
+#define CHECK_NMI_SAFE_CMPXCHG()	BUG_ON(in_nmi())
+#endif
+
 /**
  * init_llist_head - initialize lock-less list head
  * @head:	the head for your lock-less list
@@ -149,9 +155,7 @@ static inline void llist_add(struct llis
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -173,9 +177,7 @@ static inline void llist_add_batch(struc
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -203,9 +205,7 @@ static inline struct llist_node *llist_d
 {
 	struct llist_node *entry, *old_entry, *next;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -229,9 +229,7 @@ static inline struct llist_node *llist_d
  */
 static inline struct llist_node *llist_del_all(struct llist_head *head)
 {
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	return xchg(&head->first, NULL);
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch

