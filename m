From: akpm@linux-foundation.org
Subject: + ib-ehca-fix-static-rate-regression.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:08:12 -0800
Message-ID: <200711270508.lAR58CrR028258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbXK0FIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:08:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fenkes@de.ibm.com, rolandd@cisco.com


The patch titled
     IB/ehca: fix static rate regression
has been added to the -mm tree.  Its filename is
     ib-ehca-fix-static-rate-regression.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ib-ehca-fix-static-rate-regression.patch
