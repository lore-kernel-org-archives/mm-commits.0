From: akpm@linux-foundation.org
Subject: + mempolicy-support-mpol=local-tmpfs-mount-option.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:27:06 -0700
Message-ID: <200804080327.m383R6Ht006049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbYDHD1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy: support mpol=local tmpfs mount option
has been added to the -mm tree.  Its filename is
     mempolicy-support-mpol=local-tmpfs-mount-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1952,7 +1952,7 @@ void numa_default_policy(void)
 
 /*
  * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
- * Used only for mpol_to_str()
+ * Used only for mpol_parse_str() and mpol_to_str()
  */
 #define MPOL_LOCAL (MPOL_INTERLEAVE + 1)
 static const char * const policy_types[] =
@@ -1991,21 +1991,16 @@ int mpol_parse_str(char *str, unsigned s
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
@@ -2028,6 +2023,20 @@ int mpol_parse_str(char *str, unsigned s
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

mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch

