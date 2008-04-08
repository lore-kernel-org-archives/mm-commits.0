From: akpm@linux-foundation.org
Subject: + mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:27:02 -0700
Message-ID: <200804080327.m383R2Ji006043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927AbYDHD1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy: clean-up mpol-to-str() mempolicy formatting
has been added to the -mm tree.  Its filename is
     mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch

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
Subject: mempolicy: clean-up mpol-to-str() mempolicy formatting
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

mpol-to-str() formats memory policies into printable strings.  Currently this
is only used to display "numa_maps".  A subsequent patch will use
mpol_to_str() for formatting tmpfs [shmem] mpol mount options, allowing us to
remove essentially duplicate code in mm/shmem.c.  This patch cleans up
mpol_to_str() generally and in preparation for that patch.

1) show_numa_maps() is not checking the return code from mpol_to_str(). 
   There's not a lot we can do in this context if mpol_to_str() did return the
   error [insufficient space in buffer].  Proposed "solution": just check,
   under DEBUG_VM, that callers are providing sufficient buffer space for the
   policy, flags, and a few nodes.  This way, we'll get some display. 
   show_numa_maps() is providing a 50-byte buffer, so it won't trip this
   check.  50-bytes should be sufficient unless one has a large number of
   nodes in a very sparse nodemask.

2) The display of the new mode flags ["static" & "relative"] was set up to
   display multiple flags, separated by a "bar" '|'.  However, this support is
   incomplete--e.g., need_bar was never incremented; and currently, these two
   flags are mutually exclusive.  So remove the "bar" support, for now, and
   only display one flag.

3) Use snprint() to format flags, so as not to overflow the buffer.  Not
   that it's ever happed, AFAIK.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-clean-up-mpol-to-str-mempolicy-formatting mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-clean-up-mpol-to-str-mempolicy-formatting
+++ a/mm/mempolicy.c
@@ -1966,6 +1966,11 @@ static inline int mpol_to_str(char *buff
 	unsigned short mode;
 	unsigned short flags = pol ? pol->flags : 0;
 
+	/*
+	 * Sanity check:  room for longest mode, flag and some nodes
+	 */
+	VM_BUG_ON(maxlen < strlen("interleave") + strlen("relative") + 16);
+
 	if (!pol || pol == &default_policy)
 		mode = MPOL_DEFAULT;
 	else
@@ -1992,7 +1997,6 @@ static inline int mpol_to_str(char *buff
 
 	default:
 		BUG();
-		return -EFAULT;
 	}
 
 	l = strlen(policy_types[mode]);
@@ -2003,16 +2007,17 @@ static inline int mpol_to_str(char *buff
 	p += l;
 
 	if (flags) {
-		int need_bar = 0;
-
 		if (buffer + maxlen < p + 2)
 			return -ENOSPC;
 		*p++ = '=';
 
+		/*
+		 * Currently, the only defined flags are mutually exclusive
+		 */
 		if (flags & MPOL_F_STATIC_NODES)
-			p += sprintf(p, "%sstatic", need_bar++ ? "|" : "");
-		if (flags & MPOL_F_RELATIVE_NODES)
-			p += sprintf(p, "%srelative", need_bar++ ? "|" : "");
+			p += snprintf(p, buffer + maxlen - p, "static");
+		else if (flags & MPOL_F_RELATIVE_NODES)
+			p += snprintf(p, buffer + maxlen - p, "relative");
 	}
 
 	if (!nodes_empty(nodes)) {
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

