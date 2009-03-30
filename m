From: akpm@linux-foundation.org
Subject: + mm-page_mkwrite-change-prototype-to-match-fault-sysfs.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:08:46 -0700
Message-ID: <200903302308.n2UN8kNp018007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758631AbZC3XLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:11:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, ebiederm@aristanetworks.com, npiggin@suse.de


The patch titled
     mm: page_mkwrite change prototype to match fault: fix sysfs
has been added to the -mm tree.  Its filename is
     mm-page_mkwrite-change-prototype-to-match-fault-sysfs.patch

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
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
mm-shmemc-fix-division-by-zero.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
mm-page_mkwrite-change-prototype-to-match-fault-sysfs.patch
getrusage-fill-ru_maxrss-value.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch
memcg-remove-redundant-message-at-swapon.patch
prio_tree-debugging-patch.patch

