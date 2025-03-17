Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DF42FB2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189489; cv=none; b=AD/nNYkhTOxymIYJWNUcMNCf8yDP8SbrjxCI5rFINAlh5BhiZfADsHG9oW8dC5jKnHON4XwqvbIF1Oj/MeYciJCS8aZ+7uS857so/CYJ2XcUHR3Sqx6EQctIYL67+efWI4/yfRkCzTxNNIRK1tAEIghDPjf2Flm47+tlH1f6vgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189489; c=relaxed/simple;
	bh=uwjvM92EaRqLhyCBJA/uNwoaDPYQMUPDmSL0PjhrEtQ=;
	h=Date:To:From:Subject:Message-Id; b=IP9Fi0fahH3n5HBSyUOGsiWy60kTiWVislnWVSreLEulTbwH0giSb2cmWqp4WmlkqvSSXrG5chvvB4cR5dRyWvOUJAnVLsNS7PJtltkx1Nt7FNyV1uyJ7YPaNOC+qXlzFQ1Qh6ReLq8uLdR3HBepTBm4WYEyQ0y6bm0uG+DTxT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dM7uCZcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dM7uCZcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530F2C4CEEC;
	Mon, 17 Mar 2025 05:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189489;
	bh=uwjvM92EaRqLhyCBJA/uNwoaDPYQMUPDmSL0PjhrEtQ=;
	h=Date:To:From:Subject:From;
	b=dM7uCZcZArsp3NtI2jODcq5Rb57ClYE3l8DNFGmrvg+S0ORXLgaYc7ftAsuFZ1nf/
	 gTwz3+k+AWipgtnadpvirIjXEBWfdesOeuomFSDW4cbrBlLijsqAU94QHLBHrgTe90
	 YIO6Y31zLdlPUa/jMy4eYHLDaJG4MpK5Sg1MPP2o=
Date: Sun, 16 Mar 2025 22:31:28 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-plistc-add-shortcut-for-plist_requeue.patch removed from -mm tree
Message-Id: <20250317053129.530F2C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/plist.c: add shortcut for plist_requeue()
has been removed from the -mm tree.  Its filename was
     lib-plistc-add-shortcut-for-plist_requeue.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: lib/plist.c: add shortcut for plist_requeue()
Date: Sun, 19 Jan 2025 14:24:08 +0800

In the operation of plist_requeue(), "node" is deleted from the list
before queueing it back to the list again, which involves looping to find
the tail of same-prio entries.

If "node" is the head of same-prio entries which means its prio_list is on
the priority list, then "node_next" can be retrieve immediately by the
next entry of prio_list, instead of looping nodes on node_list.

The shortcut implementation can benefit plist_requeue() running the below
test, and the test result is shown in the following table.

One can observe from the test result that when the number of nodes of
same-prio entries is smaller, then the probability of hitting the shortcut
can be bigger, thus the benefit can be more significant.

While it tends to behave almost the same for long same-prio entries, since
the probability of taking the shortcut is much smaller.

 -----------------------------------------------------------------------
| Test size          |    200 |     400 |     600 |     800 |     1000 |
 -----------------------------------------------------------------------
| new_plist_requeue  |  271521|  1007913|  2148033|  4346792|  12200940|
 -----------------------------------------------------------------------
| old_plist_requeue  |  301395|  1105544|  2488301|  4632980|  12217275|
 -----------------------------------------------------------------------

The test is done on x86_64 architecture with v6.9 kernel and 
Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz.

Test script( executed in kernel module mode ):

int init_module(void)
{
	unsigned int test_data[test_size];

	/* Split the list into 10 different priority
	 * , when test_size is larger, the number of
	 * nodes within each priority is larger.
	 */
	for (i = 0; i < ARRAY_SIZE(test_data); i++) {
		test_data[i] = i % 10;
	}

	ktime_t start, end, time_elapsed = 0;
	plist_head_init(&test_head_local);

	for (i = 0; i < ARRAY_SIZE(test_node_local); i++) {
		plist_node_init(test_node_local + i, 0);
		test_node_local[i].prio = test_data[i];
	}


	for (i = 0; i < ARRAY_SIZE(test_node_local); i++) {
		if (plist_node_empty(test_node_local + i)) {
			plist_add(test_node_local + i, &test_head_local);
		}
	}

	for (i = 0; i < ARRAY_SIZE(test_node_local); i += 1) {
		start = ktime_get();
		plist_requeue(test_node_local + i, &test_head_local);
		end = ktime_get();
		time_elapsed += (end - start);
	}

	pr_info("plist_requeue() elapsed time : %lld, size %d\n", time_elapsed, test_size);
	return 0;
}

[akpm@linux-foundation.org: tweak comment and code layout]
Link: https://lkml.kernel.org/r/20250119062408.77638-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/lib/plist.c~lib-plistc-add-shortcut-for-plist_requeue
+++ a/lib/plist.c
@@ -171,12 +171,24 @@ void plist_requeue(struct plist_node *no
 
 	plist_del(node, head);
 
+	/*
+	 * After plist_del(), iter is the replacement of the node.  If the node
+	 * was on prio_list, take shortcut to find node_next instead of looping.
+	 */
+	if (!list_empty(&iter->prio_list)) {
+		iter = list_entry(iter->prio_list.next, struct plist_node,
+				  prio_list);
+		node_next = &iter->node_list;
+		goto queue;
+	}
+
 	plist_for_each_continue(iter, head) {
 		if (node->prio != iter->prio) {
 			node_next = &iter->node_list;
 			break;
 		}
 	}
+queue:
 	list_add_tail(&node->node_list, node_next);
 
 	plist_check_head(head);
_

Patches currently in -mm which might be from richard120310@gmail.com are


