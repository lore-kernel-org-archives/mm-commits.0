From: akpm@linux-foundation.org
Subject: + libsas-fix-test-for-negative-unsigned-and-typos.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:20:15 -0800
Message-ID: <200812022220.mB2MKFH1001158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbYLBWUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:20:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     libsas: fix test for negative unsigned and typos
has been added to the -mm tree.  Its filename is
     libsas-fix-test-for-negative-unsigned-and-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
libsas-fix-test-for-negative-unsigned-and-typos.patch
gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch
sm501-unsigned-ptr-cannot-be-negative.patch
ufs-sector_t-cannot-be-negative.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
make-various-things-static.patch

