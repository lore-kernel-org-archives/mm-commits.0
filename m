From: akpm@linux-foundation.org
Subject: + list-remove-explicit-list-prefetches-for-most-cases.patch added to -mm tree
Date: Mon, 13 Sep 2010 16:12:50 -0700
Message-ID: <201009132312.o8DNCoEE026832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0IMXNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 19:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, arjan@infradead.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, paul.moore@hp.com, paulmck@us.ibm.com, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     list: remove explicit list prefetches for most cases
has been added to the -mm tree.  Its filename is
     list-remove-explicit-list-prefetches-for-most-cases.patch

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
Subject: list: remove explicit list prefetches for most cases
From: Andi Kleen <ak@linux.intel.com>

We've had explicit list prefetches in list_for_each and friends for quite
some time.  According to Arjan they were originally added for K7 where
they were a slight win.

It's doubtful they help very much today, especially on newer CPUs with
aggressive prefetching.  Most list_for_eachs bodies are quite short and
the prefetch does not help if it doesn't happen sufficiently in advance or
when the data is not really cache cold.

The feedback from CPU designers is that they don't like us using explicit
prefetches unless there is a very good reason (and list_for_each* alone
clearly isn't one)

Also the prefetches cause the list walks to generate bad code, increase
the number of registers needed.

This adds a new CONFIG symbol CONFIG_LIST_PREFETCH that can be set by the
architecture that controls them.  I introduced a new list_prefetch() macro
for these cases.

This patch changes them to be only enabled on a kernel build for K7 on x86
and turned off everywhere else (including non X86).  An alternative would
be to keep it enabled on non x86, but I suspect the situation is similar
here.

I did a little tree sweep -- there were a couple of copies of
list_prefetch() that I changed all in one go.  Also changed one case in
dcache.c that looked suspicious.  I changed some uses in the network
stack.

I left the majority of other prefetches alone, especially those in device
drivers because in some cases there they can be a large win with cache
cold data.

This shrinks my 64bit slightly larger than defconfig kernel image by about
10K.  I suspect the savings on a full build will be even larger.

   text    data     bss     dec     hex filename
9574616 1096396 1353728 12024740         b77ba4 vmlinux
9583143 1100188 1353728 12037059         b7abc3 vmlinux-prefetch

I ran lmbench3 before/after and there were no significant outliers outside
the usual inaccuracies.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.cpu             |    4 ++++
 fs/dcache.c                      |    2 +-
 include/linux/list.h             |   26 +++++++++++++-------------
 include/linux/prefetch.h         |   10 ++++++++++
 include/linux/rculist.h          |   16 ++++++++--------
 include/linux/skbuff.h           |    7 ++++---
 net/netlabel/netlabel_addrlist.h |    4 ++--
 7 files changed, 42 insertions(+), 27 deletions(-)

diff -puN arch/x86/Kconfig.cpu~list-remove-explicit-list-prefetches-for-most-cases arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu~list-remove-explicit-list-prefetches-for-most-cases
+++ a/arch/x86/Kconfig.cpu
@@ -378,6 +378,10 @@ config X86_OOSTORE
 	def_bool y
 	depends on (MWINCHIP3D || MWINCHIPC6) && MTRR
 
+config LIST_PREFETCH
+	def_bool y
+	depends on MK7
+
 #
 # P6_NOPs are a relatively minor optimization that require a family >=
 # 6 processor, except that it is broken on certain VIA chips.
diff -puN fs/dcache.c~list-remove-explicit-list-prefetches-for-most-cases fs/dcache.c
--- a/fs/dcache.c~list-remove-explicit-list-prefetches-for-most-cases
+++ a/fs/dcache.c
@@ -359,7 +359,7 @@ static struct dentry * __d_find_alias(st
 	while (next != head) {
 		tmp = next;
 		next = tmp->next;
-		prefetch(next);
+		list_prefetch(next);
 		alias = list_entry(tmp, struct dentry, d_alias);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
diff -puN include/linux/list.h~list-remove-explicit-list-prefetches-for-most-cases include/linux/list.h
--- a/include/linux/list.h~list-remove-explicit-list-prefetches-for-most-cases
+++ a/include/linux/list.h
@@ -4,8 +4,8 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/poison.h>
-#include <linux/prefetch.h>
 #include <asm/system.h>
+#include <linux/prefetch.h>
 
 /*
  * Simple doubly linked list implementation.
@@ -362,7 +362,7 @@ static inline void list_splice_tail_init
  * @head:	the head for your list.
  */
 #define list_for_each(pos, head) \
-	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
+	for (pos = (head)->next; list_prefetch(pos->next), pos != (head); \
         	pos = pos->next)
 
 /**
@@ -384,7 +384,7 @@ static inline void list_splice_tail_init
  * @head:	the head for your list.
  */
 #define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; prefetch(pos->prev), pos != (head); \
+	for (pos = (head)->prev; list_prefetch(pos->prev), pos != (head); \
         	pos = pos->prev)
 
 /**
@@ -405,7 +405,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_prev_safe(pos, n, head) \
 	for (pos = (head)->prev, n = pos->prev; \
-	     prefetch(pos->prev), pos != (head); \
+	     list_prefetch(pos->prev), pos != (head); \
 	     pos = n, n = pos->prev)
 
 /**
@@ -416,7 +416,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head); 	\
+	     list_prefetch(pos->member.next), &pos->member != (head); 	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -427,7 +427,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head); 	\
+	     list_prefetch(pos->member.prev), &pos->member != (head); 	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
@@ -452,7 +452,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
 	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head);	\
+	     list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -466,7 +466,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_continue_reverse(pos, head, member)		\
 	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head);	\
+	     list_prefetch(pos->member.prev), &pos->member != (head);	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
@@ -478,7 +478,7 @@ static inline void list_splice_tail_init
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; prefetch(pos->member.next), &pos->member != (head);	\
+	for (; list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -653,7 +653,7 @@ static inline void hlist_move_list(struc
 #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
 
 #define hlist_for_each(pos, head) \
-	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
+	for (pos = (head)->first; pos && ({ list_prefetch(pos->next); 1; }); \
 	     pos = pos->next)
 
 #define hlist_for_each_safe(pos, n, head) \
@@ -669,7 +669,7 @@ static inline void hlist_move_list(struc
  */
 #define hlist_for_each_entry(tpos, pos, head, member)			 \
 	for (pos = (head)->first;					 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+	     pos && ({ list_prefetch(pos->next); 1;}) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
@@ -681,7 +681,7 @@ static inline void hlist_move_list(struc
  */
 #define hlist_for_each_entry_continue(tpos, pos, member)		 \
 	for (pos = (pos)->next;						 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+	     pos && ({ list_prefetch(pos->next); 1;}) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
@@ -692,7 +692,7 @@ static inline void hlist_move_list(struc
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && ({ prefetch(pos->next); 1;}) &&			 \
+	for (; pos && ({ list_prefetch(pos->next); 1;}) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
diff -puN include/linux/prefetch.h~list-remove-explicit-list-prefetches-for-most-cases include/linux/prefetch.h
--- a/include/linux/prefetch.h~list-remove-explicit-list-prefetches-for-most-cases
+++ a/include/linux/prefetch.h
@@ -50,6 +50,16 @@
 #define PREFETCH_STRIDE (4*L1_CACHE_BYTES)
 #endif
 
+/*
+ * Prefetch for list pointer chasing. The architecture defines this
+ * if it believes list prefetches are a good idea on the particular CPU.
+ */
+#ifdef CONFIG_LIST_PREFETCH
+#define list_prefetch(x) prefetch(x)
+#else
+#define list_prefetch(x) ((void)0)
+#endif
+
 static inline void prefetch_range(void *addr, size_t len)
 {
 #ifdef ARCH_HAS_PREFETCH
diff -puN include/linux/rculist.h~list-remove-explicit-list-prefetches-for-most-cases include/linux/rculist.h
--- a/include/linux/rculist.h~list-remove-explicit-list-prefetches-for-most-cases
+++ a/include/linux/rculist.h
@@ -258,7 +258,7 @@ static inline void list_splice_init_rcu(
  */
 #define list_for_each_entry_rcu(pos, head, member) \
 	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
-		prefetch(pos->member.next), &pos->member != (head); \
+		list_prefetch(pos->member.next), &pos->member != (head); \
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 
@@ -275,7 +275,7 @@ static inline void list_splice_init_rcu(
  */
 #define list_for_each_continue_rcu(pos, head) \
 	for ((pos) = rcu_dereference_raw(list_next_rcu(pos)); \
-		prefetch((pos)->next), (pos) != (head); \
+		list_prefetch((pos)->next), (pos) != (head); \
 		(pos) = rcu_dereference_raw(list_next_rcu(pos)))
 
 /**
@@ -289,7 +289,7 @@ static inline void list_splice_init_rcu(
  */
 #define list_for_each_entry_continue_rcu(pos, head, member) 		\
 	for (pos = list_entry_rcu(pos->member.next, typeof(*pos), member); \
-	     prefetch(pos->member.next), &pos->member != (head);	\
+	     list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 /**
@@ -432,7 +432,7 @@ static inline void hlist_add_after_rcu(s
 
 #define __hlist_for_each_rcu(pos, head)				\
 	for (pos = rcu_dereference(hlist_first_rcu(head));	\
-	     pos && ({ prefetch(pos->next); 1; });		\
+	     pos && ({ list_prefetch(pos->next); 1; });		\
 	     pos = rcu_dereference(hlist_next_rcu(pos)))
 
 /**
@@ -448,7 +448,7 @@ static inline void hlist_add_after_rcu(s
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		\
 	for (pos = rcu_dereference_raw(hlist_first_rcu(head));		\
-		pos && ({ prefetch(pos->next); 1; }) &&			 \
+		pos && ({ list_prefetch(pos->next); 1; }) &&		\
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_raw(hlist_next_rcu(pos)))
 
@@ -465,7 +465,7 @@ static inline void hlist_add_after_rcu(s
  */
 #define hlist_for_each_entry_rcu_bh(tpos, pos, head, member)		 \
 	for (pos = rcu_dereference_bh((head)->first);			 \
-		pos && ({ prefetch(pos->next); 1; }) &&			 \
+		pos && ({ list_prefetch(pos->next); 1; }) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_bh(pos->next))
 
@@ -477,7 +477,7 @@ static inline void hlist_add_after_rcu(s
  */
 #define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
 	for (pos = rcu_dereference((pos)->next);			\
-	     pos && ({ prefetch(pos->next); 1; }) &&			\
+	     pos && ({ list_prefetch(pos->next); 1; }) &&		\
 	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
 	     pos = rcu_dereference(pos->next))
 
@@ -489,7 +489,7 @@ static inline void hlist_add_after_rcu(s
  */
 #define hlist_for_each_entry_continue_rcu_bh(tpos, pos, member)		\
 	for (pos = rcu_dereference_bh((pos)->next);			\
-	     pos && ({ prefetch(pos->next); 1; }) &&			\
+	     pos && ({ list_prefetch(pos->next); 1; }) &&		\
 	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
 	     pos = rcu_dereference_bh(pos->next))
 
diff -puN include/linux/skbuff.h~list-remove-explicit-list-prefetches-for-most-cases include/linux/skbuff.h
--- a/include/linux/skbuff.h~list-remove-explicit-list-prefetches-for-most-cases
+++ a/include/linux/skbuff.h
@@ -1761,7 +1761,8 @@ static inline int pskb_trim_rcsum(struct
 
 #define skb_queue_walk(queue, skb) \
 		for (skb = (queue)->next;					\
-		     prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
+		     list_prefetch(skb->next), \
+		     (skb != (struct sk_buff *)(queue));	\
 		     skb = skb->next)
 
 #define skb_queue_walk_safe(queue, skb, tmp)					\
@@ -1770,7 +1771,7 @@ static inline int pskb_trim_rcsum(struct
 		     skb = tmp, tmp = skb->next)
 
 #define skb_queue_walk_from(queue, skb)						\
-		for (; prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
+		for (; list_prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
 		     skb = skb->next)
 
 #define skb_queue_walk_from_safe(queue, skb, tmp)				\
@@ -1780,7 +1781,7 @@ static inline int pskb_trim_rcsum(struct
 
 #define skb_queue_reverse_walk(queue, skb) \
 		for (skb = (queue)->prev;					\
-		     prefetch(skb->prev), (skb != (struct sk_buff *)(queue));	\
+		     list_prefetch(skb->prev), (skb != (struct sk_buff *)(queue));	\
 		     skb = skb->prev)
 
 
diff -puN net/netlabel/netlabel_addrlist.h~list-remove-explicit-list-prefetches-for-most-cases net/netlabel/netlabel_addrlist.h
--- a/net/netlabel/netlabel_addrlist.h~list-remove-explicit-list-prefetches-for-most-cases
+++ a/net/netlabel/netlabel_addrlist.h
@@ -96,12 +96,12 @@ static inline struct netlbl_af4list *__a
 
 #define netlbl_af4list_foreach(iter, head)				\
 	for (iter = __af4list_valid((head)->next, head);		\
-	     prefetch(iter->list.next), &iter->list != (head);		\
+	     list_prefetch(iter->list.next), &iter->list != (head);	\
 	     iter = __af4list_valid(iter->list.next, head))
 
 #define netlbl_af4list_foreach_rcu(iter, head)				\
 	for (iter = __af4list_valid_rcu((head)->next, head);		\
-	     prefetch(iter->list.next),	&iter->list != (head);		\
+	     list_prefetch(iter->list.next), &iter->list != (head);	\
 	     iter = __af4list_valid_rcu(iter->list.next, head))
 
 #define netlbl_af4list_foreach_safe(iter, tmp, head)			\
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
list-remove-explicit-list-prefetches-for-most-cases.patch

