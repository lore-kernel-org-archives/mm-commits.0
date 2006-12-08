From: akpm@osdl.org
Subject: - ia64-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:31:32 -0800
Message-ID: <200612080831.kB88VW4T013485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425147AbWLHIbg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:31:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     ia64-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/hp/common/sba_iommu.c |   10 +++-------
 arch/ia64/hp/sim/simserial.c    |    3 +--
 arch/ia64/kernel/perfmon.c      |    3 +--
 arch/ia64/pci/pci.c             |    3 +--
 4 files changed, 6 insertions(+), 13 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~ia64-replace-kmallocmemset-with-kzalloc arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~ia64-replace-kmallocmemset-with-kzalloc
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1672,15 +1672,13 @@ ioc_sac_init(struct ioc *ioc)
 	 * SAC (single address cycle) addressable, so allocate a
 	 * pseudo-device to enforce that.
 	 */
-	sac = kmalloc(sizeof(*sac), GFP_KERNEL);
+	sac = kzalloc(sizeof(*sac), GFP_KERNEL);
 	if (!sac)
 		panic(PFX "Couldn't allocate struct pci_dev");
-	memset(sac, 0, sizeof(*sac));
 
-	controller = kmalloc(sizeof(*controller), GFP_KERNEL);
+	controller = kzalloc(sizeof(*controller), GFP_KERNEL);
 	if (!controller)
 		panic(PFX "Couldn't allocate struct pci_controller");
-	memset(controller, 0, sizeof(*controller));
 
 	controller->iommu = ioc;
 	sac->sysdata = controller;
@@ -1737,12 +1735,10 @@ ioc_init(u64 hpa, void *handle)
 	struct ioc *ioc;
 	struct ioc_iommu *info;
 
-	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
+	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc)
 		return NULL;
 
-	memset(ioc, 0, sizeof(*ioc));
-
 	ioc->next = ioc_list;
 	ioc_list = ioc;
 
diff -puN arch/ia64/hp/sim/simserial.c~ia64-replace-kmallocmemset-with-kzalloc arch/ia64/hp/sim/simserial.c
--- a/arch/ia64/hp/sim/simserial.c~ia64-replace-kmallocmemset-with-kzalloc
+++ a/arch/ia64/hp/sim/simserial.c
@@ -684,12 +684,11 @@ static int get_async_struct(int line, st
 		*ret_info = sstate->info;
 		return 0;
 	}
-	info = kmalloc(sizeof(struct async_struct), GFP_KERNEL);
+	info = kzalloc(sizeof(struct async_struct), GFP_KERNEL);
 	if (!info) {
 		sstate->count--;
 		return -ENOMEM;
 	}
-	memset(info, 0, sizeof(struct async_struct));
 	init_waitqueue_head(&info->open_wait);
 	init_waitqueue_head(&info->close_wait);
 	init_waitqueue_head(&info->delta_msr_wait);
diff -puN arch/ia64/kernel/perfmon.c~ia64-replace-kmallocmemset-with-kzalloc arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-replace-kmallocmemset-with-kzalloc
+++ a/arch/ia64/kernel/perfmon.c
@@ -853,9 +853,8 @@ pfm_context_alloc(void)
 	 * allocate context descriptor 
 	 * must be able to free with interrupts disabled
 	 */
-	ctx = kmalloc(sizeof(pfm_context_t), GFP_KERNEL);
+	ctx = kzalloc(sizeof(pfm_context_t), GFP_KERNEL);
 	if (ctx) {
-		memset(ctx, 0, sizeof(pfm_context_t));
 		DPRINT(("alloc ctx @%p\n", ctx));
 	}
 	return ctx;
diff -puN arch/ia64/pci/pci.c~ia64-replace-kmallocmemset-with-kzalloc arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~ia64-replace-kmallocmemset-with-kzalloc
+++ a/arch/ia64/pci/pci.c
@@ -125,11 +125,10 @@ alloc_pci_controller (int seg)
 {
 	struct pci_controller *controller;
 
-	controller = kmalloc(sizeof(*controller), GFP_KERNEL);
+	controller = kzalloc(sizeof(*controller), GFP_KERNEL);
 	if (!controller)
 		return NULL;
 
-	memset(controller, 0, sizeof(*controller));
 	controller->segment = seg;
 	controller->node = -1;
 	return controller;
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

