From: akpm@linux-foundation.org
Subject: - mempolicy-support-mpol=local-tmpfs-mount-option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:38 -0700
Message-ID: <200804282153.m3SLrcxF017903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935019AbYD1Vxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: support mpol=local tmpfs mount option
has been removed from the -mm tree.  Its filename was
     mempolicy-support-mpol=local-tmpfs-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: support mpol=local tmpfs mount option
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

For tmpfs/shmem shared policies, MPOL_DEFAULT is not necessarily equivalent to
"local allocation".  Because shared policies are at the same "scope" level
[see Documentation/vm/numa_memory_policy.txt], as vma policies MPOL_DEFAULT
means "fall back to current task policy".

This patch extends the memory policy string parsing function to display
"local" for MPOL_PREFERRED + MPOL_F_LOCAL.  This allows one to specify local
allocation as the default policy for shared memory areas via the tmpfs mpol
mount option, regardless of the current task's policy.

Also, "local" is now displayed for this policy.  This patch allows us to
accept the same input format as the display.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-support-mpol=local-tmpfs-mount-option mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-support-mpol=local-tmpfs-mount-option
+++ a/mm/mempolicy.c
@@ -1951,7 +1951,7 @@ void numa_default_policy(void)
 
 /*
  * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
- * Used only for mpol_to_str()
+ * Used only for mpol_parse_str() and mpol_to_str()
  */
 #define MPOL_LOCAL (MPOL_INTERLEAVE + 1)
 static const char * const policy_types[] =
@@ -1990,21 +1990,16 @@ int mpol_parse_str(char *str, unsigned s
 	if (flags)
 		*flags++ = '\0';	/* terminate mode string */
 
-	for (i = 0; i < MPOL_MAX; i++) {
+	for (i = 0; i <= MPOL_LOCAL; i++) {
 		if (!strcmp(str, policy_types[i])) {
 			*mode = i;
 			break;
 		}
 	}
-	if (i == MPOL_MAX)
+	if (i > MPOL_LOCAL)
 		goto out;
 
 	switch (*mode) {
-	case MPOL_DEFAULT:
-		/* Don't allow a nodelist nor flags */
-		if (!nodelist && !flags)
-			err = 0;
-		break;
 	case MPOL_PREFERRED:
 		/* Insist on a nodelist of one node only */
 		if (nodelist) {
@@ -2027,6 +2022,20 @@ int mpol_parse_str(char *str, unsigned s
 		if (!nodelist)
 			*policy_nodes = node_states[N_HIGH_MEMORY];
 		err = 0;
+		break;
+	default:
+		/*
+		 * MPOL_DEFAULT or MPOL_LOCAL
+		 * Don't allow a nodelist nor flags
+		 */
+		if (!nodelist && !flags)
+			err = 0;
+		if (*mode == MPOL_DEFAULT)
+			goto out;
+		/* else MPOL_LOCAL */
+		*mode = MPOL_PREFERRED;
+		nodes_clear(*policy_nodes);
+		break;
 	}
 
 	*mode_flags = 0;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

