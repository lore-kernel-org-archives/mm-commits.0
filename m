From: akpm@linux-foundation.org
Subject: + hugetlb-fix-section-mismatches-2.patch added to -mm tree
Date: Wed, 13 Jan 2010 17:01:54 -0800
Message-ID: <201001140101.o0E11sv8007053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088Ab0ANBCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 20:02:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, rientjes@google.com


The patch titled
     hugetlb: fix section mismatches #2
has been added to the -mm tree.  Its filename is
     hugetlb-fix-section-mismatches-2.patch

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
Subject: hugetlb: fix section mismatches #2
From: Jeff Mahoney <jeffm@suse.com>

hugetlb_register_node calls hugetlb_sysfs_add_hstate, which is marked with
__init.  Since hugetlb_register_node is only called by
hugetlb_register_all_nodes, which in turn is only called by hugetlb_init,
it's safe to mark both of them as __init.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-section-mismatches-2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-section-mismatches-2
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
 
_

Patches currently in -mm which might be from jeffm@suse.com are

hugetlb-fix-section-mismatches-2.patch

