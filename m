From: akpm@linux-foundation.org
Subject: + mempolicy-fix-get_mempolicy-for-relative-and-static-nodes.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:54:54 -0700
Message-ID: <201003222354.o2MNssjg002357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab0CVXzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mempolicy: fix get_mempolicy() for relative and static nodes
has been added to the -mm tree.  Its filename is
     mempolicy-fix-get_mempolicy-for-relative-and-static-nodes.patch

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

tmpfs-fix-oops-on-mounts-with-mpol=default.patch
tmpfs-mpol=bind-0-dont-cause-mount-error.patch
tmpfs-handle-mpol_local-mount-option-properly.patch
tmpfs-cleanup-mpol_parse_str.patch
doc-add-the-documentation-for-mpol=local.patch
mempolicy-fix-get_mempolicy-for-relative-and-static-nodes.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch

