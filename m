From: akpm@linux-foundation.org
Subject: + nodemaskh-remove-macro-any_online_node.patch added to -mm tree
Date: Mon, 11 Jan 2010 15:08:46 -0800
Message-ID: <201001112308.o0BN8krI001662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab0AKXKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 18:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, Ricardo.Labiaga@netapp.com, Trond.Myklebust@netapp.com, benh@kernel.crashing.org, bfields@fieldses.org, bhalevy@panasas.com, chuck.lever@oracle.com, dave@linux.vnet.ibm.com, davem@davemloft.net, geoffrey.levand@am.sony.com, grant.likely@secretlab.ca, hsweeten@visionengravers.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, miltonm@bga.com, neilb@suse.de, nfont@austin.ibm.com, paulus@samba.org, rientjes@google.com


The patch titled
     nodemask.h: remove macro any_online_node
has been added to the -mm tree.  Its filename is
     nodemaskh-remove-macro-any_online_node.patch

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
Subject: nodemask.h: remove macro any_online_node
From: H Hartley Sweeten <hartleys@visionengravers.com>

The macro any_online_node() is prone to producing sparse warnings due to
the local symbol 'node'.  Since all the in-tree users are really
requesting the first online node (the mask argument is either
NODE_MASK_ALL or node_online_map) just use the first_online_node macro and
remove the any_online_node macro since there are no users.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c   |    6 +++---
 include/linux/nodemask.h |   11 -----------
 net/sunrpc/svc.c         |    2 +-
 3 files changed, 4 insertions(+), 15 deletions(-)

diff -puN arch/powerpc/mm/numa.c~nodemaskh-remove-macro-any_online_node arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~nodemaskh-remove-macro-any_online_node
+++ a/arch/powerpc/mm/numa.c
@@ -451,7 +451,7 @@ static int __cpuinit numa_setup_cpu(unsi
 	nid = of_node_to_nid_single(cpu);
 
 	if (nid < 0 || !node_online(nid))
-		nid = any_online_node(NODE_MASK_ALL);
+		nid = first_online_node;
 out:
 	map_cpu_to_node(lcpu, nid);
 
@@ -1114,7 +1114,7 @@ int hot_add_scn_to_nid(unsigned long scn
 	int nid, found = 0;
 
 	if (!numa_enabled || (min_common_depth < 0))
-		return any_online_node(NODE_MASK_ALL);
+		return first_online_node;
 
 	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
 	if (memory) {
@@ -1125,7 +1125,7 @@ int hot_add_scn_to_nid(unsigned long scn
 	}
 
 	if (nid < 0 || !node_online(nid))
-		nid = any_online_node(NODE_MASK_ALL);
+		nid = first_online_node;
 
 	if (NODE_DATA(nid)->node_spanned_pages)
 		return nid;
diff -puN include/linux/nodemask.h~nodemaskh-remove-macro-any_online_node include/linux/nodemask.h
--- a/include/linux/nodemask.h~nodemaskh-remove-macro-any_online_node
+++ a/include/linux/nodemask.h
@@ -69,8 +69,6 @@
  * int node_online(node)		Is some node online?
  * int node_possible(node)		Is some node possible?
  *
- * int any_online_node(mask)		First online node in mask
- *
  * node_set_online(node)		set bit 'node' in node_online_map
  * node_set_offline(node)		clear bit 'node' in node_online_map
  *
@@ -467,15 +465,6 @@ static inline int num_node_state(enum no
 #define node_online_map 	node_states[N_ONLINE]
 #define node_possible_map 	node_states[N_POSSIBLE]
 
-#define any_online_node(mask)			\
-({						\
-	int node;				\
-	for_each_node_mask(node, (mask))	\
-		if (node_online(node))		\
-			break;			\
-	node;					\
-})
