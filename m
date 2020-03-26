From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch added to
 -mm tree
Date: Wed, 25 Mar 2020 17:52:27 -0700
Message-ID: <20200326005227.pxcWTawbT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbgCZAw2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Mar 2020 20:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 3ntr0py1337@gmail.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm: mempolicy: require at least one nodeid for MPOL_PREFERRED
has been added to the -mm tree.  Its filename is
     mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Using an empty (malformed) nodelist that is not caught during mount option
parsing leads to a stack-out-of-bounds access.

The option string that was used was: "mpol=prefer:,".  However,
MPOL_PREFERRED requires a single node number, which is not being provided
here.

Add a check that 'nodes' is not empty after parsing for MPOL_PREFERRED's
nodeid.

Link: http://lkml.kernel.org/r/89526377-7eb6-b662-e1d8-4430928abde9@infradead.org
Fixes: 095f1fc4ebf3 ("mempolicy: rework shmem mpol parsing and display")
Reported-by: Entropy Moe <3ntr0py1337@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred
+++ a/mm/mempolicy.c
@@ -2897,7 +2897,9 @@ int mpol_parse_str(char *str, struct mem
 	switch (mode) {
 	case MPOL_PREFERRED:
 		/*
-		 * Insist on a nodelist of one node only
+		 * Insist on a nodelist of one node only, although later
+		 * we use first_node(nodes) to grab a single node, so here
+		 * nodelist (or nodes) cannot be empty.
 		 */
 		if (nodelist) {
 			char *rest = nodelist;
@@ -2905,6 +2907,8 @@ int mpol_parse_str(char *str, struct mem
 				rest++;
 			if (*rest)
 				goto out;
+			if (nodes_empty(nodes))
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch
bus-mhi-fix-printk-format-for-size_t.patch
