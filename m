From: akpm@linux-foundation.org
Subject: + mempolicy-mark-shared-policies-for-unref.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:26:49 -0700
Message-ID: <200804080326.m383Qn9x006019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbYDHD1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy:  mark shared policies for unref
has been added to the -mm tree.  Its filename is
     mempolicy-mark-shared-policies-for-unref.patch

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
Subject: mempolicy:  mark shared policies for unref
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

As part of yet another rework of mempolicy reference counting, we want to be
able to identify shared policies efficiently, because they have an extra ref
taken on lookup that needs to be removed when we're finished using the policy.

  Note:  the extra ref is required because the policies are
  shared between tasks/processes and can be changed/freed
  by one task while another task is using them--e.g., for
  page allocation.

Building on David Rientjes mempolicy "mode flags" enhancement, this patch
indicates a "shared" policy by setting a new MPOL_F_SHARED flag in the flags
member of the struct mempolicy added by David.  MPOL_F_SHARED, and any future
"internal mode flags" are reserved from bit zero up, as they will never be
passed in the upper bits of the mode argument of a mempolicy API.

I set the MPOL_F_SHARED flag when the policy is installed in the shared policy
rb-tree.  Don't need/want to clear the flag when removing from the tree as the
mempolicy is freed [unref'd] internally to the sp_delete() function.  However,
a task could hold another reference on this mempolicy from a prior lookup.  We
need the MPOL_F_SHARED flag to stay put so that any tasks holding a ref will
unref, eventually freeing, the mempolicy.

A later patch in this series will introduce a function to conditionally unref
[mpol_free] a policy.  The MPOL_F_SHARED flag is one reason [currently the
only reason] to unref/free a policy via the conditional free.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    7 +++++++
 mm/mempolicy.c            |    1 +
 2 files changed, 8 insertions(+)

diff -puN include/linux/mempolicy.h~mempolicy-mark-shared-policies-for-unref include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-mark-shared-policies-for-unref
+++ a/include/linux/mempolicy.h
@@ -44,6 +44,13 @@ enum {
 #define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
 #define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
 
+/*
+ * Internal flags that share the struct mempolicy flags word with
+ * "mode flags".  These flags are allocated from bit 0 up, as they
+ * are never OR'ed into the mode in mempolicy API arguments.
+ */
+#define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
+
 #ifdef __KERNEL__
 
 #include <linux/mmzone.h>
diff -puN mm/mempolicy.c~mempolicy-mark-shared-policies-for-unref mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-mark-shared-policies-for-unref
+++ a/mm/mempolicy.c
@@ -1751,6 +1751,7 @@ static struct sp_node *sp_alloc(unsigned
 	n->start = start;
 	n->end = end;
 	mpol_get(pol);
+	pol->flags |= MPOL_F_SHARED;	/* for unref */
 	n->policy = pol;
 	return n;
 }
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

