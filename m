From: akpm@linux-foundation.org
Subject: + ehca-enforce-a-positive-guid_entry-index.patch added to -mm tree
Date: Mon, 22 Jun 2009 22:14:43 -0700
Message-ID: <200906230514.n5N5Ehw1006056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZFWFOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 01:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, alexs@linux.vnet.ibm.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com


The patch titled
     ehca: enforce a positive guid_entry index
has been added to the -mm tree.  Its filename is
     ehca-enforce-a-positive-guid_entry-index.patch

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
ehca-enforce-a-positive-guid_entry-index.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

