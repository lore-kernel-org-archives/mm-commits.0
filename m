From: akpm@linux-foundation.org
Subject: - ib-ehca-fix-static-rate-regression.patch removed from -mm tree
Date: Tue, 27 Nov 2007 18:09:56 -0800
Message-ID: <200711280209.lAS29uC0010953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759583AbXK1CKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 21:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenkes@de.ibm.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     IB/ehca: fix static rate regression
has been removed from the -mm tree.  Its filename was
     ib-ehca-fix-static-rate-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IB/ehca: fix static rate regression
From: Joachim Fenkes <fenkes@de.ibm.com>

Wrong choice of port number caused modify_qp() to fail -- fixed.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_qp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_qp.c~ib-ehca-fix-static-rate-regression drivers/infiniband/hw/ehca/ehca_qp.c
--- a/drivers/infiniband/hw/ehca/ehca_qp.c~ib-ehca-fix-static-rate-regression
+++ a/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1203,7 +1203,7 @@ static int internal_modify_qp(struct ib_
 		mqpcb->service_level = attr->ah_attr.sl;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL, 1);
 
-		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+		if (ehca_calc_ipd(shca, mqpcb->prim_phys_port,
 				  attr->ah_attr.static_rate,
 				  &mqpcb->max_static_rate)) {
 			ret = -EINVAL;
@@ -1302,7 +1302,7 @@ static int internal_modify_qp(struct ib_
 		mqpcb->source_path_bits_al = attr->alt_ah_attr.src_path_bits;
 		mqpcb->service_level_al = attr->alt_ah_attr.sl;
 
-		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+		if (ehca_calc_ipd(shca, mqpcb->alt_phys_port,
 				  attr->alt_ah_attr.static_rate,
 				  &mqpcb->max_static_rate_al)) {
 			ret = -EINVAL;
_

Patches currently in -mm which might be from fenkes@de.ibm.com are

origin.patch
