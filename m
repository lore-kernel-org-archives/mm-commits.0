From: akpm@linux-foundation.org
Subject: + tmpfs-fix-oops-on-remounts-with-mpol=default.patch added to -mm tree
Date: Fri, 12 Mar 2010 15:53:12 -0800
Message-ID: <201003122353.o2CNrC56015250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932782Ab0CLXyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 18:54:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     tmpfs: fix oops on remounts with mpol=default
has been added to the -mm tree.  Its filename is
     tmpfs-fix-oops-on-remounts-with-mpol=default.patch

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
Subject: tmpfs: fix oops on remounts with mpol=default
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Fix an 'oops' when a tmpfs mount point is remounted with the 'default'
mempolicy.

Upon remounting a tmpfs mount point with 'mpol=default' option, the
remount code crashed with a null pointer dereference.  The initial problem
report was on 2.6.27, but the problem exists in mainline 2.6.34-rc as
well.  On examining the code, we see that mpol_new returns NULL if default
mempolicy was requested.  This 'NULL' mempolicy is accessed to store the
node mask resulting in oops.

The following patch fixes the oops by avoiding dereferencing NULL if the
new mempolicy is NULL.  The patch also sets 'err' to 0 if MPOL_DEFAULT is
passed (err is initialized to 1 initially at mpol_parse_str())

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~tmpfs-fix-oops-on-remounts-with-mpol=default mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-fix-oops-on-remounts-with-mpol=default
+++ a/mm/mempolicy.c
@@ -2213,10 +2213,14 @@ int mpol_parse_str(char *str, struct mem
 			goto out;
 		mode = MPOL_PREFERRED;
 		break;
-
+	case MPOL_DEFAULT:
+		/*
+		 * mpol_new() enforces empty nodemask, ignores flags.
+		 */
+		err = 0;
+		break;
 	/*
 	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 * case MPOL_DEFAULT: mpol_new() enforces empty nodemask, ignores flags.
 	 */
 	}
 
@@ -2250,7 +2254,7 @@ int mpol_parse_str(char *str, struct mem
 		if (ret) {
 			err = 1;
 			mpol_put(new);
-		} else if (no_context) {
+		} else if (no_context && new) {
 			/* save for contextualization */
 			new->w.user_nodemask = nodes;
 		}
_

Patches currently in -mm which might be from kiran@scalex86.org are

tmpfs-fix-oops-on-remounts-with-mpol=default.patch
slab-leaks3-default-y.patch

