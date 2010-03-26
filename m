From: akpm@linux-foundation.org
Subject: [merged] mempolicy-fix-get_mempolicy-for-relative-and-static-nodes.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:22 -0400
Message-ID: <201003261938.o2QJcL4u016682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab0CZTig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: fix get_mempolicy() for relative and static nodes
has been removed from the -mm tree.  Its filename was
     mempolicy-fix-get_mempolicy-for-relative-and-static-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: fix get_mempolicy() for relative and static nodes
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Discovered while testing other mempolicy changes:

get_mempolicy() does not handle static/relative mode flags correctly.
Return the value that the user specified so that it can be restored
via set_mempolicy() if desired.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-fix-get_mempolicy-for-relative-and-static-nodes mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-get_mempolicy-for-relative-and-static-nodes
+++ a/mm/mempolicy.c
@@ -806,9 +806,13 @@ static long do_get_mempolicy(int *policy
 
 	err = 0;
 	if (nmask) {
-		task_lock(current);
-		get_policy_nodemask(pol, nmask);
-		task_unlock(current);
+		if (mpol_store_user_nodemask(pol)) {
+			*nmask = pol->w.user_nodemask;
+		} else {
+			task_lock(current);
+			get_policy_nodemask(pol, nmask);
+			task_unlock(current);
+		}
 	}
 
  out:
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch

