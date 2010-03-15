From: akpm@linux-foundation.org
Subject: + mempolicy-remove-redundant-code.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:55:29 -0700
Message-ID: <201003152055.o2FKtTEG021972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064Ab0COU46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy: remove redundant code
has been added to the -mm tree.  Its filename is
     mempolicy-remove-redundant-code.patch

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
Subject: mempolicy: remove redundant code
From: Bob Liu <lliubbo@gmail.com>

1.  In funtion is_valid_nodemask(), varibable k will be inited to 0 in
   the following loop, needn't init to policy_zone anymore.

2. (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES) has already defined
   to MPOL_MODE_FLAGS in mempolicy.h.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-remove-redundant-code mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-redundant-code
+++ a/mm/mempolicy.c
@@ -128,9 +128,6 @@ static int is_valid_nodemask(const nodem
 {
 	int nd, k;
 
-	/* Check that there is something useful in this mask */
-	k = policy_zone;
