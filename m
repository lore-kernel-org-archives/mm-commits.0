From: akpm@linux-foundation.org
Subject: + cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch added to -mm tree
Date: Wed, 19 May 2010 14:37:25 -0700
Message-ID: <201005192137.o4JLbP0d007467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab0ESVh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 17:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com


The patch titled
     add numa_random() stub for non-NUMA build
has been added to the -mm tree.  Its filename is
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch

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
Subject: add numa_random() stub for non-NUMA build
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Against 2.6.34-rc7-mmotm-100514-1333:

Define stub numa_random() for !NUMA configuration.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
+++ a/include/linux/nodemask.h
@@ -269,9 +269,6 @@ static inline int __first_unset_node(con
 			find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
-#define node_random(mask) __node_random(&(mask))
-extern int __node_random(const nodemask_t *maskp);
-
 #define NODE_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(MAX_NUMNODES)
 
 #if MAX_NUMNODES <= BITS_PER_LONG
@@ -435,6 +432,10 @@ static inline void node_set_offline(int 
 	node_clear_state(nid, N_ONLINE);
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
+
+#define node_random(mask) __node_random(&(mask))
+extern int __node_random(const nodemask_t *maskp);
+
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -465,6 +466,8 @@ static inline int num_node_state(enum no
 
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
+
+static inline int node_random(const nodemask_t mask) { return 0; }
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-page_check_references-check-low-order-lumpy-reclaim-properly.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly-update.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch

