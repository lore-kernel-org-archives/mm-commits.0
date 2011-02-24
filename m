From: akpm@linux-foundation.org
Subject: + mempolicy-remove-redundant-check-in-__mpol_equal.patch added to -mm tree
Date: Wed, 23 Feb 2011 17:02:40 -0800
Message-ID: <201102240102.p1O12ewh002944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab1BXBCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 20:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, andi@firstfloor.org, lee.schermerhorn@hp.com, lliubbo@gmail.com, minchan.kim@gmail.com


The patch titled
     mempolicy: remove redundant check in __mpol_equal()
has been added to the -mm tree.  Its filename is
     mempolicy-remove-redundant-check-in-__mpol_equal.patch

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

linux-next.patch
mm-fix-dubious-code-in-__count_immobile_pages.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mempolicy-remove-redundant-check-in-__mpol_equal.patch
select-remove-unused-max_select_seconds.patch

