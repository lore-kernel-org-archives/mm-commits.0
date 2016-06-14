From: akpm@linux-foundation.org
Subject: + dax-use-devm_add_action_or_reset.patch added to -mm tree
Date: Tue, 14 Jun 2016 15:37:51 -0700
Message-ID: <5760873f.6mReppqJib7rqKIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbcFNWhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dan.j.williams@intel.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dax: use devm_add_action_or_reset()
has been added to the -mm tree.  Its filename is
     dax-use-devm_add_action_or_reset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-use-devm_add_action_or_reset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-use-devm_add_action_or_reset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/dax: use devm_add_action_or_reset()

If devm_add_action() fails we are explicitly calling the cleanup to free
the resources allocated.  Lets use the helper devm_add_action_or_reset()
and return directly in case of error, as we know that the cleanup function
has been already called by the helper if there was any error.

Link: http://lkml.kernel.org/r/1465742896-5841-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
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

dax-use-devm_add_action_or_reset.patch
m32r-add-__ucmpdi2-to-fix-build-failure.patch
mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch
fpga-zynq-fpga-fix-build-failure.patch

