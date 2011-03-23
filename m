From: akpm@linux-foundation.org
Subject: [merged] mempolicy-remove-redundant-check-in-__mpol_equal.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:46 -0700
Message-ID: <201103232040.p2NKeMJi028525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933517Ab1CWUz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, andi@firstfloor.org, lee.schermerhorn@hp.com, lliubbo@gmail.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: remove redundant check in __mpol_equal()
has been removed from the -mm tree.  Its filename was
     mempolicy-remove-redundant-check-in-__mpol_equal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: remove redundant check in __mpol_equal()
From: Namhyung Kim <namhyung@gmail.com>

The 'flags' field is already checked, no need to do it again.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-remove-redundant-check-in-__mpol_equal mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-redundant-check-in-__mpol_equal
+++ a/mm/mempolicy.c
@@ -1979,8 +1979,7 @@ int __mpol_equal(struct mempolicy *a, st
 	case MPOL_INTERLEAVE:
 		return nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
-		return a->v.preferred_node == b->v.preferred_node &&
-			a->flags == b->flags;
+		return a->v.preferred_node == b->v.preferred_node;
 	default:
 		BUG();
 		return 0;
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch

