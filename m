From: akpm@linux-foundation.org
Subject: [merged] infiniband-use-for_each_set_bit.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:02:59 -0800
Message-ID: <201003091902.o29J2xjY030913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755336Ab0CITDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hal.rosenstock@gmail.com, rolandd@cisco.com, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     infiniband: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     infiniband-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: infiniband: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/mad.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff -puN drivers/infiniband/core/mad.c~infiniband-use-for_each_set_bit drivers/infiniband/core/mad.c
--- a/drivers/infiniband/core/mad.c~infiniband-use-for_each_set_bit
+++ a/drivers/infiniband/core/mad.c
@@ -1193,10 +1193,7 @@ static int method_in_use(struct ib_mad_m
 {
 	int i;
 
-	for (i = find_first_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS) {
 		if ((*method)->agent[i]) {
 			printk(KERN_ERR PFX "Method %d already in use\n", i);
 			return -EINVAL;
@@ -1330,13 +1327,9 @@ static int add_nonoui_reg_req(struct ib_
 		goto error3;
 
 	/* Finally, add in methods being registered */
-	for (i = find_first_bit(mad_reg_req->method_mask,
-				IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error3:
@@ -1429,13 +1422,9 @@ check_in_use:
 		goto error4;
 
 	/* Finally, add in methods being registered */
-	for (i = find_first_bit(mad_reg_req->method_mask,
-				IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error4:
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch
bitops-remove-temporary-for_each_bit.patch

