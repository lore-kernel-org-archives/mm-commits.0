Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3846F145A14
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293222; cv=none; b=aweyCw0Xd0GtK5dxsgJaMY12jcNYgs8YU6MMBc+EAyhVKR8OCaxmqiHeOOQoeOOV+xhC9a2pWpHkVdp/yrinK926d3XDBkrPVvcUZhdvvXRsxLFm2N/MMDPIH3B3DITyZQQfG7HXHAKkUOHBQsuNV1KYPtF/WvzgAducSKmaWEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293222; c=relaxed/simple;
	bh=QyZX7C4C6pkHeXSlXaFAOv9TZI/4kU9OaqRaMJGYbM8=;
	h=Date:To:From:Subject:Message-Id; b=Jq1UycLMP446ANHN3kCZKOQnUJk5muhGLiyVdY4HGJnjK8kmW7u1WTyXPM9ZZDmeLRc4sWRfR/h+PHme1efJ/3ouRO0RNA+kzFgjrXIJfyENrsmhEmsTV9LNQdS5ABp2euDhPXynFGHYHFAv3rGH0jPemushKb3dafBx+KuL6u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqJMUhE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqJMUhE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A8C32782;
	Tue, 25 Jun 2024 05:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293222;
	bh=QyZX7C4C6pkHeXSlXaFAOv9TZI/4kU9OaqRaMJGYbM8=;
	h=Date:To:From:Subject:From;
	b=rqJMUhE5sti2HNY3WmnOO1JAquFBN0z8w6BT7AIWOnoS7XFd8gx8YJIf700goMCLq
	 7ZHLAxMYmHRuCFxBpt/eRIkmSbUVVoCzEOr0nb9Y3RHikIyi9DPpmaQP4gFSmelz4l
	 eHeAs3PFCd9JQhnzsy9rN9caLVR0HoeVn0SFsO7E=
Date: Mon, 24 Jun 2024 22:27:01 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-plistc-avoid-worst-case-scenario-in-plist_add.patch removed from -mm tree
Message-Id: <20240625052701.F03A8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/plist.c: avoid worst case scenario in plist_add
has been removed from the -mm tree.  Its filename was
     lib-plistc-avoid-worst-case-scenario-in-plist_add.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: lib/plist.c: avoid worst case scenario in plist_add
Date: Fri, 14 Jun 2024 23:46:03 +0800

Worst case scenario of plist_add() happens when the priority of the
inserted plist_node is going to be the largest after the insertion is
done.  The cost is going to be more significant when the original plist is
longer, because the iterator is going to traverse the whole plist to find
the correct position to insert the new node.

The situation can be avoided by using a reverse iterator at the same time,
doing so the maximum possible number of iteration is going to shrink from
N to N/2.

The proposed change of plist_add pasts the test in lib/plist.c to validate
its correctness, also add the worst case scenario test for plist_add() in
plist_test().

The worst case test are tested with the size of test_data and test_node
growing from 200 to 1000.  The result are showned in the following table,
in which we can observed that the proposed change of plist_add performs
better than the original version, and the difference between these two
implementations are more significant with the size of N growing.

The random case test [1], and best case test [2] are also provided, with
result showing the proposed change performs slightly better in random case
test while the original implementation performs slightly better in best
case test, while the difference in both test are minor, we can see them as
even in those two situations.

 -----------------------------------------------------------
| Test size      |   200 |   400 |    600 |    800 |   1000 |
 -----------------------------------------------------------
| new_plist_add  | 140911| 548681| 1220512| 2048493| 3763755|
 -----------------------------------------------------------
| old_plist_add  | 188198| 774222| 1643547| 3008929| 4947435|
 -----------------------------------------------------------

Link: https://lkml.kernel.org/r/20240614154603.65203-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Signed-off-by: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/lib/plist.c~lib-plistc-avoid-worst-case-scenario-in-plist_add
+++ a/lib/plist.c
@@ -72,7 +72,7 @@ static void plist_check_head(struct plis
  */
 void plist_add(struct plist_node *node, struct plist_head *head)
 {
-	struct plist_node *first, *iter, *prev = NULL;
+	struct plist_node *first, *iter, *prev = NULL, *last, *reverse_iter;
 	struct list_head *node_next = &head->node_list;
 
 	plist_check_head(head);
@@ -83,16 +83,26 @@ void plist_add(struct plist_node *node,
 		goto ins_node;
 
 	first = iter = plist_first(head);
+	last = reverse_iter = list_entry(first->prio_list.prev, struct plist_node, prio_list);
 
 	do {
 		if (node->prio < iter->prio) {
 			node_next = &iter->node_list;
 			break;
+		} else if (node->prio >= reverse_iter->prio) {
+			prev = reverse_iter;
+			iter = list_entry(reverse_iter->prio_list.next,
+				struct plist_node, prio_list);
+			if (likely(reverse_iter != last))
+				node_next = &iter->node_list;
+			break;
 		}
 
 		prev = iter;
 		iter = list_entry(iter->prio_list.next,
 				struct plist_node, prio_list);
+		reverse_iter = list_entry(reverse_iter->prio_list.prev,
+				struct plist_node, prio_list);
 	} while (iter != first);
 
 	if (!prev || prev->prio != node->prio)
@@ -255,6 +265,32 @@ static int  __init plist_test(void)
 	}
 
 	printk(KERN_DEBUG "end plist test\n");
+
+	/* Worst case test for plist_add() */
+	unsigned int test_data[241];
+
+	for (i = 0; i < ARRAY_SIZE(test_data); i++)
+		test_data[i] = i;
+
+	ktime_t start, end, time_elapsed = 0;
+
+	plist_head_init(&test_head);
+
+	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
+		plist_node_init(test_node + i, 0);
+		test_node[i].prio = test_data[i];
+	}
+
+	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
+		if (plist_node_empty(test_node + i)) {
+			start = ktime_get();
+			plist_add(test_node + i, &test_head);
+			end = ktime_get();
+			time_elapsed += (end - start);
+		}
+	}
+
+	pr_debug("plist_add worst case test time elapsed %lld\n", time_elapsed);
 	return 0;
 }
 
_

Patches currently in -mm which might be from richard120310@gmail.com are


