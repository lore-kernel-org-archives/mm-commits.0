From: akpm@linux-foundation.org
Subject: + vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch added to -mm tree
Date: Fri, 21 Mar 2008 15:15:07 -0700
Message-ID: <200803212215.m2LMF7OU013072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYCUWPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 18:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, arjan@infradead.org


The patch titled
     vmallocinfo: only allow root to read /proc/vmallocinfo
has been added to the -mm tree.  Its filename is
     vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch

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
Subject: vmallocinfo: only allow root to read /proc/vmallocinfo
From: Christoph Lameter <clameter@sgi.com>

Change permissions for /proc/vmallocinfo to only allow read
for root.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix
+++ a/fs/proc/proc_misc.c
@@ -881,8 +881,7 @@ void __init proc_misc_init(void)
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
 #endif
 #endif
-	proc_create("vmallocinfo", S_IWUSR|S_IRUGO, NULL,
-						&proc_vmalloc_operations);
+	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
 	create_seq_entry("buddyinfo",S_IRUGO, &fragmentation_file_operations);
 	create_seq_entry("pagetypeinfo", S_IRUGO, &pagetypeinfo_file_ops);
 	create_seq_entry("vmstat",S_IRUGO, &proc_vmstat_file_operations);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
mm-fix-boundary-checking-in-free_bootmem_core.patch
git-unionfs.patch
git-slub.patch
remove-set_migrateflags.patch
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
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-mem_map-allocation-continuous.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
get-rid-of-__zone_count.patch
mm-remove-unused-max_nodes_shift.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

