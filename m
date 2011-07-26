From: akpm@linux-foundation.org
Subject: [folded] cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:55:14 -0700
Message-ID: <201107262255.p6QMtEee014528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859Ab1GZWz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux-foundation.org, holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, mhocko@suse.cz, penberg@cs.helsinki.fir


The patch titled
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
has been removed from the -mm tree.  Its filename was
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch

This patch was dropped because it was folded into cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

fix CONFIG_NUMA=y, MAX_NUMNODES>1 build

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Menage <menage@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
+++ a/include/linux/nodemask.h
@@ -433,8 +433,6 @@ static inline void node_set_offline(int 
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
 
-extern int node_random(const nodemask_t *maskp);
-
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -466,7 +464,15 @@ static inline int num_node_state(enum no
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
 
-static inline int node_random(const nodemask_t *mask) { return 0; }
+#endif
+
+#if defined(CONFIG_NUMA) && (MAX_NUMNODES > 1)
+extern int node_random(const nodemask_t *maskp);
+#else
+static inline int node_random(const nodemask_t *mask)
+{
+	return 0;
+}
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

