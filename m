From: akpm@linux-foundation.org
Subject: [merged]
 mm-replace-nr_node_ids-for-loop-with-for_each_node-in-list-lru.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:32 -0800
Message-ID: <563d0884.KzJSYffKq853kedg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965967AbbKFUHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raghavendra.kt@linux.vnet.ibm.com, anton@samba.org, benh@kernel.crashing.org, gkurz@linux.vnet.ibm.com, grant.likely@linaro.org, mpe@ellerman.id.au, nacc@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com, paulus@samba.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: replace nr_node_ids for loop with for_each_node()
has been removed from the -mm tree.  Its filename was
     mm-replace-nr_node_ids-for-loop-with-for_each_node-in-list-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: mm/list_lru.c: replace nr_node_ids for loop with for_each_node()

The functions used in the patch are in slowpath, which gets called
whenever alloc_super is called during mounts.

Though this should not make difference for the architectures with
sequential numa node ids, for the powerpc which can potentially have
sparse node ids (for e.g., 4 node system having numa ids, 0,1,16,17 is
common), this patch saves some unnecessary allocations for non existing
numa nodes.

Even without that saving, perhaps patch makes code more readable.

[vdavydov@parallels.com: take memcg_aware check outside for_each loop]
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff -puN mm/list_lru.c~mm-replace-nr_node_ids-for-loop-with-for_each_node-in-list-lru mm/list_lru.c
--- a/mm/list_lru.c~mm-replace-nr_node_ids-for-loop-with-for_each_node-in-list-lru
+++ a/mm/list_lru.c
@@ -42,6 +42,10 @@ static void list_lru_unregister(struct l
 #ifdef CONFIG_MEMCG_KMEM
 static inline bool list_lru_memcg_aware(struct list_lru *lru)
 {
+	/*
+	 * This needs node 0 to be always present, even
+	 * in the systems supporting sparse numa ids.
+	 */
 	return !!lru->node[0].memcg_lrus;
 }
 
@@ -377,16 +381,20 @@ static int memcg_init_list_lru(struct li
 {
 	int i;
 
-	for (i = 0; i < nr_node_ids; i++) {
-		if (!memcg_aware)
-			lru->node[i].memcg_lrus = NULL;
-		else if (memcg_init_list_lru_node(&lru->node[i]))
+	if (!memcg_aware)
+		return 0;
+
+	for_each_node(i) {
+		if (memcg_init_list_lru_node(&lru->node[i]))
 			goto fail;
 	}
 	return 0;
 fail:
-	for (i = i - 1; i >= 0; i--)
+	for (i = i - 1; i >= 0; i--) {
+		if (!lru->node[i].memcg_lrus)
+			continue;
 		memcg_destroy_list_lru_node(&lru->node[i]);
+	}
 	return -ENOMEM;
 }
 
@@ -397,7 +405,7 @@ static void memcg_destroy_list_lru(struc
 	if (!list_lru_memcg_aware(lru))
 		return;
 
-	for (i = 0; i < nr_node_ids; i++)
+	for_each_node(i)
 		memcg_destroy_list_lru_node(&lru->node[i]);
 }
 
@@ -409,16 +417,20 @@ static int memcg_update_list_lru(struct
 	if (!list_lru_memcg_aware(lru))
 		return 0;
 
-	for (i = 0; i < nr_node_ids; i++) {
+	for_each_node(i) {
 		if (memcg_update_list_lru_node(&lru->node[i],
 					       old_size, new_size))
 			goto fail;
 	}
 	return 0;
 fail:
-	for (i = i - 1; i >= 0; i--)
+	for (i = i - 1; i >= 0; i--) {
+		if (!lru->node[i].memcg_lrus)
+			continue;
+
 		memcg_cancel_update_list_lru_node(&lru->node[i],
 						  old_size, new_size);
+	}
 	return -ENOMEM;
 }
 
@@ -430,7 +442,7 @@ static void memcg_cancel_update_list_lru
 	if (!list_lru_memcg_aware(lru))
 		return;
 
-	for (i = 0; i < nr_node_ids; i++)
+	for_each_node(i)
 		memcg_cancel_update_list_lru_node(&lru->node[i],
 						  old_size, new_size);
 }
@@ -485,7 +497,7 @@ static void memcg_drain_list_lru(struct
 	if (!list_lru_memcg_aware(lru))
 		return;
 
-	for (i = 0; i < nr_node_ids; i++)
+	for_each_node(i)
 		memcg_drain_list_lru_node(&lru->node[i], src_idx, dst_idx);
 }
 
@@ -522,7 +534,7 @@ int __list_lru_init(struct list_lru *lru
 	if (!lru->node)
 		goto out;
 
-	for (i = 0; i < nr_node_ids; i++) {
+	for_each_node(i) {
 		spin_lock_init(&lru->node[i].lock);
 		if (key)
 			lockdep_set_class(&lru->node[i].lock, key);
_

Patches currently in -mm which might be from raghavendra.kt@linux.vnet.ibm.com are


