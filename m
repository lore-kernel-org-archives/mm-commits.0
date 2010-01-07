From: akpm@linux-foundation.org
Subject: + hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch added to -mm tree
Date: Thu, 07 Jan 2010 14:18:25 -0800
Message-ID: <201001072218.o07MIPNm020870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab0AGWS1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 17:18:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com


The patch titled
     hugetlb: fix section mismatch warning in hugetlb.c
has been added to the -mm tree.  Its filename is
     hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch

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
Subject: hugetlb: fix section mismatch warning in hugetlb.c
From: Rakib Mullick <rakib.mullick@gmail.com>

Since hugetlb_sysfs_add_hstate()'s caller is __init and it isn't
referencing from any other function, we can do this.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-section-mismatch-warning-in-hugetlbc mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-section-mismatch-warning-in-hugetlbc
+++ a/mm/hugetlb.c
@@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
  * Register hstate attributes for a single node sysdev.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+void __init hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
@@ -1683,7 +1683,7 @@ void hugetlb_register_node(struct node *
  * sysdevs of nodes that have memory.  All on-line nodes should have
  * registered their associated sysdev by this time.
  */
-static void hugetlb_register_all_nodes(void)
+static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;
 
@@ -1712,7 +1712,7 @@ static struct hstate *kobj_to_node_hstat
 
 static void hugetlb_unregister_all_nodes(void) { }
 
-static void hugetlb_register_all_nodes(void) { }
+static void __init hugetlb_register_all_nodes(void) { }
 
 #endif
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch

