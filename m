From: akpm@linux-foundation.org
Subject: + hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch added to -mm tree
Date: Thu, 07 Feb 2013 13:37:13 -0800
Message-ID: <20130207213714.3DEB51CA1CE@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:53387 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161031Ab3BGVhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 16:37:17 -0500
Received: by mail-la0-f73.google.com with SMTP id eb20so194906lab.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 13:37:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, peter.senna@gmail.com, sasha.levin@oracle.com


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

ERROR: code indent should use tabs where possible
#939: FILE: drivers/atm/atmtcp.c:270:
+        sk_for_each(s, head) {$

WARNING: please, no spaces at the start of a line
#939: FILE: drivers/atm/atmtcp.c:270:
+        sk_for_each(s, head) {$

ERROR: space required before the open brace '{'
#2295: FILE: fs/dlm/lowcomms.c:238:
+		hlist_for_each_entry_safe(con, n, &connection_hash[i], list){

WARNING: line over 80 characters
#3070: FILE: include/linux/hashtable.h:122:
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\

WARNING: line over 80 characters
#3084: FILE: include/linux/hashtable.h:132:
+#define hash_for_each_rcu(name, bkt, obj, member)				\

WARNING: line over 80 characters
#3085: FILE: include/linux/hashtable.h:133:
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\

WARNING: line over 80 characters
#3102: FILE: include/linux/hashtable.h:146:
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\

WARNING: line over 80 characters
#3132: FILE: include/linux/hashtable.h:170:
+	hlist_for_each_entry_rcu(obj, &name[hash_min(key, HASH_BITS(name))], member)

WARNING: line over 80 characters
#3147: FILE: include/linux/hashtable.h:181:
+#define hash_for_each_possible_safe(name, obj, tmp, member, key)		\

WARNING: line over 80 characters
#3148: FILE: include/linux/hashtable.h:182:
+	hlist_for_each_entry_safe(obj, tmp, &name[hash_min(key, HASH_BITS(name))], member)

ERROR: Macros with complex values should be enclosed in parenthesis
#3188: FILE: include/linux/list.h:669:
+#define hlist_entry_safe(ptr, type, member) \
+	(ptr) ? hlist_entry(ptr, type, member) : NULL

WARNING: line over 80 characters
#3204: FILE: include/linux/list.h:678:
+#define hlist_for_each_entry(pos, head, member)					\

WARNING: line over 80 characters
#3205: FILE: include/linux/list.h:679:
+	for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);	\

WARNING: line over 80 characters
#3206: FILE: include/linux/list.h:680:
+	     pos;								\

WARNING: line over 80 characters
#3221: FILE: include/linux/list.h:688:
+#define hlist_for_each_entry_continue(pos, member)				\

WARNING: line over 80 characters
#3222: FILE: include/linux/list.h:689:
+	for (pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member);\

WARNING: line over 80 characters
#3223: FILE: include/linux/list.h:690:
+	     pos;								\

WARNING: line over 80 characters
#3255: FILE: include/linux/list.h:709:
+#define hlist_for_each_entry_safe(pos, n, head, member) 			\

WARNING: please, no space before tabs
#3255: FILE: include/linux/list.h:709:
+#define hlist_for_each_entry_safe(pos, n, head, member) ^I^I^I\$

WARNING: line over 80 characters
#3256: FILE: include/linux/list.h:710:
+	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);	\

WARNING: line over 80 characters
#3257: FILE: include/linux/list.h:711:
+	     pos && ({ n = pos->member.next; 1; });				\

WARNING: line over 80 characters
#3297: FILE: include/linux/rculist.h:456:
+#define hlist_for_each_entry_rcu(pos, head, member)				\

WARNING: line over 80 characters
#3298: FILE: include/linux/rculist.h:457:
+	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\

WARNING: space prohibited between function name and open parenthesis '('
#3298: FILE: include/linux/rculist.h:457:
+	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\

WARNING: line over 80 characters
#3299: FILE: include/linux/rculist.h:458:
+			typeof(*(pos)), member);				\

WARNING: line over 80 characters
#3300: FILE: include/linux/rculist.h:459:
+		pos;								\

WARNING: line over 80 characters
#3301: FILE: include/linux/rculist.h:460:
+		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(	\

WARNING: line over 80 characters
#3321: FILE: include/linux/rculist.h:473:
+#define hlist_for_each_entry_rcu_bh(pos, head, member)				\

WARNING: line over 80 characters
#3322: FILE: include/linux/rculist.h:474:
+	for (pos = hlist_entry_safe(rcu_dereference_bh(hlist_first_rcu(head)),	\

WARNING: line over 80 characters
#3323: FILE: include/linux/rculist.h:475:
+			typeof(*(pos)), member);				\

WARNING: line over 80 characters
#3324: FILE: include/linux/rculist.h:476:
+		pos;								\

WARNING: line over 80 characters
#3325: FILE: include/linux/rculist.h:477:
+		pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(	\

WARNING: line over 80 characters
#3340: FILE: include/linux/rculist.h:485:
+#define hlist_for_each_entry_continue_rcu(pos, member)				\

WARNING: line over 80 characters
#3341: FILE: include/linux/rculist.h:486:
+	for (pos = hlist_entry_safe(rcu_dereference((pos)->member.next),	\

WARNING: line over 80 characters
#3342: FILE: include/linux/rculist.h:487:
+			typeof(*(pos)), member);				\

WARNING: line over 80 characters
#3343: FILE: include/linux/rculist.h:488:
+	     pos;								\

WARNING: line over 80 characters
#3344: FILE: include/linux/rculist.h:489:
+	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),	\

ERROR: code indent should use tabs where possible
#3345: FILE: include/linux/rculist.h:490:
+^I     ^I^Itypeof(*(pos)), member))$

WARNING: please, no space before tabs
#3345: FILE: include/linux/rculist.h:490:
+^I     ^I^Itypeof(*(pos)), member))$

WARNING: line over 80 characters
#3359: FILE: include/linux/rculist.h:497:
+#define hlist_for_each_entry_continue_rcu_bh(pos, member)			\

WARNING: line over 80 characters
#3360: FILE: include/linux/rculist.h:498:
+	for (pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),	\

WARNING: line over 80 characters
#3361: FILE: include/linux/rculist.h:499:
+			typeof(*(pos)), member);				\

WARNING: line over 80 characters
#3362: FILE: include/linux/rculist.h:500:
+	     pos;								\

WARNING: line over 80 characters
#3363: FILE: include/linux/rculist.h:501:
+	     pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),	\

ERROR: code indent should use tabs where possible
#3364: FILE: include/linux/rculist.h:502:
+^I     ^I^Itypeof(*(pos)), member))$

WARNING: please, no space before tabs
#3364: FILE: include/linux/rculist.h:502:
+^I     ^I^Itypeof(*(pos)), member))$

ERROR: do not use C99 // comments
#3817: FILE: kernel/smpboot.c:134:
+		//BUG_ON(td->cpu != smp_processor_id());

ERROR: do not use C99 // comments
#4452: FILE: net/9p/trans_virtio.c:658:
+	//.zc_request = p9_virtio_zc_request,

WARNING: line over 80 characters
#7049: FILE: net/decnet/af_decnet.c:418:
+	sk_for_each(sk, &dn_sk_hash[le16_to_cpu(cb->dst_port) & DN_SK_HASH_MASK]) {

WARNING: space prohibited between function name and open parenthesis '('
#7696: FILE: net/ipv4/raw.c:123:
+	sk_for_each_from (sk) {

ERROR: spaces required around that '=' (ctx:VxV)
#7697: FILE: net/ipv4/raw.c:124:
+		struct inet_sock *inet=inet_sk(sk);
 		                      ^

WARNING: line over 80 characters
#7698: FILE: net/ipv4/raw.c:125:
+		if (net_eq(sock_net(sk), net) && inet->inet_num == num && !(inet->inet_daddr && inet->inet_daddr != raddr) && !(inet->inet_rcv_saddr && inet->inet_rcv_saddr != laddr) && !(sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif))

WARNING: space prohibited between function name and open parenthesis '('
#8085: FILE: net/ipv6/raw.c:100:
+		sk_for_each_from (sk)

ERROR: spaces required around that '=' (ctx:VxV)
#8087: FILE: net/ipv6/raw.c:102:
+				struct ipv6_pinfo *np=inet6_sk(sk);
 				                     ^

WARNING: line over 80 characters
#8090: FILE: net/ipv6/raw.c:105:
+					if (!ipv6_addr_any(&np->daddr) && !ipv6_addr_equal(&np->daddr, rmt_addr))

WARNING: line over 80 characters
#8092: FILE: net/ipv6/raw.c:107:
+						if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)

WARNING: Too many leading tabs - consider code refactoring
#8092: FILE: net/ipv6/raw.c:107:
+						if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)

WARNING: line over 80 characters
#8094: FILE: net/ipv6/raw.c:109:
+							if (!ipv6_addr_any(&np->rcv_saddr)) {

WARNING: Too many leading tabs - consider code refactoring
#8094: FILE: net/ipv6/raw.c:109:
+							if (!ipv6_addr_any(&np->rcv_saddr)) {

WARNING: line over 80 characters
#8095: FILE: net/ipv6/raw.c:110:
+								if (ipv6_addr_equal(&np->rcv_saddr, loc_addr))

WARNING: Too many leading tabs - consider code refactoring
#8095: FILE: net/ipv6/raw.c:110:
+								if (ipv6_addr_equal(&np->rcv_saddr, loc_addr))

WARNING: line over 80 characters
#8096: FILE: net/ipv6/raw.c:111:
+									goto found;

WARNING: line over 80 characters
#8097: FILE: net/ipv6/raw.c:112:
+									if (is_multicast && inet6_mc_check(sk, loc_addr, rmt_addr))

WARNING: Too many leading tabs - consider code refactoring
#8097: FILE: net/ipv6/raw.c:112:
+									if (is_multicast && inet6_mc_check(sk, loc_addr, rmt_addr))

WARNING: line over 80 characters
#8098: FILE: net/ipv6/raw.c:113:
+										goto found;

WARNING: line over 80 characters
#8099: FILE: net/ipv6/raw.c:114:
+										continue;

WARNING: line over 80 characters
#8101: FILE: net/ipv6/raw.c:116:
+									goto found;

WARNING: line over 80 characters
#8413: FILE: net/l2tp/l2tp_core.c:285:
+		hlist_for_each_entry(session, &tunnel->session_hlist[hash], hlist) {

WARNING: line over 80 characters
#8427: FILE: net/l2tp/l2tp_core.c:310:
+		hlist_for_each_entry_rcu(session, &pn->l2tp_session_hlist[hash], global_hlist) {

total: 9 errors, 60 warnings, 9471 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/hlist-drop-the-node-parameter-from-iterators.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/atmtcp.c      |    2 -
 fs/dlm/lowcomms.c         |    3 --
 include/linux/hashtable.h |   19 +++++++++++-------
 include/linux/list.h      |   16 +++++++--------
 include/linux/rculist.h   |   38 ++++++++++++++++++------------------
 5 files changed, 41 insertions(+), 37 deletions(-)

diff -puN drivers/atm/atmtcp.c~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes drivers/atm/atmtcp.c
--- a/drivers/atm/atmtcp.c~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
+++ a/drivers/atm/atmtcp.c
@@ -267,7 +267,7 @@ static struct atm_vcc *find_vcc(struct a
 
         head = &vcc_hash[vci & (VCC_HTABLE_SIZE -1)];
 
-        sk_for_each(s, head) {
+	sk_for_each(s, head) {
                 vcc = atm_sk(s);
                 if (vcc->dev == dev &&
                     vcc->vci == vci && vcc->vpi == vpi &&
diff -puN fs/dlm/lowcomms.c~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
+++ a/fs/dlm/lowcomms.c
@@ -235,9 +235,8 @@ static void foreach_conn(void (*conn_fun
 	struct connection *con;
 
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_safe(con, n, &connection_hash[i], list){
+		hlist_for_each_entry_safe(con, n, &connection_hash[i], list)
 			conn_func(con);
-		}
 	}
 }
 
diff -puN include/linux/hashtable.h~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes include/linux/hashtable.h
--- a/include/linux/hashtable.h~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
+++ a/include/linux/hashtable.h
@@ -119,7 +119,8 @@ static inline void hash_del_rcu(struct h
  * @member: the name of the hlist_node within the struct
  */
 #define hash_for_each(name, bkt, obj, member)				\
-	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name);\
+			(bkt)++)\
 		hlist_for_each_entry(obj, &name[bkt], member)
 
 /**
@@ -129,8 +130,9 @@ static inline void hash_del_rcu(struct h
  * @obj: the type * to use as a loop cursor for each entry
  * @member: the name of the hlist_node within the struct
  */
-#define hash_for_each_rcu(name, bkt, obj, member)				\
-	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\
+#define hash_for_each_rcu(name, bkt, obj, member)			\
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name);\
+			(bkt)++)\
 		hlist_for_each_entry_rcu(obj, &name[bkt], member)
 
 /**
@@ -143,7 +145,8 @@ static inline void hash_del_rcu(struct h
  * @member: the name of the hlist_node within the struct
  */
 #define hash_for_each_safe(name, bkt, tmp, obj, member)			\
-	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name);\
+			(bkt)++)\
 		hlist_for_each_entry_safe(obj, tmp, &name[bkt], member)
 
 /**
@@ -167,7 +170,8 @@ static inline void hash_del_rcu(struct h
  * @key: the key of the objects to iterate over
  */
 #define hash_for_each_possible_rcu(name, obj, member, key)		\
-	hlist_for_each_entry_rcu(obj, &name[hash_min(key, HASH_BITS(name))], member)
+	hlist_for_each_entry_rcu(obj, &name[hash_min(key, HASH_BITS(name))],\
+		member)
 
 /**
  * hash_for_each_possible_safe - iterate over all possible objects hashing to the
@@ -178,8 +182,9 @@ static inline void hash_del_rcu(struct h
  * @member: the name of the hlist_node within the struct
  * @key: the key of the objects to iterate over
  */
-#define hash_for_each_possible_safe(name, obj, tmp, member, key)		\
-	hlist_for_each_entry_safe(obj, tmp, &name[hash_min(key, HASH_BITS(name))], member)
+#define hash_for_each_possible_safe(name, obj, tmp, member, key)	\
+	hlist_for_each_entry_safe(obj, tmp,\
+		&name[hash_min(key, HASH_BITS(name))], member)
 
 
 #endif
diff -puN include/linux/list.h~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes include/linux/list.h
--- a/include/linux/list.h~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
+++ a/include/linux/list.h
@@ -675,9 +675,9 @@ static inline void hlist_move_list(struc
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry(pos, head, member)					\
-	for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);	\
-	     pos;								\
+#define hlist_for_each_entry(pos, head, member)				\
+	for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
+	     pos;							\
 	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
 /**
@@ -685,9 +685,9 @@ static inline void hlist_move_list(struc
  * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue(pos, member)				\
+#define hlist_for_each_entry_continue(pos, member)			\
 	for (pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member);\
-	     pos;								\
+	     pos;							\
 	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
 /**
@@ -706,9 +706,9 @@ static inline void hlist_move_list(struc
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_safe(pos, n, head, member) 			\
-	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);	\
-	     pos && ({ n = pos->member.next; 1; });				\
+#define hlist_for_each_entry_safe(pos, n, head, member) 		\
+	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
+	     pos && ({ n = pos->member.next; 1; });			\
 	     pos = hlist_entry_safe(n, typeof(*pos), member))
 
 #endif
diff -puN include/linux/rculist.h~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes include/linux/rculist.h
--- a/include/linux/rculist.h~hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
+++ a/include/linux/rculist.h
@@ -453,11 +453,11 @@ static inline void hlist_add_after_rcu(s
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(pos, head, member)				\
+#define hlist_for_each_entry_rcu(pos, head, member)			\
 	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
-			typeof(*(pos)), member);				\
-		pos;								\
-		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(	\
+			typeof(*(pos)), member);			\
+		pos;							\
+		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
 			&(pos)->member)), typeof(*(pos)), member))
 
 /**
@@ -470,11 +470,11 @@ static inline void hlist_add_after_rcu(s
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu_bh(pos, head, member)				\
-	for (pos = hlist_entry_safe(rcu_dereference_bh(hlist_first_rcu(head)),	\
-			typeof(*(pos)), member);				\
-		pos;								\
-		pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(	\
+#define hlist_for_each_entry_rcu_bh(pos, head, member)			\
+	for (pos = hlist_entry_safe(rcu_dereference_bh(hlist_first_rcu(head)),\
+			typeof(*(pos)), member);			\
+		pos;							\
+		pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(\
 			&(pos)->member)), typeof(*(pos)), member))
 
 /**
@@ -482,11 +482,11 @@ static inline void hlist_add_after_rcu(s
  * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue_rcu(pos, member)				\
-	for (pos = hlist_entry_safe(rcu_dereference((pos)->member.next),	\
-			typeof(*(pos)), member);				\
-	     pos;								\
-	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),	\
+#define hlist_for_each_entry_continue_rcu(pos, member)			\
+	for (pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
+			typeof(*(pos)), member);			\
+	     pos;							\
+	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
 	     		typeof(*(pos)), member))
 
 /**
@@ -494,11 +494,11 @@ static inline void hlist_add_after_rcu(s
  * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue_rcu_bh(pos, member)			\
-	for (pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),	\
-			typeof(*(pos)), member);				\
-	     pos;								\
-	     pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),	\
+#define hlist_for_each_entry_continue_rcu_bh(pos, member)		\
+	for (pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
+			typeof(*(pos)), member);			\
+	     pos;							\
+	     pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
 	     		typeof(*(pos)), member))
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

