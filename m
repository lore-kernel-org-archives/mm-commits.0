From: akpm@linux-foundation.org
Subject: + llist-define-macro-to-check-nmi-safe-cmpxchg.patch added to -mm tree
Date: Tue, 06 Sep 2011 14:37:10 -0700
Message-ID: <201109062137.p86LbAhr002598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab1IFVhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 17:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, andi@firstfloor.org, mathieu.desnoyers@efficios.com, peterz@infradead.org


The patch titled
     llist: define macro to check NMI safe cmpxchg
has been added to the -mm tree.  Its filename is
     llist-define-macro-to-check-nmi-safe-cmpxchg.patch

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
Subject: llist: define macro to check NMI safe cmpxchg
From: Huang Ying <ying.huang@intel.com>

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
@@ -70,6 +70,12 @@ struct llist_node {
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
@@ -147,9 +153,7 @@ static inline void llist_add(struct llis
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -171,9 +175,7 @@ static inline void llist_add_batch(struc
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -201,9 +203,7 @@ static inline struct llist_node *llist_d
 {
 	struct llist_node *entry, *old_entry, *next;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -227,9 +227,7 @@ static inline struct llist_node *llist_d
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

llist-make-all-llist-functions-inline.patch
llist-define-macro-to-check-nmi-safe-cmpxchg.patch
llist-move-cpu_relax-after-cmpxchg.patch
kernel-irq_workc-use-llist-in-irq_work.patch
net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch

