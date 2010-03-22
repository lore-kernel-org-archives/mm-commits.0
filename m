From: akpm@linux-foundation.org
Subject: + mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch added to -mm tree
Date: Mon, 22 Mar 2010 15:09:52 -0700
Message-ID: <201003222209.o2MM9q84030362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab0CVWKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 18:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, andi@firstfloor.org, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mempolicy: remove case MPOL_INTERLEAVE from policy_zonelist()
has been added to the -mm tree.  Its filename is
     mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch

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
Subject: mempolicy: remove case MPOL_INTERLEAVE from policy_zonelist()
From: Bob Liu <lliubbo@gmail.com>

In policy_zonelist() mode MPOL_INTERLEAVE shouldn't happen, so fall
through to BUG() instead of break to return.  I also fixed the comment.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-remove-case-mpol_interleave-from-policy_zonelist mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-case-mpol_interleave-from-policy_zonelist
+++ a/mm/mempolicy.c
@@ -1438,15 +1438,13 @@ static struct zonelist *policy_zonelist(
 		/*
 		 * Normally, MPOL_BIND allocations are node-local within the
 		 * allowed nodemask.  However, if __GFP_THISNODE is set and the
-		 * current node is part of the mask, we use the zonelist for
+		 * current node isn't part of the mask, we use the zonelist for
 		 * the first node in the mask instead.
 		 */
 		if (unlikely(gfp & __GFP_THISNODE) &&
 				unlikely(!node_isset(nd, policy->v.nodes)))
 			nd = first_node(policy->v.nodes);
 		break;
-	case MPOL_INTERLEAVE: /* should not happen */
-		break;
 	default:
 		BUG();
 	}
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mempolicy-remove-redundant-code.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch

