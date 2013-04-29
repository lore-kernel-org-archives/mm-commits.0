From: akpm@linux-foundation.org
Subject: [folded-merged] clear_refs-sanitize-accepted-commands-declaration-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:53:24 -0700
Message-ID: <20130429215324.BF8CD31C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50160 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150Ab3D2Vx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:53:26 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so429762vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:53:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, xemul@parallels.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: clear_refs-sanitize-accepted-commands-declaration-fix
has been removed from the -mm tree.  Its filename was
     clear_refs-sanitize-accepted-commands-declaration-fix.patch

This patch was dropped because it was folded into clear_refs-sanitize-accepted-commands-declaration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: clear_refs-sanitize-accepted-commands-declaration-fix

don't assume that sizeof(enum clear_refs_types) == sizeof(int)

Cc: Glauber Costa <glommer@parallels.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~clear_refs-sanitize-accepted-commands-declaration-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~clear_refs-sanitize-accepted-commands-declaration-fix
+++ a/fs/proc/task_mmu.c
@@ -734,6 +734,7 @@ static ssize_t clear_refs_write(struct f
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum clear_refs_types type;
+	int itype;
 	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -741,9 +742,10 @@ static ssize_t clear_refs_write(struct f
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	rv = kstrtoint(strstrip(buffer), 10, (int *)&type);
+	rv = kstrtoint(strstrip(buffer), 10, &itype);
 	if (rv < 0)
 		return rv;
+	type = (enum clear_refs_types)itype;
 	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
 	task = get_proc_task(file_inode(file));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

