From: akpm@linux-foundation.org
Subject: - drivers-scsi-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Mon, 05 Jan 2009 01:26:20 -0800
Message-ID: <200901050926.n059QKMc008600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbZAEJ0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 04:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi: move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-scsi-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~drivers-scsi-move-a-dereference-below-a-null-test drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~drivers-scsi-move-a-dereference-below-a-null-test
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1736,12 +1736,13 @@ lpfc_block_mgmt_io(struct lpfc_hba * phb
 int
 lpfc_online(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = phba->pport;
+	struct lpfc_vport *vport;
 	struct lpfc_vport **vports;
 	int i;
 
 	if (!phba)
 		return 0;
+	vport = phba->pport;
 
 	if (!(vport->fc_flag & FC_OFFLINE_MODE))
 		return 0;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
drivers-rtc-correct-an-error-test.patch

