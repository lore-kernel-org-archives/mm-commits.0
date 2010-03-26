From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-oops-on-mounts-with-mpol=default.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:36 -0400
Message-ID: <201003261937.o2QJbZA5016620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab0CZTiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: fix oops on mounts with mpol=default
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-oops-on-mounts-with-mpol=default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: fix oops on mounts with mpol=default
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Fix an 'oops' when a tmpfs mount point is mounted with the mpol=default
mempolicy.

Upon remounting a tmpfs mount point with 'mpol=default' option, the mount
code crashed with a null pointer dereference.  The initial problem report
was on 2.6.27, but the problem exists in mainline 2.6.34-rc as well.  On
examining the code, we see that mpol_new returns NULL if default mempolicy
was requested.  This 'NULL' mempolicy is accessed to store the node mask
resulting in oops.

The following patch fixes it.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~tmpfs-fix-oops-on-mounts-with-mpol=default mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-fix-oops-on-mounts-with-mpol=default
+++ a/mm/mempolicy.c
@@ -2215,10 +2215,15 @@ int mpol_parse_str(char *str, struct mem
 			goto out;
 		mode = MPOL_PREFERRED;
 		break;
-
+	case MPOL_DEFAULT:
+		/*
+		 * Insist on a empty nodelist
+		 */
+		if (!nodelist)
+			err = 0;
+		goto out;
 	/*
 	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 * case MPOL_DEFAULT: mpol_new() enforces empty nodemask, ignores flags.
 	 */
 	}
 
_

Patches currently in -mm which might be from kiran@scalex86.org are

origin.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
slab-leaks3-default-y.patch

