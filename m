From: akpm@linux-foundation.org
Subject: [folded] page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:56:40 -0700
Message-ID: <200906162156.n5GLuejS025961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbZFPV51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths: do not override definition of node_set_online() with macro
has been removed from the -mm tree.  Its filename was
     page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch

This patch was dropped because it was folded into page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths: do not override definition of node_set_online() with macro
From: David Rientjes <rientjes@google.com>

Do not override definition of node_set_online() with macro

node_set_online() updates node_states[] and updates the value of
nr_online_nodes.  However, its definition is being accidentally
overridden by a macro definition intended for use in the !CONFIG_NUMA
case.  This patch fixes the problem by moving the !CONFIG_NUMA macro
definition.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/nodemask.h~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro include/linux/nodemask.h
--- a/include/linux/nodemask.h~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro
+++ a/include/linux/nodemask.h
@@ -448,6 +448,9 @@ static inline int num_node_state(enum no
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
 #define nr_online_nodes		1
+
+#define node_set_online(node)	   node_set_state((node), N_ONLINE)
+#define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
@@ -467,9 +470,6 @@ static inline int num_node_state(enum no
 #define node_online(node)	node_state((node), N_ONLINE)
 #define node_possible(node)	node_state((node), N_POSSIBLE)
 
-#define node_set_online(node)	   node_set_state((node), N_ONLINE)
-#define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
