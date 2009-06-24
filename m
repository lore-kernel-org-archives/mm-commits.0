From: akpm@linux-foundation.org
Subject: [merged] ehca-enforce-a-positive-guid_entry-index.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:59 -0700
Message-ID: <200906241910.n5OJAxGk011191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754777AbZFXTL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alexs@linux.vnet.ibm.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ehca: enforce a positive guid_entry index
has been removed from the -mm tree.  Its filename was
     ehca-enforce-a-positive-guid_entry-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ehca: enforce a positive guid_entry index
From: Roel Kluin <roel.kluin@gmail.com>

This prevents the memcpy of a guid_entries element using a negative index.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_hca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/ehca/ehca_hca.c~ehca-enforce-a-positive-guid_entry-index drivers/infiniband/hw/ehca/ehca_hca.c
--- a/drivers/infiniband/hw/ehca/ehca_hca.c~ehca-enforce-a-positive-guid_entry-index
+++ a/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -319,7 +319,7 @@ int ehca_query_gid(struct ib_device *ibd
 					      ib_device);
 	struct hipz_query_port *rblock;
 
-	if (index > 255) {
+	if (index > 255 || index < 0) {
 		ehca_err(&shca->ib_device, "Invalid index: %x.", index);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

