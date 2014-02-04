From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch added to -mm tree
Date: Mon, 03 Feb 2014 16:15:50 -0800
Message-ID: <52f03136.E//s2TxItulFeNpq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBDAPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,iamjoonsoo.kim@lge.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:15:50 -0800


The patch titled
     Subject: mm-hugetlb-use-vma_resv_map-map-types-update-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-use-vma_resv_map-map-types-update-fix

simplifications, per n-horiguchi

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-vma_resv_map-map-types-update-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-vma_resv_map-map-types-update-fix
+++ a/mm/hugetlb.c
@@ -426,10 +426,7 @@ static struct resv_map *vma_resv_map(str
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
 	if (vma->vm_flags & VM_MAYSHARE) {
-		struct address_space *mapping = vma->vm_file->f_mapping;
-		struct inode *inode = mapping->host;
-
-		return inode_resv_map(inode);
+		return inode_resv_map(mapping->host);
 
 	} else {
 		return (struct resv_map *)(get_vma_private_data(vma) &
@@ -2279,10 +2276,7 @@ static void hugetlb_vm_op_close(struct v
 	unsigned long start;
 	unsigned long end;
 
-	if (!resv)
-		return;
-
-	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		start = vma_hugecache_offset(h, vma, vma->vm_start);
 		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

