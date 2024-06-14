Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4F482D6D
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391561; cv=none; b=uCXYaksTBbgT3+DlcTFrVG7OS1Ij2G8UWNlh4ngkLSF0BvIwUuIkpOTV/jH0nMf7u0AuiQK6golVbO+TrZ4Atg9dpIXAAWlfCtgqFV36yih2d0HCZqiD/nOLzlm3I5ykggX0NxRUVNv9AiulrdvrZHk9zzOcZxcMIxBrVSiksys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391561; c=relaxed/simple;
	bh=wf7Yfy3kCDLdRlr7EBEoxV0BbFhy8phWFgDlMgoD6So=;
	h=Date:To:From:Subject:Message-Id; b=sMrWgBGrkLa6pbaY7npaaJ3UfmFjyb8IsOohDH2Go6eVbTESOQIor47I2mAEMzD4siebBx6pOly4vMEp0HOrvf34aF9sQTXmGcqAfokdAazs8/WRiv+mk3wEh9KC8JyVcwyUJSA4Y9pFReFl9eVDlLRD+1dUsBSsosKA4EEq2uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mAhh/7Ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mAhh/7Ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B50FC2BD10;
	Fri, 14 Jun 2024 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718391561;
	bh=wf7Yfy3kCDLdRlr7EBEoxV0BbFhy8phWFgDlMgoD6So=;
	h=Date:To:From:Subject:From;
	b=mAhh/7AkyrZHOPVpttE79fQuXMVjeuSjNU+VxdBnfm7sAFNV+L/yFrtV3Jh/gJhjM
	 wQfL1LTvWQaxkjERDAPMQcLIyqutoq0N5UmLlyXPRgdvKNN/mJEyhlxKuy97iNiAuR
	 4kpYtXCkpGVKwTUre3ZMW8Edcm3LL+leAina4rvU=
Date: Fri, 14 Jun 2024 11:59:20 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-plistc-avoid-worst-case-scenario-in-plist_add.patch added to mm-nonmm-unstable branch
Message-Id: <20240614185921.7B50FC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/plist.c: avoid worst case scenario in plist_add
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-plistc-avoid-worst-case-scenario-in-plist_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-plistc-avoid-worst-case-scenario-in-plist_add.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-plistc-enforce-memory-ordering-in-plist_check_list.patch
lib-plistc-avoid-worst-case-scenario-in-plist_add.patch

