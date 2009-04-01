From: akpm@linux-foundation.org
Subject: [merged] mm-page_mkwrite-change-prototype-to-match-fault-sysfs.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:41 -0700
Message-ID: <200904011838.n31IcfkA008367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755957AbZDAS5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ebiederm@aristanetworks.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: page_mkwrite change prototype to match fault: fix sysfs
has been removed from the -mm tree.  Its filename was
     mm-page_mkwrite-change-prototype-to-match-fault-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: page_mkwrite change prototype to match fault: fix sysfs
From: Hugh Dickins <hugh@veritas.com>

Fix warnings and return values in sysfs bin_page_mkwrite(), fixing
fs/sysfs/bin.c: In function `bin_page_mkwrite':
fs/sysfs/bin.c:250: warning: passing argument 2 of `bb->vm_ops->page_mkwrite' from incompatible pointer type
fs/sysfs/bin.c: At top level:
fs/sysfs/bin.c:280: warning: initialization from incompatible pointer type

Expects to have my [PATCH next] sysfs: fix some bin_vm_ops errors

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/sysfs/bin.c~mm-page_mkwrite-change-prototype-to-match-fault-sysfs fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~mm-page_mkwrite-change-prototype-to-match-fault-sysfs
+++ a/fs/sysfs/bin.c
@@ -234,7 +234,7 @@ static int bin_fault(struct vm_area_stru
 	return ret;
 }
 
-static int bin_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct bin_buffer *bb = file->private_data;
@@ -242,15 +242,15 @@ static int bin_page_mkwrite(struct vm_ar
 	int ret;
 
 	if (!bb->vm_ops)
-		return -EINVAL;
+		return VM_FAULT_SIGBUS;
 
 	if (!bb->vm_ops->page_mkwrite)
 		return 0;
 
 	if (!sysfs_get_active_two(attr_sd))
-		return -EINVAL;
+		return VM_FAULT_SIGBUS;
 
-	ret = bb->vm_ops->page_mkwrite(vma, page);
+	ret = bb->vm_ops->page_mkwrite(vma, vmf);
 
 	sysfs_put_active_two(attr_sd);
 	return ret;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
getrusage-fill-ru_maxrss-value.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch
memcg-remove-redundant-message-at-swapon.patch
prio_tree-debugging-patch.patch

