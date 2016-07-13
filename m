From: akpm@linux-foundation.org
Subject: [merged] dax-use-devm_add_action_or_reset.patch removed from -mm
 tree
Date: Wed, 13 Jul 2016 14:45:31 -0700
Message-ID: <5786b67b.wJo/vMigGSL7xnzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbcGMVpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dan.j.williams@intel.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dax: use devm_add_action_or_reset()
has been removed from the -mm tree.  Its filename was
     dax-use-devm_add_action_or_reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/dax: use devm_add_action_or_reset()

If devm_add_action() fails we are explicitly calling the cleanup to free
the resources allocated.  Lets use the helper devm_add_action_or_reset()
and return directly in case of error, as we know that the cleanup function
has been already called by the helper if there was any error.

Link: http://lkml.kernel.org/r/1465742896-5841-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax.c  |    8 ++------
 drivers/dax/pmem.c |   14 ++++++--------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/dax/dax.c~dax-use-devm_add_action_or_reset drivers/dax/dax.c
--- a/drivers/dax/dax.c~dax-use-devm_add_action_or_reset
+++ a/drivers/dax/dax.c
@@ -211,13 +211,9 @@ int devm_create_dax_dev(struct dax_regio
 	}
 	dax_dev->dev = dev;
 
-	rc = devm_add_action(dax_region->dev, unregister_dax_dev, dev);
-	if (rc) {
-		unregister_dax_dev(dev);
-		return rc;
-	}
+	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
 
-	return 0;
+	return rc;
 
  err_create:
 	ida_simple_remove(&dax_minor_ida, minor);
diff -puN drivers/dax/pmem.c~dax-use-devm_add_action_or_reset drivers/dax/pmem.c
--- a/drivers/dax/pmem.c~dax-use-devm_add_action_or_reset
+++ a/drivers/dax/pmem.c
@@ -102,21 +102,19 @@ static int dax_pmem_probe(struct device
 	if (rc)
 		return rc;
 
-	rc = devm_add_action(dev, dax_pmem_percpu_exit, &dax_pmem->ref);
-	if (rc) {
-		dax_pmem_percpu_exit(&dax_pmem->ref);
+	rc = devm_add_action_or_reset(dev, dax_pmem_percpu_exit,
+				      &dax_pmem->ref);
+	if (rc)
 		return rc;
-	}
 
 	addr = devm_memremap_pages(dev, &res, &dax_pmem->ref, altmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
-	rc = devm_add_action(dev, dax_pmem_percpu_kill, &dax_pmem->ref);
-	if (rc) {
-		dax_pmem_percpu_kill(&dax_pmem->ref);
+	rc = devm_add_action_or_reset(dev, dax_pmem_percpu_kill,
+				      &dax_pmem->ref);
+	if (rc)
 		return rc;
-	}
 
 	nd_region = to_nd_region(dev->parent);
 	dax_region = alloc_dax_region(dev, nd_region->id, &res,
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-fix-build-warning-about-putc.patch
m32r-add-__ucmpdi2-to-fix-build-failure.patch
fpga-zynq-fpga-fix-build-failure.patch

