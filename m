From: akpm@linux-foundation.org
Subject: + drivers-scsi-move-a-dereference-below-a-null-test.patch added to -mm tree
Date: Thu, 18 Dec 2008 13:10:50 -0800
Message-ID: <200812182110.mBILApCv022141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbYLRVK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 16:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Smart@Emulex.Com


The patch titled
     drivers/scsi: move a dereference below a NULL test
has been added to the -mm tree.  Its filename is
     drivers-scsi-move-a-dereference-below-a-null-test.patch

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
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-rtc-correct-an-error-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-mmc-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
drivers-scsi-move-a-dereference-below-a-null-test.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch

