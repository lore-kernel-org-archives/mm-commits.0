From: akpm@linux-foundation.org
Subject: - list_for_each_rcu-must-die-networking.patch removed from -mm tree
Date: Wed, 14 May 2008 13:54:55 -0700
Message-ID: <200805142054.m4EKstwh020325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbYENVH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     list_for_each_rcu() must die: networking
has been removed from the -mm tree.  Its filename was
     list_for_each_rcu-must-die-networking.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list_for_each_rcu() must die: networking
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

All uses of list_for_each_rcu() can be profitably replaced by the
easier-to-use list_for_each_entry_rcu().  This patch makes this change for
networking, in preparation for removing the list_for_each_rcu() API entirely.

Acked-by: David S. Miller <davem@davemloft.net>
Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/802/psnap.c     |    4 +---
 net/ipv4/af_inet.c  |    4 +---
 net/ipv6/af_inet6.c |    4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff -puN net/802/psnap.c~list_for_each_rcu-must-die-networking net/802/psnap.c
--- a/net/802/psnap.c~list_for_each_rcu-must-die-networking
+++ a/net/802/psnap.c
@@ -31,11 +31,9 @@ static struct llc_sap *snap_sap;
  */
 static struct datalink_proto *find_snap_client(unsigned char *desc)
 {
-	struct list_head *entry;
 	struct datalink_proto *proto = NULL, *p;
 
-	list_for_each_rcu(entry, &snap_list) {
-		p = list_entry(entry, struct datalink_proto, node);
+	list_for_each_entry_rcu(p, &snap_list, node) {
 		if (!memcmp(p->type, desc, 5)) {
 			proto = p;
 			break;
diff -puN net/ipv4/af_inet.c~list_for_each_rcu-must-die-networking net/ipv4/af_inet.c
--- a/net/ipv4/af_inet.c~list_for_each_rcu-must-die-networking
+++ a/net/ipv4/af_inet.c
@@ -267,7 +267,6 @@ static inline int inet_netns_ok(struct n
 static int inet_create(struct net *net, struct socket *sock, int protocol)
 {
 	struct sock *sk;
-	struct list_head *p;
 	struct inet_protosw *answer;
 	struct inet_sock *inet;
 	struct proto *answer_prot;
@@ -288,8 +287,7 @@ static int inet_create(struct net *net, 
 lookup_protocol:
 	err = -ESOCKTNOSUPPORT;
 	rcu_read_lock();
-	list_for_each_rcu(p, &inetsw[sock->type]) {
-		answer = list_entry(p, struct inet_protosw, list);
+	list_for_each_entry_rcu(answer, &inetsw[sock->type], list) {
 
 		/* Check the non-wild match. */
 		if (protocol == answer->protocol) {
diff -puN net/ipv6/af_inet6.c~list_for_each_rcu-must-die-networking net/ipv6/af_inet6.c
--- a/net/ipv6/af_inet6.c~list_for_each_rcu-must-die-networking
+++ a/net/ipv6/af_inet6.c
@@ -87,7 +87,6 @@ static int inet6_create(struct net *net,
 	struct inet_sock *inet;
 	struct ipv6_pinfo *np;
 	struct sock *sk;
-	struct list_head *p;
 	struct inet_protosw *answer;
 	struct proto *answer_prot;
 	unsigned char answer_flags;
@@ -105,8 +104,7 @@ static int inet6_create(struct net *net,
 lookup_protocol:
 	err = -ESOCKTNOSUPPORT;
 	rcu_read_lock();
-	list_for_each_rcu(p, &inetsw6[sock->type]) {
-		answer = list_entry(p, struct inet_protosw, list);
+	list_for_each_entry_rcu(answer, &inetsw6[sock->type], list) {
 
 		/* Check the non-wild match. */
 		if (protocol == answer->protocol) {
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

linux-next.patch
list_for_each_rcu-must-die-networking.patch
git-block.patch

