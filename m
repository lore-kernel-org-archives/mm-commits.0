From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 15:31:40 -0700
Message-ID: <51db3dcc.jjb/1Tnn8zU28baI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHWbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, akpm@linux-foundation.org

Subject: [folded-merged] ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:31:40 -0700


The patch titled
     Subject: ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes

ERROR: "(foo*)" should be "(foo *)"
#47: FILE: ipc/util.c:493:
+	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;

ERROR: "(foo*)" should be "(foo *)"
#58: FILE: ipc/util.c:509:
+	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;

total: 2 errors, 0 warnings, 34 lines checked

./patches/ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/util.c~ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes ipc/util.c
--- a/ipc/util.c~ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes
+++ a/ipc/util.c
@@ -486,12 +486,12 @@ void *ipc_rcu_alloc(int size)
 	if (unlikely(!out))
 		return NULL;
 	atomic_set(&out->refcount, 1);
-	return out+1;
+	return out + 1;
 }
 
 int ipc_rcu_getref(void *ptr)
 {
-	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;
+	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
 
 	return atomic_inc_not_zero(&p->refcount);
 }
@@ -507,7 +507,7 @@ static void ipc_schedule_free(struct rcu
 
 void ipc_rcu_putref(void *ptr)
 {
-	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;
+	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
 
 	if (!atomic_dec_and_test(&p->refcount))
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

