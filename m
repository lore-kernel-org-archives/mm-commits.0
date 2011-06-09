From: akpm@linux-foundation.org
Subject: + drm-ttm-use-shmem_read_mapping_page.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:27 -0700
Message-ID: <201106092242.p59MgR9h005037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab1FIWnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, airlied@redhat.com, hch@infradead.org, thellstrom@vmware.com


The patch titled
     drm/ttm: use shmem_read_mapping_page
has been added to the -mm tree.  Its filename is
     drm-ttm-use-shmem_read_mapping_page.patch

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
Subject: drm/ttm: use shmem_read_mapping_page
From: Hugh Dickins <hughd@google.com>

Soon tmpfs will stop supporting ->readpage and read_mapping_page(): once
"tmpfs: add shmem_read_mapping_page_gfp" has been applied, this patch can
be applied to ease the transition.

ttm_tt_swapin() and ttm_tt_swapout() use shmem_read_mapping_page() in
place of read_mapping_page(), since their swap_space has been created with
shmem_file_setup().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_tt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/ttm/ttm_tt.c~drm-ttm-use-shmem_read_mapping_page drivers/gpu/drm/ttm/ttm_tt.c
--- a/drivers/gpu/drm/ttm/ttm_tt.c~drm-ttm-use-shmem_read_mapping_page
+++ a/drivers/gpu/drm/ttm/ttm_tt.c
@@ -31,6 +31,7 @@
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include <linux/file.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
@@ -484,7 +485,7 @@ static int ttm_tt_swapin(struct ttm_tt *
 	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
 
 	for (i = 0; i < ttm->num_pages; ++i) {
-		from_page = read_mapping_page(swap_space, i, NULL);
+		from_page = shmem_read_mapping_page(swap_space, i);
 		if (IS_ERR(from_page)) {
 			ret = PTR_ERR(from_page);
 			goto out_err;
@@ -557,7 +558,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 		from_page = ttm->pages[i];
 		if (unlikely(from_page == NULL))
 			continue;
-		to_page = read_mapping_page(swap_space, i, NULL);
+		to_page = shmem_read_mapping_page(swap_space, i);
 		if (unlikely(IS_ERR(to_page))) {
 			ret = PTR_ERR(to_page);
 			goto out_err;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

