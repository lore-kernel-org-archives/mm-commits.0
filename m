From: akpm@linux-foundation.org
Subject: - libsas-fix-test-for-negative-unsigned-and-typos.patch removed from -mm tree
Date: Mon, 05 Jan 2009 01:19:13 -0800
Message-ID: <200901050919.n059JDW7002766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbZAEJTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 04:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     libsas: fix test for negative unsigned and typos
has been removed from the -mm tree.  Its filename was
     libsas-fix-test-for-negative-unsigned-and-typos.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libsas: fix test for negative unsigned and typos
From: roel kluin <roel.kluin@gmail.com>

unsigned req->data_len cannot be negative, and fix typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_host_smp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/libsas/sas_host_smp.c~libsas-fix-test-for-negative-unsigned-and-typos drivers/scsi/libsas/sas_host_smp.c
--- a/drivers/scsi/libsas/sas_host_smp.c~libsas-fix-test-for-negative-unsigned-and-typos
+++ a/drivers/scsi/libsas/sas_host_smp.c
@@ -199,12 +199,12 @@ int sas_smp_host_handler(struct Scsi_Hos
 		break;
 
 	case SMP_DISCOVER:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		if (req->data_len < 15) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 16;
 		resp_data_len -= 56;
 		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
 		break;
@@ -215,12 +215,12 @@ int sas_smp_host_handler(struct Scsi_Hos
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->data_len =- 16;
-		if (req->data_len < 0) {
+		if (req->data_len < 15) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 16;
 		resp_data_len -= 60;
 		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
 		break;
@@ -238,12 +238,12 @@ int sas_smp_host_handler(struct Scsi_Hos
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->data_len =- 44;
-		if (req->data_len < 0) {
+		if (req->data_len < 43) {
 			req->data_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
+		req->data_len -= 44;
 		resp_data_len -= 8;
 		sas_phy_control(sas_ha, req_data[9], req_data[10],
 				req_data[32] >> 4, req_data[33] >> 4,
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
libsas-fix-test-for-negative-unsigned-and-typos.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch
sm501-unsigned-ptr-cannot-be-negative.patch
ufs-sector_t-cannot-be-negative.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
make-various-things-static.patch

