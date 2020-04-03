From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:40:21 -0700
Message-ID: <20200403204021.fv78s0jtt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUkW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 3ntr0py1337@gmail.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm: mempolicy: require at least one nodeid for MPOL_PREFERRED
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reported-by: syzbot+b055b1a6b2b958707a21@syzkaller.appspotmail.com
Tested-by: syzbot+b055b1a6b2b958707a21@syzkaller.appspotmail.com
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred
+++ a/mm/mempolicy.c
@@ -2898,7 +2898,9 @@ int mpol_parse_str(char *str, struct mem
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
@@ -2906,6 +2908,8 @@ int mpol_parse_str(char *str, struct mem
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

mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch
