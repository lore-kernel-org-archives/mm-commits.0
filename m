From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:37 -0800
Message-ID: <20130228004938.62F2731C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45231 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3B1Atj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:39 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so155983qaj.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, peter.senna@gmail.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

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
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

