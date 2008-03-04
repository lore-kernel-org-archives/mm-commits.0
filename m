From: akpm@linux-foundation.org
Subject: + use-page_cache_xxx-in-ext2-fix-2.patch added to -mm tree
Date: Tue, 04 Mar 2008 11:45:55 -0800
Message-ID: <200803041945.m24JjtMI025625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYCDTqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, clameter@sgi.com


The patch titled
     fix ext2 borkage
has been added to the -mm tree.  Its filename is
     use-page_cache_xxx-in-ext2-fix-2.patch

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
Subject: fix ext2 borkage
From: Hugh Dickins <hugh@veritas.com>

use-page_cache_xxx-in-ext2.patch gave me lots of EXT2-fs error (device loop0):
ext2_find_entry: dir 52629 size 5120 exceeds block count 2 so I stopped it
quickly.  Creating a directory entry was muddling up the directory and the
linked inode, writing directory page out to the latter.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/dir.c~use-page_cache_xxx-in-ext2-fix-2 fs/ext2/dir.c
--- a/fs/ext2/dir.c~use-page_cache_xxx-in-ext2-fix-2
+++ a/fs/ext2/dir.c
@@ -472,7 +472,7 @@ void ext2_set_link(struct inode *dir, st
 int ext2_add_link (struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
-	struct address_space *mapping = inode->i_mapping;
+	struct address_space *mapping = dir->i_mapping;
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
 	unsigned chunk_size = ext2_chunk_size(dir);
_

Patches currently in -mm which might be from hugh@veritas.com are

control-groups-add-paul-menage-a-maintainer.patch
add-balbir-as-the-maintainer-for-memory-resource-controller.patch
git-unionfs.patch
memcg-mm_match_cgroup-not-vm_match_cgroup.patch
memcg-move_lists-on-page-not-page_cgroup.patch
memcg-page_cache_release-not-__free_page.patch
memcg-when-do_swaps-do_wp_page-fails.patch
memcg-fix-vm_bug_on-from-page-migration.patch
memcg-bad-page-if-page_cgroup-when-free.patch
memcg-mem_cgroup_charge-never-null.patch
memcg-remove-mem_cgroup_uncharge.patch
memcg-memcontrol-whitespace-cleanups.patch
memcg-memcontrol-uninlined-and-static.patch
memcg-remove-clear_page_cgroup-and-atomics.patch
memcg-css_put-after-remove_list.patch
memcg-fix-mem_cgroup_move_lists-locking.patch
memcg-simplify-force_empty-and-move_lists.patch
memcg-fix-oops-on-null-lru-list.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
use-page_cache_xxx-in-ext2-fix-2.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

