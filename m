From: akpm@linux-foundation.org
Subject: + hugetlbfs-return-error-code-when-initializing-module.patch added to -mm tree
Date: Mon, 12 Mar 2012 16:58:35 -0700
Message-ID: <20120312235836.A9CCEA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:47278 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2CLX6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Mar 2012 19:58:38 -0400
Received: by yhgm50 with SMTP id m50so1142632yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Mar 2012 16:58:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, rientjes@google.com


The patch titled
     Subject: hugetlbfs: return error code when initializing module
has been added to the -mm tree.  Its filename is
     hugetlbfs-return-error-code-when-initializing-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: hugetlbfs: return error code when initializing module

Return an errno upon failure to create inode kmem cache, and unregister
the FS upon failure to mount.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module
+++ a/fs/hugetlbfs/inode.c
@@ -1013,6 +1013,7 @@ static int __init init_hugetlbfs_fs(void
 	if (error)
 		return error;
 
+	error = -ENOMEM;
 	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
 					sizeof(struct hugetlbfs_inode_info),
 					0, 0, init_once);
@@ -1031,6 +1032,7 @@ static int __init init_hugetlbfs_fs(void
 	}
 
 	error = PTR_ERR(vfsmount);
+	unregister_filesystem(&hugetlbfs_fs_type);
 
  out:
 	if (error)
_
Subject: Subject: hugetlbfs: return error code when initializing module

Patches currently in -mm which might be from dhillf@gmail.com are

mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
hugetlb-cleanup-hugetlbh.patch
hugepages-fix-use-after-free-bug-in-quota-handling.patch
hugetlbfs-return-error-code-when-initializing-module.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch

