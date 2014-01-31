From: akpm@linux-foundation.org
Subject: + mm-hugetlb-improve-page-fault-scalability-fix.patch added to
 -mm tree
Date: Fri, 31 Jan 2014 13:08:45 -0800
Message-ID: <52ec10dd.zBJSyImx6IxM6Btb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbaAaVIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:08:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + mm-hugetlb-improve-page-fault-scalability-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,iamjoonsoo.kim@lge.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:08:45 -0800


The patch titled
     Subject: mm-hugetlb-improve-page-fault-scalability-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-improve-page-fault-scalability-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-improve-page-fault-scalability-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-improve-page-fault-scalability-fix.patch

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
Subject: mm-hugetlb-improve-page-fault-scalability-fix

remove stray + characters, go BUG if hugetlb_init() kmalloc fails

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability-fix
+++ a/mm/hugetlb.c
@@ -55,9 +55,9 @@ static unsigned long __initdata default_
 DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
-+ * Serializes faults on the same logical page.  This is used to
-+ * prevent spurious OOMs when the hugepage pool is fully utilized.
-+ */
+ * Serializes faults on the same logical page.  This is used to
+ * prevent spurious OOMs when the hugepage pool is fully utilized.
+ */
 static int num_fault_mutexes;
 static struct mutex *htlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
@@ -2008,8 +2008,7 @@ static int __init hugetlb_init(void)
 #endif
 	htlb_fault_mutex_table =
 		kmalloc(sizeof(struct mutex) * num_fault_mutexes, GFP_KERNEL);
-	if (!htlb_fault_mutex_table)
-		return -ENOMEM;
+	BUG_ON(!htlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
 		mutex_init(&htlb_fault_mutex_table[i]);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
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

