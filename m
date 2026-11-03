Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728665;
	b=tdWkMtEJhXK8OgrYBwUI4NyWk+XluZqOYBIB2jLViAqtm2FLrcGbcOs/lusuXRoYgFUf
	 YZAwv1ElS9SEHBhgUZ/PoOx1orMZiaMHHD75qUVmXfhRCdFnViWRxh8FFV/06NaCgOcj1
	 6Jpwb0r/RzIOhc9r8Jynfg5l8Yj66FJiDWwJl8r+rYqJ1eCeT8MLAtj8DUtWpBTQqIUg5
	 w85Aiz0NS9VqwspdVIsK8Q9u2lhlosGBSVSNpdSLp4OWm43QyHZcdolmB/6ljSAzhmim2
	 vF1HjFXyhlUYOpa/rg7zvPhk6k0QnIj2U2tY4ieJUg1Z3wM5sV6R9GznUgdDlmDQVXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728665;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IR3wRMkoqjN/L1Uv4/HXHuE/fr3BuX/9hKJmxLkXs08=;
	b=XSASbJsml287HzJt2aiQxlSIsiSDAh9DO6HrU9uEOqFRNCCBVHBlxIwYEF9d1sZH65H6
	 sMXTIHbAn77MrDFeMDMWzTHXrAEFNVKwRXXAe2/Iv7maHKdbJxY3OEClTXTe4nfTIFn4H
	 N6yAmQDic5V9XTtMrRCayRsUgCWnyXB7qLTcMED+iFvhSjp7LvUxDpz2pLzKu/wfA1htZ
	 skb4UiJ3orslTJZm3YznrtBw7jQ16Q5aP6imWM8LPRE4dRo72HXgXTJfMVnyrIH0obCDJ
	 G68tDwsZrWFbLc8PnRjI4FujwWjFIjtTw6KHdmydwnRy09FOnqbMaisC14KyByeJOkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DtPVXPkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50523606A33B;
	Tue,  3 Nov 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DtPVXPkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45BA1F000C1;
	Tue,  3 Nov 2026 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793728665;
	bh=IR3wRMkoqjN/L1Uv4/HXHuE/fr3BuX/9hKJmxLkXs08=;
	h=Date:To:From:Subject;
	b=DtPVXPkgeNf1iLOPGAfi8XSoCkwzhFIKR9z57dca7HOynCT98fIak3ubN+B8/E/xR
	 rxP5Fbe1/gMDm9055yjKi4s52ze4NUJ1rWnHJHyd3kVp/JyY+wFkM6rUHoHuA3FhKj
	 h11V0aSc4YaRwN284M3iIm0PX8Rmyn3U1IyIPbao=
Date: Tue, 03 Nov 2026 09:57:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	stable@vger.kernel.org,rakie.kim@sk.com,joshua.hahnjy@gmail.com,
	harry@kernel.org,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mempolicy-recompute-automatic-interleave-weights-on-memory-hotplug.patch removed from -mm tree
Message-Id: <20261103175744.E45BA1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mempolicy: recompute automatic interleave weights on memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-recompute-automatic-interleave-weights-on-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/mempolicy: recompute automatic interleave weights on memory hotplug
Date: Fri, 30 Oct 2026 12:12:34 -0400

In auto mode, weighted interleave derives each node's weight from its
bandwidth, reduced over the nodes in N_MEMORY.  HMAT and CXL report a
node's bandwidth once, when the node first gains memory, and nothing else
on the hotplug path recomputes the weights.

This can result in a major skew in distribution and overload tiers with
more data than their respective bandwidth can support, resulting in a
performance regression.

With HMAT bandwidths of 100G for nodes 0-3, and 50G and 25G for kmem nodes
4 and 5, weighted_interleave/nodeN reads:

  event             node 0-3   node 4   node 5
  node 4 online         7         3        -
  node 4 removed        7         -        -
  node 5 online         7         -        1
  node 4 back           7         1        1
  Expected:             6         3        1

Toggling auto off and on generates the correct result, but we should
detect this and fix it during hotplug.  Recompute the weights from the
recorded bandwidth whenever a node gains/loses its first/last memory.

The notifier cannot fail the hotplug, which has already happened, so warn
once if the new weights cannot be allocated.  The next recompute starts
from the full bandwidth table and corrects them.

mempolicy_set_node_perf() now only records the bandwidth and calls the
same helper, so the bandwidth is kept even if allocating the new weights
fails.  wi_state_lock is dropped between the two steps, which should be
safe because racing writer simply causes it to run with newer state.

Link: https://lore.kernel.org/20261030161234.1505367-1-gourry@gourry.net
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/mempolicy.c |   84 +++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 27 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-recompute-automatic-interleave-weights-on-memory-hotplug
+++ a/mm/mempolicy.c
@@ -245,27 +245,49 @@ static void reduce_interleave_weights(un
 		new_iw[nid] /= iw_gcd;
 }
 
+/* Recompute the weights from node_bw_table, unless they were set manually */
+static int wi_state_refresh(void)
+{
+	struct weighted_interleave_state *new_wi_state, *old_wi_state;
+	int i;
+
+	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	if (!new_wi_state)
+		return -ENOMEM;
+	new_wi_state->mode_auto = true;
+	for (i = 0; i < nr_node_ids; i++)
+		new_wi_state->iw_table[i] = 1;
+
+	mutex_lock(&wi_state_lock);
+	old_wi_state = rcu_dereference_protected(wi_state,
+					lockdep_is_held(&wi_state_lock));
+	/*
+	 * Hotplug events can arrive before any node reported its bandwidth,
+	 * leaving nothing to compute weights from. NULL wi_state assumes
+	 * auto=true.
+	 */
+	if (!node_bw_table || (old_wi_state && !old_wi_state->mode_auto)) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return 0;
+	}
+	reduce_interleave_weights(node_bw_table, new_wi_state->iw_table);
+	rcu_assign_pointer(wi_state, new_wi_state);
+	mutex_unlock(&wi_state_lock);
+	wi_state_retire(old_wi_state);
+	return 0;
+}
+
 int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 {
-	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	unsigned int *old_bw, *new_bw;
 	unsigned int bw_val;
-	int i;
 
 	bw_val = min(coords->read_bandwidth, coords->write_bandwidth);
 	new_bw = kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 	if (!new_bw)
 		return -ENOMEM;
 
-	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
-	if (!new_wi_state) {
-		kfree(new_bw);
-		return -ENOMEM;
-	}
-	new_wi_state->mode_auto = true;
-	for (i = 0; i < nr_node_ids; i++)
-		new_wi_state->iw_table[i] = 1;
-
 	/*
 	 * Update bandwidth info, even in manual mode. That way, when switching
 	 * to auto mode in the future, iw_table can be overwritten using
@@ -278,25 +300,32 @@ int mempolicy_set_node_perf(unsigned int
 		memcpy(new_bw, old_bw, nr_node_ids * sizeof(*old_bw));
 	new_bw[node] = bw_val;
 	node_bw_table = new_bw;
+	mutex_unlock(&wi_state_lock);
 
-	old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-	if (old_wi_state && !old_wi_state->mode_auto) {
-		/* Manual mode; skip reducing weights and updating wi_state */
-		mutex_unlock(&wi_state_lock);
-		kfree(new_wi_state);
-		goto out;
-	}
+	kfree(old_bw);
+	return wi_state_refresh();
+}
 
-	/* NULL wi_state assumes auto=true; reduce weights and update wi_state*/
-	reduce_interleave_weights(new_bw, new_wi_state->iw_table);
-	rcu_assign_pointer(wi_state, new_wi_state);
+/*
+ * HMAT and CXL report a node's bandwidth only when it first gains memory, so
+ * recompute the weights whenever N_MEMORY changes.
+ */
+static int wi_state_node_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct node_notify *nn = data;
+	int err;
 
-	mutex_unlock(&wi_state_lock);
-	wi_state_retire(old_wi_state);
-out:
-	kfree(old_bw);
-	return 0;
+	if (action != NODE_ADDED_FIRST_MEMORY &&
+	    action != NODE_REMOVED_LAST_MEMORY)
+		return NOTIFY_OK;
+
+	/* The hotplug is done, failing the notification would not undo it */
+	err = wi_state_refresh();
+	if (err)
+		pr_warn_once("failed to recompute weighted interleave weights for node%d: %d\n",
+			     nn->nid, err);
+	return NOTIFY_OK;
 }
 
 /**
@@ -3421,6 +3450,7 @@ void __init numa_policy_init(void)
 	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
 		pr_err("%s: interleaving failed\n", __func__);
 
+	hotplug_node_notifier(wi_state_node_notifier, DEFAULT_CALLBACK_PRI);
 	check_numabalancing_enable();
 }
 
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch

