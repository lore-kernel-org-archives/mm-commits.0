From: akpm@osdl.org
Subject: - remove-double-cast-to-same-type.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:07:52 -0800
Message-ID: <200612062207.kB6M7qfa018094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46816 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937706AbWLFWIT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:08:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jeff@garzik.org, jengelh@gmx.de, kkeil@suse.de, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Remove double cast to same type
has been removed from the -mm tree.  Its filename was
     remove-double-cast-to-same-type.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Remove double cast to same type
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Remove double-casts to the same type, such as (void *)(void *)foobar (which
becomes just (void *)foobar).  Also remove the (int) cast in
fs/cifs/connect.c at the same go.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Karsten Keil <kkeil@suse.de>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/amd7930_fn.c   |    2 +-
 drivers/isdn/hisax/config.c       |    2 +-
 drivers/isdn/hisax/hfc_2bds0.c    |    2 +-
 drivers/isdn/hisax/hfc_pci.c      |    2 +-
 drivers/isdn/hisax/hfc_sx.c       |    2 +-
 drivers/isdn/hisax/icc.c          |    2 +-
 drivers/isdn/hisax/isac.c         |    2 +-
 drivers/isdn/hisax/isar.c         |    2 +-
 drivers/isdn/hisax/isdnl1.c       |    2 +-
 drivers/isdn/hisax/w6692.c        |    2 +-
 drivers/isdn/i4l/isdn_net.c       |    2 +-
 drivers/net/hamradio/baycom_epp.c |    2 +-
 fs/cifs/connect.c                 |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/isdn/hisax/amd7930_fn.c~remove-double-cast-to-same-type drivers/isdn/hisax/amd7930_fn.c
--- a/drivers/isdn/hisax/amd7930_fn.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/amd7930_fn.c
@@ -789,7 +789,7 @@ Amd7930_init(struct IsdnCardState *cs)
 void __devinit
 setup_Amd7930(struct IsdnCardState *cs)
 {
-        INIT_WORK(&cs->tqueue, (void *)(void *) Amd7930_bh, cs);
+        INIT_WORK(&cs->tqueue, (void *)Amd7930_bh, cs);
 	cs->dbusytimer.function = (void *) dbusy_timer_handler;
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
diff -puN drivers/isdn/hisax/config.c~remove-double-cast-to-same-type drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/config.c
@@ -1586,7 +1586,7 @@ int hisax_register(struct hisax_d_if *hi
 	hisax_d_if->cs = cs;
 	cs->hw.hisax_d_if = hisax_d_if;
 	cs->cardmsg = hisax_cardmsg;
-	INIT_WORK(&cs->tqueue, (void *)(void *)hisax_bh, cs);
+	INIT_WORK(&cs->tqueue, (void *)hisax_bh, cs);
 	cs->channel[0].d_st->l2.l2l1 = hisax_d_l2l1;
 	for (i = 0; i < 2; i++) {
 		cs->bcs[i].BC_SetStack = hisax_bc_setstack;
diff -puN drivers/isdn/hisax/hfc_2bds0.c~remove-double-cast-to-same-type drivers/isdn/hisax/hfc_2bds0.c
--- a/drivers/isdn/hisax/hfc_2bds0.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/hfc_2bds0.c
@@ -1072,5 +1072,5 @@ set_cs_func(struct IsdnCardState *cs)
 	cs->dbusytimer.function = (void *) hfc_dbusy_timer;
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
-	INIT_WORK(&cs->tqueue, (void *)(void *) hfcd_bh, cs);
+	INIT_WORK(&cs->tqueue, (void *)hfcd_bh, cs);
 }
diff -puN drivers/isdn/hisax/hfc_pci.c~remove-double-cast-to-same-type drivers/isdn/hisax/hfc_pci.c
--- a/drivers/isdn/hisax/hfc_pci.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/hfc_pci.c
@@ -1722,7 +1722,7 @@ setup_hfcpci(struct IsdnCard *card)
 		Write_hfc(cs, HFCPCI_INT_M2, cs->hw.hfcpci.int_m2);
 		/* At this point the needed PCI config is done */
 		/* fifos are still not enabled */
-		INIT_WORK(&cs->tqueue, (void *)(void *) hfcpci_bh, cs);
+		INIT_WORK(&cs->tqueue, (void *)hfcpci_bh, cs);
 		cs->setstack_d = setstack_hfcpci;
 		cs->BC_Send_Data = &hfcpci_send_data;
 		cs->readisac = NULL;
diff -puN drivers/isdn/hisax/hfc_sx.c~remove-double-cast-to-same-type drivers/isdn/hisax/hfc_sx.c
--- a/drivers/isdn/hisax/hfc_sx.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/hfc_sx.c
@@ -1499,7 +1499,7 @@ setup_hfcsx(struct IsdnCard *card)
 	cs->dbusytimer.function = (void *) hfcsx_dbusy_timer;
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
-	INIT_WORK(&cs->tqueue, (void *)(void *) hfcsx_bh, cs);
+	INIT_WORK(&cs->tqueue, (void *)hfcsx_bh, cs);
 	cs->readisac = NULL;
 	cs->writeisac = NULL;
 	cs->readisacfifo = NULL;
diff -puN drivers/isdn/hisax/icc.c~remove-double-cast-to-same-type drivers/isdn/hisax/icc.c
--- a/drivers/isdn/hisax/icc.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/icc.c
@@ -674,7 +674,7 @@ clear_pending_icc_ints(struct IsdnCardSt
 void __devinit
 setup_icc(struct IsdnCardState *cs)
 {
-	INIT_WORK(&cs->tqueue, (void *)(void *) icc_bh, cs);
+	INIT_WORK(&cs->tqueue, (void *)icc_bh, cs);
 	cs->dbusytimer.function = (void *) dbusy_timer_handler;
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
diff -puN drivers/isdn/hisax/isac.c~remove-double-cast-to-same-type drivers/isdn/hisax/isac.c
--- a/drivers/isdn/hisax/isac.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/isac.c
@@ -674,7 +674,7 @@ clear_pending_isac_ints(struct IsdnCardS
 void __devinit
 setup_isac(struct IsdnCardState *cs)
 {
-	INIT_WORK(&cs->tqueue, (void *)(void *) isac_bh, cs);
+	INIT_WORK(&cs->tqueue, (void *)isac_bh, cs);
 	cs->dbusytimer.function = (void *) dbusy_timer_handler;
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
diff -puN drivers/isdn/hisax/isar.c~remove-double-cast-to-same-type drivers/isdn/hisax/isar.c
--- a/drivers/isdn/hisax/isar.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/isar.c
@@ -1580,7 +1580,7 @@ isar_setup(struct IsdnCardState *cs)
 		cs->bcs[i].mode = 0;
 		cs->bcs[i].hw.isar.dpath = i + 1;
 		modeisar(&cs->bcs[i], 0, 0);
-		INIT_WORK(&cs->bcs[i].tqueue, (void *)(void *) isar_bh, &cs->bcs[i]);
+		INIT_WORK(&cs->bcs[i].tqueue, (void *)isar_bh, &cs->bcs[i]);
 	}
 }
 
diff -puN drivers/isdn/hisax/isdnl1.c~remove-double-cast-to-same-type drivers/isdn/hisax/isdnl1.c
--- a/drivers/isdn/hisax/isdnl1.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/isdnl1.c
@@ -362,7 +362,7 @@ init_bcstate(struct IsdnCardState *cs, i
 
 	bcs->cs = cs;
 	bcs->channel = bc;
-	INIT_WORK(&bcs->tqueue, (void *)(void *) BChannel_bh, bcs);
+	INIT_WORK(&bcs->tqueue, (void *)BChannel_bh, bcs);
 	spin_lock_init(&bcs->aclock);
 	bcs->BC_SetStack = NULL;
 	bcs->BC_Close = NULL;
diff -puN drivers/isdn/hisax/w6692.c~remove-double-cast-to-same-type drivers/isdn/hisax/w6692.c
--- a/drivers/isdn/hisax/w6692.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/hisax/w6692.c
@@ -1070,7 +1070,7 @@ setup_w6692(struct IsdnCard *card)
 	       id_list[cs->subtyp].card_name, cs->irq,
 	       cs->hw.w6692.iobase);
 
-	INIT_WORK(&cs->tqueue, (void *)(void *) W6692_bh, cs);
+	INIT_WORK(&cs->tqueue, (void *)W6692_bh, cs);
 	cs->readW6692 = &ReadW6692;
 	cs->writeW6692 = &WriteW6692;
 	cs->readisacfifo = &ReadISACfifo;
diff -puN drivers/isdn/i4l/isdn_net.c~remove-double-cast-to-same-type drivers/isdn/i4l/isdn_net.c
--- a/drivers/isdn/i4l/isdn_net.c~remove-double-cast-to-same-type
+++ a/drivers/isdn/i4l/isdn_net.c
@@ -2596,7 +2596,7 @@ isdn_net_new(char *name, struct net_devi
 	netdev->local->netdev = netdev;
 	netdev->local->next = netdev->local;
 
-	INIT_WORK(&netdev->local->tqueue, (void *)(void *) isdn_net_softint, netdev->local);
+	INIT_WORK(&netdev->local->tqueue, (void *)isdn_net_softint, netdev->local);
 	spin_lock_init(&netdev->local->xmit_lock);
 
 	netdev->local->isdn_device = -1;
diff -puN drivers/net/hamradio/baycom_epp.c~remove-double-cast-to-same-type drivers/net/hamradio/baycom_epp.c
--- a/drivers/net/hamradio/baycom_epp.c~remove-double-cast-to-same-type
+++ a/drivers/net/hamradio/baycom_epp.c
@@ -889,7 +889,7 @@ static int epp_open(struct net_device *d
                 return -EBUSY;
         }
         dev->irq = /*pp->irq*/ 0;
-	INIT_WORK(&bc->run_work, (void *)(void *)epp_bh, dev);
+	INIT_WORK(&bc->run_work, (void *)epp_bh, dev);
 	bc->work_running = 1;
 	bc->modem = EPP_CONVENTIONAL;
 	if (eppconfig(bc))
diff -puN fs/cifs/connect.c~remove-double-cast-to-same-type fs/cifs/connect.c
--- a/fs/cifs/connect.c~remove-double-cast-to-same-type
+++ a/fs/cifs/connect.c
@@ -1780,7 +1780,7 @@ cifs_mount(struct super_block *sb, struc
 			so no need to spinlock this init of tcpStatus */
 			srvTcp->tcpStatus = CifsNew;
 			init_MUTEX(&srvTcp->tcpSem);
-			rc = (int)kernel_thread((void *)(void *)cifs_demultiplex_thread, srvTcp,
+			rc = kernel_thread((void *)cifs_demultiplex_thread, srvTcp,
 				      CLONE_FS | CLONE_FILES | CLONE_VM);
 			if(rc < 0) {
 				rc = -ENOMEM;
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-acpi.patch
constify-inode-accessors.patch
remove-double-cast-to-same-type.patch
pull-in-necessary-header-files-for-cdevh.patch
new-updated-devicestxt-lanana.patch

