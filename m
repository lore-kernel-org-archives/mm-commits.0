From: akpm@linux-foundation.org
Subject: + remove-unnecessary-is_valid_nodemask.patch added to -mm tree
Date: Mon, 17 Nov 2014 15:08:38 -0800
Message-ID: <546a7ff6.2nTAC6qFODcM/UZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaKQXIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 18:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zzhsuny@gmail.com, mel@csn.ul.ie, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: remove unnecessary is_valid_nodemask()
has been added to the -mm tree.  Its filename is
     remove-unnecessary-is_valid_nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-unnecessary-is_valid_nodemask.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/remove-unnecessary-is_valid_nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhihui Zhang <zzhsuny@gmail.com>
Subject: mm/mempolicy.c: remove unnecessary is_valid_nodemask()

When nodes is true, nsc->mask2 has already been filtered by nsc->mask1,
which has already factored in node_states[N_MEMORY].

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/mempolicy.c~remove-unnecessary-is_valid_nodemask mm/mempolicy.c
--- a/mm/mempolicy.c~remove-unnecessary-is_valid_nodemask
+++ a/mm/mempolicy.c
@@ -162,12 +162,6 @@ static const struct mempolicy_operations
 			enum mpol_rebind_step step);
 } mpol_ops[MPOL_MAX];
 
-/* Check that the nodemask contains at least one populated zone */
-static int is_valid_nodemask(const nodemask_t *nodemask)
-{
-	return nodes_intersects(*nodemask, node_states[N_MEMORY]);
-}
-
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
 	return pol->flags & MPOL_MODE_FLAGS;
@@ -202,7 +196,7 @@ static int mpol_new_preferred(struct mem
 
 static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	if (!is_valid_nodemask(nodes))
+	if (nodes_empty(*nodes))
 		return -EINVAL;
 	pol->v.nodes = *nodes;
 	return 0;
@@ -234,7 +228,7 @@ static int mpol_set_nodemask(struct memp
 		nodes = NULL;	/* explicit local allocation */
 	else {
 		if (pol->flags & MPOL_F_RELATIVE_NODES)
-			mpol_relative_nodemask(&nsc->mask2, nodes,&nsc->mask1);
+			mpol_relative_nodemask(&nsc->mask2, nodes, &nsc->mask1);
 		else
 			nodes_and(nsc->mask2, *nodes, nsc->mask1);
 
_

Patches currently in -mm which might be from zzhsuny@gmail.com are

remove-unnecessary-is_valid_nodemask.patch

