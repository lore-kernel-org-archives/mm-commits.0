From: akpm@linux-foundation.org
Subject: + mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:58:11 -0700
Message-ID: <201003222358.o2MNwBnH002472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab0CVX6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mempolicy: don't call mpol_set_nodemask() when no_context
has been added to the -mm tree.  Its filename is
     mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch

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
Subject: mempolicy: don't call mpol_set_nodemask() when no_context
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

No need to call mpol_set_nodemask() when we have no context for the
mempolicy.  This can occur when we're parsing a tmpfs 'mpol' mount option.
 Just save the raw nodemask in the mempolicy's w.user_nodemask member for
use when a tmpfs/shmem file is created.  mpol_shared_policy_init() will
"contextualize" the policy for the new file based on the creating task's
context.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-dont-call-mpol_set_nodemask-when-no_context mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-dont-call-mpol_set_nodemask-when-no_context
+++ a/mm/mempolicy.c
@@ -2284,7 +2284,10 @@ int mpol_parse_str(char *str, struct mem
 	if (IS_ERR(new))
 		goto out;
 
-	{
+	if (no_context) {
+		/* save for contextualization */
+		new->w.user_nodemask = nodes;
+	} else {
 		int ret;
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -2300,10 +2303,6 @@ int mpol_parse_str(char *str, struct mem
 		}
 	}
 	err = 0;
-	if (no_context) {
-		/* save for contextualization */
-		new->w.user_nodemask = nodes;
-	}
 
 out:
 	/* Restore string for error message */
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
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch

