From: akpm@linux-foundation.org
Subject: + tmpfs-cleanup-mpol_parse_str.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:10:49 -0700
Message-ID: <201003192310.o2JNAncu017627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0CSXMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     tmpfs: cleanup mpol_parse_str()
has been added to the -mm tree.  Its filename is
     tmpfs-cleanup-mpol_parse_str.patch

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
Subject: tmpfs: cleanup mpol_parse_str()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

mpol_parse_str() made lots 'err' variable related bug.  Because it is ugly
and reviewing unfriendly.

This patch simplifies it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/mempolicy.c~tmpfs-cleanup-mpol_parse_str mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-cleanup-mpol_parse_str
+++ a/mm/mempolicy.c
@@ -2195,8 +2195,8 @@ int mpol_parse_str(char *str, struct mem
 			char *rest = nodelist;
 			while (isdigit(*rest))
 				rest++;
-			if (!*rest)
-				err = 0;
+			if (*rest)
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
@@ -2205,7 +2205,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (!nodelist)
 			nodes = node_states[N_HIGH_MEMORY];
-		err = 0;
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -2214,7 +2213,6 @@ int mpol_parse_str(char *str, struct mem
 		if (nodelist)
 			goto out;
 		mode = MPOL_PREFERRED;
-		err = 0;
 		break;
 	case MPOL_DEFAULT:
 		/*
@@ -2229,7 +2227,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (!nodelist)
 			goto out;
-		err = 0;
 	}
 
 	mode_flags = 0;
@@ -2243,13 +2240,14 @@ int mpol_parse_str(char *str, struct mem
 		else if (!strcmp(flags, "relative"))
 			mode_flags |= MPOL_F_RELATIVE_NODES;
 		else
-			err = 1;
+			goto out;
 	}
 
 	new = mpol_new(mode, mode_flags, &nodes);
 	if (IS_ERR(new))
-		err = 1;
-	else {
+		goto out;
+
+	{
 		int ret;
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -2260,13 +2258,15 @@ int mpol_parse_str(char *str, struct mem
 			ret = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 		if (ret) {
-			err = 1;
 			mpol_put(new);
-		} else if (no_context) {
-			/* save for contextualization */
-			new->w.user_nodemask = nodes;
+			goto out;
 		}
 	}
+	err = 0;
+	if (no_context) {
+		/* save for contextualization */
+		new->w.user_nodemask = nodes;
+	}
 
 out:
 	/* Restore string for error message */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
tmpfs-fix-oops-on-mounts-with-mpol=default.patch
tmpfs-mpol=bind-0-dont-cause-mount-error.patch
tmpfs-handle-mpol_local-mount-option-properly.patch
tmpfs-cleanup-mpol_parse_str.patch
doc-add-the-documentation-for-mpol=local.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists-fix.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

