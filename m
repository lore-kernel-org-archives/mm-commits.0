From: akpm@osdl.org
Subject: - isdn-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:50 -0800
Message-ID: <200612082010.kB8KAod0002854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59657 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946789AbWLHUOI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     isdn-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>

Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/act2000/module.c       |    3 +--
 drivers/isdn/capi/capi.c            |    9 +++------
 drivers/isdn/capi/capidrv.c         |    9 +++------
 drivers/isdn/hardware/avm/avm_cs.c  |    3 +--
 drivers/isdn/hardware/avm/b1.c      |   10 +++-------
 drivers/isdn/hisax/avma1_cs.c       |    3 +--
 drivers/isdn/hisax/config.c         |    3 +--
 drivers/isdn/hisax/elsa_cs.c        |    3 +--
 drivers/isdn/hisax/fsm.c            |    4 +---
 drivers/isdn/hisax/hfc4s8s_l1.c     |    3 +--
 drivers/isdn/hisax/hfc_usb.c        |    3 +--
 drivers/isdn/hisax/hisax_fcpcipnp.c |    4 +---
 drivers/isdn/hisax/sedlbauer_cs.c   |    3 +--
 drivers/isdn/hisax/st5481_init.c    |    4 +---
 drivers/isdn/hisax/teles_cs.c       |    3 +--
 drivers/isdn/hysdn/hycapi.c         |    3 +--
 drivers/isdn/hysdn/hysdn_boot.c     |    3 +--
 drivers/isdn/hysdn/hysdn_init.c     |    3 +--
 drivers/isdn/hysdn/hysdn_net.c      |    3 +--
 drivers/isdn/hysdn/hysdn_proclog.c  |    3 +--
 drivers/isdn/i4l/isdn_bsdcomp.c     |    4 +---
 drivers/isdn/i4l/isdn_common.c      |    9 +++------
 drivers/isdn/i4l/isdn_net.c         |    6 ++----
 drivers/isdn/i4l/isdn_ppp.c         |   14 ++++----------
 drivers/isdn/i4l/isdn_v110.c        |    3 +--
 drivers/isdn/icn/icn.c              |    3 +--
 drivers/isdn/isdnloop/isdnloop.c    |    3 +--
 drivers/isdn/pcbit/drv.c            |    9 +++------
 drivers/isdn/pcbit/layer2.c         |    3 +--
 drivers/isdn/sc/init.c              |    9 +++------
 30 files changed, 46 insertions(+), 99 deletions(-)

diff -puN drivers/isdn/act2000/module.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/act2000/module.c
--- a/drivers/isdn/act2000/module.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/act2000/module.c
@@ -573,12 +573,11 @@ act2000_alloccard(int bus, int port, int
 {
 	int i;
         act2000_card *card;
-        if (!(card = (act2000_card *) kmalloc(sizeof(act2000_card), GFP_KERNEL))) {
+        if (!(card = kzalloc(sizeof(act2000_card), GFP_KERNEL))) {
                 printk(KERN_WARNING
 		       "act2000: (%s) Could not allocate card-struct.\n", id);
                 return;
         }
-        memset((char *) card, 0, sizeof(act2000_card));
         spin_lock_init(&card->lock);
         spin_lock_init(&card->mnlock);
 	skb_queue_head_init(&card->sndq);
diff -puN drivers/isdn/capi/capi.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/capi/capi.c
@@ -215,13 +215,12 @@ static struct capiminor *capiminor_alloc
 	unsigned int minor = 0;
 	unsigned long flags;
 
-	mp = kmalloc(sizeof(*mp), GFP_ATOMIC);
+	mp = kzalloc(sizeof(*mp), GFP_ATOMIC);
   	if (!mp) {
   		printk(KERN_ERR "capi: can't alloc capiminor\n");
 		return NULL;
 	}
 
-	memset(mp, 0, sizeof(struct capiminor));
 	mp->ap = ap;
 	mp->ncci = ncci;
 	mp->msgid = 0;
@@ -304,10 +303,9 @@ static struct capincci *capincci_alloc(s
 	struct capiminor *mp = NULL;
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 
-	np = kmalloc(sizeof(*np), GFP_ATOMIC);
+	np = kzalloc(sizeof(*np), GFP_ATOMIC);
 	if (!np)
 		return NULL;
-	memset(np, 0, sizeof(struct capincci));
 	np->ncci = ncci;
 	np->cdev = cdev;
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
@@ -384,10 +382,9 @@ static struct capidev *capidev_alloc(voi
 	struct capidev *cdev;
 	unsigned long flags;
 
-	cdev = kmalloc(sizeof(*cdev), GFP_KERNEL);
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
 		return NULL;
-	memset(cdev, 0, sizeof(struct capidev));
 
 	init_MUTEX(&cdev->ncci_list_sem);
 	skb_queue_head_init(&cdev->recvqueue);
diff -puN drivers/isdn/capi/capidrv.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/capi/capidrv.c
@@ -334,12 +334,11 @@ static capidrv_plci *new_plci(capidrv_co
 {
 	capidrv_plci *plcip;
 
-	plcip = (capidrv_plci *) kmalloc(sizeof(capidrv_plci), GFP_ATOMIC);
+	plcip = kzalloc(sizeof(capidrv_plci), GFP_ATOMIC);
 
 	if (plcip == 0)
 		return NULL;
 
-	memset(plcip, 0, sizeof(capidrv_plci));
 	plcip->state = ST_PLCI_NONE;
 	plcip->plci = 0;
 	plcip->msgid = 0;
@@ -404,12 +403,11 @@ static inline capidrv_ncci *new_ncci(cap
 {
 	capidrv_ncci *nccip;
 
-	nccip = (capidrv_ncci *) kmalloc(sizeof(capidrv_ncci), GFP_ATOMIC);
+	nccip = kzalloc(sizeof(capidrv_ncci), GFP_ATOMIC);
 
 	if (nccip == 0)
 		return NULL;
 
-	memset(nccip, 0, sizeof(capidrv_ncci));
 	nccip->ncci = ncci;
 	nccip->state = ST_NCCI_NONE;
 	nccip->plcip = plcip;
@@ -2005,12 +2003,11 @@ static int capidrv_addcontr(u16 contr, s
 		printk(KERN_WARNING "capidrv: (%s) Could not reserve module\n", id);
 		return -1;
 	}
-	if (!(card = (capidrv_contr *) kmalloc(sizeof(capidrv_contr), GFP_ATOMIC))) {
+	if (!(card = kzalloc(sizeof(capidrv_contr), GFP_ATOMIC))) {
 		printk(KERN_WARNING
 		 "capidrv: (%s) Could not allocate contr-struct.\n", id);
 		return -1;
 	}
-	memset(card, 0, sizeof(capidrv_contr));
 	card->owner = THIS_MODULE;
 	init_timer(&card->listentimer);
 	strcpy(card->name, id);
diff -puN drivers/isdn/hardware/avm/avm_cs.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hardware/avm/avm_cs.c
--- a/drivers/isdn/hardware/avm/avm_cs.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hardware/avm/avm_cs.c
@@ -121,10 +121,9 @@ static int avmcs_probe(struct pcmcia_dev
     p_dev->conf.Present = PRESENT_OPTION;
 
     /* Allocate space for private device-specific data */
-    local = kmalloc(sizeof(local_info_t), GFP_KERNEL);
+    local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
     if (!local)
         goto err;
-    memset(local, 0, sizeof(local_info_t));
     p_dev->priv = local;
 
     return avmcs_config(p_dev);
diff -puN drivers/isdn/hardware/avm/b1.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hardware/avm/b1.c
--- a/drivers/isdn/hardware/avm/b1.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hardware/avm/b1.c
@@ -65,18 +65,15 @@ avmcard *b1_alloc_card(int nr_controller
 	avmctrl_info *cinfo;
 	int i;
 
-	card = kmalloc(sizeof(*card), GFP_KERNEL);
+	card = kzalloc(sizeof(*card), GFP_KERNEL);
 	if (!card)
 		return NULL;
 
-	memset(card, 0, sizeof(*card));
-
-        cinfo = kmalloc(sizeof(*cinfo) * nr_controllers, GFP_KERNEL);
+	cinfo = kzalloc(sizeof(*cinfo) * nr_controllers, GFP_KERNEL);
 	if (!cinfo) {
 		kfree(card);
 		return NULL;
 	}
-	memset(cinfo, 0, sizeof(*cinfo) * nr_controllers);
 
 	card->ctrlinfo = cinfo;
 	for (i = 0; i < nr_controllers; i++) {
@@ -718,12 +715,11 @@ avmcard_dma_alloc(char *name, struct pci
 	avmcard_dmainfo *p;
 	void *buf;
 
-	p = kmalloc(sizeof(avmcard_dmainfo), GFP_KERNEL);
+	p = kzalloc(sizeof(avmcard_dmainfo), GFP_KERNEL);
 	if (!p) {
 		printk(KERN_WARNING "%s: no memory.\n", name);
 		goto err;
 	}
-	memset(p, 0, sizeof(avmcard_dmainfo));
 
 	p->recvbuf.size = rsize;
 	buf = pci_alloc_consistent(pdev, rsize, &p->recvbuf.dmaaddr);
diff -puN drivers/isdn/hisax/avma1_cs.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/avma1_cs.c
--- a/drivers/isdn/hisax/avma1_cs.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/avma1_cs.c
@@ -123,11 +123,10 @@ static int avma1cs_probe(struct pcmcia_d
     DEBUG(0, "avma1cs_attach()\n");
 
     /* Allocate space for private device-specific data */
-    local = kmalloc(sizeof(local_info_t), GFP_KERNEL);
+    local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
     if (!local)
 	return -ENOMEM;
 
-    memset(local, 0, sizeof(local_info_t));
     p_dev->priv = local;
 
     /* The io structure describes IO port mapping */
diff -puN drivers/isdn/hisax/config.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/config.c
@@ -869,14 +869,13 @@ static int checkcard(int cardnr, char *i
 	struct IsdnCard *card = cards + cardnr;
 	struct IsdnCardState *cs;
 
-	cs = kmalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
+	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
 	if (!cs) {
 		printk(KERN_WARNING
 		       "HiSax: No memory for IsdnCardState(card %d)\n",
 		       cardnr + 1);
 		goto out;
 	}
-	memset(cs, 0, sizeof(struct IsdnCardState));
 	card->cs = cs;
 	spin_lock_init(&cs->statlock);
 	spin_lock_init(&cs->lock);
diff -puN drivers/isdn/hisax/elsa_cs.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/elsa_cs.c
--- a/drivers/isdn/hisax/elsa_cs.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/elsa_cs.c
@@ -146,9 +146,8 @@ static int elsa_cs_probe(struct pcmcia_d
     DEBUG(0, "elsa_cs_attach()\n");
 
     /* Allocate space for private device-specific data */
-    local = kmalloc(sizeof(local_info_t), GFP_KERNEL);
+    local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
     if (!local) return -ENOMEM;
-    memset(local, 0, sizeof(local_info_t));
 
     local->p_dev = link;
     link->priv = local;
diff -puN drivers/isdn/hisax/fsm.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/fsm.c
--- a/drivers/isdn/hisax/fsm.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/fsm.c
@@ -26,12 +26,10 @@ FsmNew(struct Fsm *fsm, struct FsmNode *
 	int i;
 
 	fsm->jumpmatrix = (FSMFNPTR *)
-		kmalloc(sizeof (FSMFNPTR) * fsm->state_count * fsm->event_count, GFP_KERNEL);
+		kzalloc(sizeof (FSMFNPTR) * fsm->state_count * fsm->event_count, GFP_KERNEL);
 	if (!fsm->jumpmatrix)
 		return -ENOMEM;
 
-	memset(fsm->jumpmatrix, 0, sizeof (FSMFNPTR) * fsm->state_count * fsm->event_count);
-
 	for (i = 0; i < fncount; i++) 
 		if ((fnlist[i].state>=fsm->state_count) || (fnlist[i].event>=fsm->event_count)) {
 			printk(KERN_ERR "FsmNew Error line %d st(%ld/%ld) ev(%ld/%ld)\n",
diff -puN drivers/isdn/hisax/hfc4s8s_l1.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/hfc4s8s_l1.c
--- a/drivers/isdn/hisax/hfc4s8s_l1.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/hfc4s8s_l1.c
@@ -1591,11 +1591,10 @@ hfc4s8s_probe(struct pci_dev *pdev, cons
 	hfc4s8s_param *driver_data = (hfc4s8s_param *) ent->driver_data;
 	hfc4s8s_hw *hw;
 
-	if (!(hw = kmalloc(sizeof(hfc4s8s_hw), GFP_ATOMIC))) {
+	if (!(hw = kzalloc(sizeof(hfc4s8s_hw), GFP_ATOMIC))) {
 		printk(KERN_ERR "No kmem for HFC-4S/8S card\n");
 		return (err);
 	}
-	memset(hw, 0, sizeof(hfc4s8s_hw));
 
 	hw->pdev = pdev;
 	err = pci_enable_device(pdev);
diff -puN drivers/isdn/hisax/hfc_usb.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/hfc_usb.c
--- a/drivers/isdn/hisax/hfc_usb.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/hfc_usb.c
@@ -1481,9 +1481,8 @@ hfc_usb_probe(struct usb_interface *intf
 			iface = iface_used;
 			if (!
 			    (context =
-			     kmalloc(sizeof(hfcusb_data), GFP_KERNEL)))
+			     kzalloc(sizeof(hfcusb_data), GFP_KERNEL)))
 				return (-ENOMEM);	/* got no mem */
-			memset(context, 0, sizeof(hfcusb_data));
 
 			ep = iface->endpoint;
 			vcf = validconf[small_match];
diff -puN drivers/isdn/hisax/hisax_fcpcipnp.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/hisax_fcpcipnp.c
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -841,12 +841,10 @@ new_adapter(void)
 	struct hisax_b_if *b_if[2];
 	int i;
 
-	adapter = kmalloc(sizeof(struct fritz_adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(struct fritz_adapter), GFP_KERNEL);
 	if (!adapter)
 		return NULL;
 
-	memset(adapter, 0, sizeof(struct fritz_adapter));
-
 	adapter->isac.hisax_d_if.owner = THIS_MODULE;
 	adapter->isac.hisax_d_if.ifc.priv = &adapter->isac;
 	adapter->isac.hisax_d_if.ifc.l2l1 = isac_d_l2l1;
diff -puN drivers/isdn/hisax/sedlbauer_cs.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/sedlbauer_cs.c
--- a/drivers/isdn/hisax/sedlbauer_cs.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/sedlbauer_cs.c
@@ -155,9 +155,8 @@ static int sedlbauer_probe(struct pcmcia
     DEBUG(0, "sedlbauer_attach()\n");
 
     /* Allocate space for private device-specific data */
-    local = kmalloc(sizeof(local_info_t), GFP_KERNEL);
+    local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
     if (!local) return -ENOMEM;
-    memset(local, 0, sizeof(local_info_t));
     local->cardnr = -1;
 
     local->p_dev = link;
diff -puN drivers/isdn/hisax/st5481_init.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/st5481_init.c
--- a/drivers/isdn/hisax/st5481_init.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/st5481_init.c
@@ -69,12 +69,10 @@ static int probe_st5481(struct usb_inter
 	     le16_to_cpu(dev->descriptor.idProduct),
 	     number_of_leds);
 
-	adapter = kmalloc(sizeof(struct st5481_adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(struct st5481_adapter), GFP_KERNEL);
 	if (!adapter)
 		return -ENOMEM;
 
-	memset(adapter, 0, sizeof(struct st5481_adapter));
-
 	adapter->number_of_leds = number_of_leds;
 	adapter->usb_dev = dev;
 
diff -puN drivers/isdn/hisax/teles_cs.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hisax/teles_cs.c
--- a/drivers/isdn/hisax/teles_cs.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hisax/teles_cs.c
@@ -137,9 +137,8 @@ static int teles_probe(struct pcmcia_dev
     DEBUG(0, "teles_attach()\n");
 
     /* Allocate space for private device-specific data */
-    local = kmalloc(sizeof(local_info_t), GFP_KERNEL);
+    local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
     if (!local) return -ENOMEM;
-    memset(local, 0, sizeof(local_info_t));
     local->cardnr = -1;
 
     local->p_dev = link;
diff -puN drivers/isdn/hysdn/hycapi.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hysdn/hycapi.c
--- a/drivers/isdn/hysdn/hycapi.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hysdn/hycapi.c
@@ -745,12 +745,11 @@ hycapi_capi_create(hysdn_card *card)
 		return 1;
 	}
 	if (!card->hyctrlinfo) {
-		cinfo = (hycapictrl_info *) kmalloc(sizeof(hycapictrl_info), GFP_ATOMIC);
+		cinfo = kzalloc(sizeof(hycapictrl_info), GFP_ATOMIC);
 		if (!cinfo) {
 			printk(KERN_WARNING "HYSDN: no memory for capi-ctrl.\n");
 			return -ENOMEM;
 		}
-		memset(cinfo, 0, sizeof(hycapictrl_info));
 		card->hyctrlinfo = cinfo;
 		cinfo->card = card;
 		spin_lock_init(&cinfo->lock);
diff -puN drivers/isdn/hysdn/hysdn_boot.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hysdn/hysdn_boot.c
--- a/drivers/isdn/hysdn/hysdn_boot.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hysdn/hysdn_boot.c
@@ -278,14 +278,13 @@ pof_write_open(hysdn_card * card, unsign
 		return (-ERR_ALREADY_BOOT);	/* boot already active */
 	}
 	/* error no mem available */
-	if (!(boot = kmalloc(sizeof(struct boot_data), GFP_KERNEL))) {
+	if (!(boot = kzalloc(sizeof(struct boot_data), GFP_KERNEL))) {
 		if (card->debug_flags & LOG_MEM_ERR)
 			hysdn_addlog(card, "POF open: unable to allocate mem");
 		return (-EFAULT);
 	}
 	card->boot = boot;
 	card->state = CARD_STATE_BOOTING;
-	memset(boot, 0, sizeof(struct boot_data));
 
 	card->stopcard(card);	/* first stop the card */
 	if (card->testram(card)) {
diff -puN drivers/isdn/hysdn/hysdn_init.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hysdn/hysdn_init.c
--- a/drivers/isdn/hysdn/hysdn_init.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hysdn/hysdn_init.c
@@ -81,11 +81,10 @@ search_cards(void)
 		if (pci_enable_device(akt_pcidev))
 			continue;
 
-		if (!(card = kmalloc(sizeof(hysdn_card), GFP_KERNEL))) {
+		if (!(card = kzalloc(sizeof(hysdn_card), GFP_KERNEL))) {
 			printk(KERN_ERR "HYSDN: unable to alloc device mem \n");
 			return;
 		}
-		memset(card, 0, sizeof(hysdn_card));
 		card->myid = cardmax;	/* set own id */
 		card->bus = akt_pcidev->bus->number;
 		card->devfn = akt_pcidev->devfn;	/* slot + function */
diff -puN drivers/isdn/hysdn/hysdn_net.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hysdn/hysdn_net.c
--- a/drivers/isdn/hysdn/hysdn_net.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hysdn/hysdn_net.c
@@ -278,11 +278,10 @@ hysdn_net_create(hysdn_card * card)
 		return (-ENOMEM);
 	}
 	hysdn_net_release(card);	/* release an existing net device */
-	if ((dev = kmalloc(sizeof(struct net_local), GFP_KERNEL)) == NULL) {
+	if ((dev = kzalloc(sizeof(struct net_local), GFP_KERNEL)) == NULL) {
 		printk(KERN_WARNING "HYSDN: unable to allocate mem\n");
 		return (-ENOMEM);
 	}
-	memset(dev, 0, sizeof(struct net_local));	/* clean the structure */
 
 	spin_lock_init(&((struct net_local *) dev)->lock);
 
diff -puN drivers/isdn/hysdn/hysdn_proclog.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -405,8 +405,7 @@ hysdn_proclog_init(hysdn_card * card)
 
 	/* create a cardlog proc entry */
 
-	if ((pd = (struct procdata *) kmalloc(sizeof(struct procdata), GFP_KERNEL)) != NULL) {
-		memset(pd, 0, sizeof(struct procdata));
+	if ((pd = kzalloc(sizeof(struct procdata), GFP_KERNEL)) != NULL) {
 		sprintf(pd->log_name, "%s%d", PROC_LOG_BASENAME, card->myid);
 		if ((pd->log = create_proc_entry(pd->log_name, S_IFREG | S_IRUGO | S_IWUSR, hysdn_proc_entry)) != NULL) {
 		        pd->log->proc_fops = &log_fops; 
diff -puN drivers/isdn/i4l/isdn_bsdcomp.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/i4l/isdn_bsdcomp.c
--- a/drivers/isdn/i4l/isdn_bsdcomp.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -331,12 +331,10 @@ static void *bsd_alloc (struct isdn_ppp_
 	 * Allocate the main control structure for this instance.
 	 */
 	maxmaxcode = MAXCODE(bits);
-	db = (struct bsd_db *) kmalloc (sizeof (struct bsd_db),GFP_KERNEL);
+	db = kzalloc (sizeof (struct bsd_db),GFP_KERNEL);
 	if (!db)
 		return NULL;
 
-	memset (db, 0, sizeof(struct bsd_db));
-
 	db->xmit = data->flags & IPPP_COMP_FLAG_XMIT;
 	decomp = db->xmit ? 0 : 1;
 
diff -puN drivers/isdn/i4l/isdn_common.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -2072,21 +2072,19 @@ isdn_add_channels(isdn_driver_t *d, int 
 
 	if ((adding) && (d->rcverr))
 		kfree(d->rcverr);
-	if (!(d->rcverr = kmalloc(sizeof(int) * m, GFP_ATOMIC))) {
+	if (!(d->rcverr = kzalloc(sizeof(int) * m, GFP_ATOMIC))) {
 		printk(KERN_WARNING "register_isdn: Could not alloc rcverr\n");
 		return -1;
 	}
-	memset((char *) d->rcverr, 0, sizeof(int) * m);
 
 	if ((adding) && (d->rcvcount))
 		kfree(d->rcvcount);
-	if (!(d->rcvcount = kmalloc(sizeof(int) * m, GFP_ATOMIC))) {
+	if (!(d->rcvcount = kzalloc(sizeof(int) * m, GFP_ATOMIC))) {
 		printk(KERN_WARNING "register_isdn: Could not alloc rcvcount\n");
 		if (!adding)
 			kfree(d->rcverr);
 		return -1;
 	}
-	memset((char *) d->rcvcount, 0, sizeof(int) * m);
 
 	if ((adding) && (d->rpqueue)) {
 		for (j = 0; j < d->channels; j++)
@@ -2226,11 +2224,10 @@ register_isdn(isdn_if * i)
 		printk(KERN_WARNING "register_isdn: No write routine given.\n");
 		return 0;
 	}
-	if (!(d = kmalloc(sizeof(isdn_driver_t), GFP_KERNEL))) {
+	if (!(d = kzalloc(sizeof(isdn_driver_t), GFP_KERNEL))) {
 		printk(KERN_WARNING "register_isdn: Could not alloc driver-struct\n");
 		return 0;
 	}
-	memset((char *) d, 0, sizeof(isdn_driver_t));
 
 	d->maxbufsize = i->maxbufsize;
 	d->pktcount = 0;
diff -puN drivers/isdn/i4l/isdn_net.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/i4l/isdn_net.c
--- a/drivers/isdn/i4l/isdn_net.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/i4l/isdn_net.c
@@ -2542,17 +2542,15 @@ isdn_net_new(char *name, struct net_devi
 		printk(KERN_WARNING "isdn_net: interface %s already exists\n", name);
 		return NULL;
 	}
-	if (!(netdev = (isdn_net_dev *) kmalloc(sizeof(isdn_net_dev), GFP_KERNEL))) {
+	if (!(netdev = kzalloc(sizeof(isdn_net_dev), GFP_KERNEL))) {
 		printk(KERN_WARNING "isdn_net: Could not allocate net-device\n");
 		return NULL;
 	}
-	memset(netdev, 0, sizeof(isdn_net_dev));
-	if (!(netdev->local = (isdn_net_local *) kmalloc(sizeof(isdn_net_local), GFP_KERNEL))) {
+	if (!(netdev->local = kzalloc(sizeof(isdn_net_local), GFP_KERNEL))) {
 		printk(KERN_WARNING "isdn_net: Could not allocate device locals\n");
 		kfree(netdev);
 		return NULL;
 	}
-	memset(netdev->local, 0, sizeof(isdn_net_local));
 	if (name == NULL)
 		strcpy(netdev->local->name, "         ");
 	else
diff -puN drivers/isdn/i4l/isdn_ppp.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/i4l/isdn_ppp.c
--- a/drivers/isdn/i4l/isdn_ppp.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/i4l/isdn_ppp.c
@@ -876,14 +876,12 @@ isdn_ppp_init(void)
 #endif /* CONFIG_ISDN_MPP */
 
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
-		if (!(ippp_table[i] = (struct ippp_struct *)
-		      kmalloc(sizeof(struct ippp_struct), GFP_KERNEL))) {
+		if (!(ippp_table[i] = kzalloc(sizeof(struct ippp_struct), GFP_KERNEL))) {
 			printk(KERN_WARNING "isdn_ppp_init: Could not alloc ippp_table\n");
 			for (j = 0; j < i; j++)
 				kfree(ippp_table[j]);
 			return -1;
 		}
-		memset((char *) ippp_table[i], 0, sizeof(struct ippp_struct));
 		spin_lock_init(&ippp_table[i]->buflock);
 		ippp_table[i]->state = 0;
 		ippp_table[i]->first = ippp_table[i]->rq + NUM_RCV_BUFFS - 1;
@@ -1529,10 +1527,8 @@ static int isdn_ppp_mp_bundle_array_init
 {
 	int i;
 	int sz = ISDN_MAX_CHANNELS*sizeof(ippp_bundle);
-	if( (isdn_ppp_bundle_arr = (ippp_bundle*)kmalloc(sz, 
-							GFP_KERNEL)) == NULL )
+	if( (isdn_ppp_bundle_arr = kzalloc(sz, GFP_KERNEL)) == NULL )
 		return -ENOMEM;
-	memset(isdn_ppp_bundle_arr, 0, sz);
 	for( i = 0; i < ISDN_MAX_CHANNELS; i++ )
 		spin_lock_init(&isdn_ppp_bundle_arr[i].lock);
 	return 0;
@@ -2246,13 +2242,12 @@ static void isdn_ppp_ccp_xmit_reset(stru
 static struct ippp_ccp_reset *isdn_ppp_ccp_reset_alloc(struct ippp_struct *is)
 {
 	struct ippp_ccp_reset *r;
-	r = kmalloc(sizeof(struct ippp_ccp_reset), GFP_KERNEL);
+	r = kzalloc(sizeof(struct ippp_ccp_reset), GFP_KERNEL);
 	if(!r) {
 		printk(KERN_ERR "ippp_ccp: failed to allocate reset data"
 		       " structure - no mem\n");
 		return NULL;
 	}
-	memset(r, 0, sizeof(struct ippp_ccp_reset));
 	printk(KERN_DEBUG "ippp_ccp: allocated reset data structure %p\n", r);
 	is->reset = r;
 	return r;
@@ -2338,10 +2333,9 @@ static struct ippp_ccp_reset_state *isdn
 		       id);
 		return NULL;
 	} else {
-		rs = kmalloc(sizeof(struct ippp_ccp_reset_state), GFP_KERNEL);
+		rs = kzalloc(sizeof(struct ippp_ccp_reset_state), GFP_KERNEL);
 		if(!rs)
 			return NULL;
-		memset(rs, 0, sizeof(struct ippp_ccp_reset_state));
 		rs->state = CCPResetIdle;
 		rs->is = is;
 		rs->id = id;
diff -puN drivers/isdn/i4l/isdn_v110.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/i4l/isdn_v110.c
--- a/drivers/isdn/i4l/isdn_v110.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/i4l/isdn_v110.c
@@ -92,9 +92,8 @@ isdn_v110_open(unsigned char key, int hd
 	int i;
 	isdn_v110_stream *v;
 
-	if ((v = kmalloc(sizeof(isdn_v110_stream), GFP_ATOMIC)) == NULL)
+	if ((v = kzalloc(sizeof(isdn_v110_stream), GFP_ATOMIC)) == NULL)
 		return NULL;
-	memset(v, 0, sizeof(isdn_v110_stream));
 	v->key = key;
 	v->nbits = 0;
 	for (i = 0; key & (1 << i); i++)
diff -puN drivers/isdn/icn/icn.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/icn/icn.c
--- a/drivers/isdn/icn/icn.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/icn/icn.c
@@ -1519,12 +1519,11 @@ icn_initcard(int port, char *id)
 	icn_card *card;
 	int i;
 
-	if (!(card = (icn_card *) kmalloc(sizeof(icn_card), GFP_KERNEL))) {
+	if (!(card = kzalloc(sizeof(icn_card), GFP_KERNEL))) {
 		printk(KERN_WARNING
 		       "icn: (%s) Could not allocate card-struct.\n", id);
 		return (icn_card *) 0;
 	}
-	memset((char *) card, 0, sizeof(icn_card));
 	spin_lock_init(&card->lock);
 	card->port = port;
 	card->interface.owner = THIS_MODULE;
diff -puN drivers/isdn/isdnloop/isdnloop.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/isdnloop/isdnloop.c
@@ -1430,12 +1430,11 @@ isdnloop_initcard(char *id)
 	isdnloop_card *card;
 	int i;
 
-	if (!(card = (isdnloop_card *) kmalloc(sizeof(isdnloop_card), GFP_KERNEL))) {
+	if (!(card = kzalloc(sizeof(isdnloop_card), GFP_KERNEL))) {
 		printk(KERN_WARNING
 		 "isdnloop: (%s) Could not allocate card-struct.\n", id);
 		return (isdnloop_card *) 0;
 	}
-	memset((char *) card, 0, sizeof(isdnloop_card));
 	card->interface.owner = THIS_MODULE;
 	card->interface.channels = ISDNLOOP_BCH;
 	card->interface.hl_hdrlen  = 1; /* scratch area for storing ack flag*/ 
diff -puN drivers/isdn/pcbit/drv.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/pcbit/drv.c
--- a/drivers/isdn/pcbit/drv.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/pcbit/drv.c
@@ -73,14 +73,13 @@ int pcbit_init_dev(int board, int mem_ba
 	struct pcbit_dev *dev;
 	isdn_if *dev_if;
 
-	if ((dev=kmalloc(sizeof(struct pcbit_dev), GFP_KERNEL)) == NULL)
+	if ((dev=kzalloc(sizeof(struct pcbit_dev), GFP_KERNEL)) == NULL)
 	{
 		printk("pcbit_init: couldn't malloc pcbit_dev struct\n");
 		return -ENOMEM;
 	}
 
 	dev_pcbit[board] = dev;
-	memset(dev, 0, sizeof(struct pcbit_dev));
 	init_waitqueue_head(&dev->set_running_wq);
 	spin_lock_init(&dev->lock);
 
@@ -104,7 +103,7 @@ int pcbit_init_dev(int board, int mem_ba
 		return -EACCES;
 	}
 
-	dev->b1 = kmalloc(sizeof(struct pcbit_chan), GFP_KERNEL);
+	dev->b1 = kzalloc(sizeof(struct pcbit_chan), GFP_KERNEL);
 	if (!dev->b1) {
 		printk("pcbit_init: couldn't malloc pcbit_chan struct\n");
 		iounmap(dev->sh_mem);
@@ -113,7 +112,7 @@ int pcbit_init_dev(int board, int mem_ba
 		return -ENOMEM;
 	}
     
-	dev->b2 = kmalloc(sizeof(struct pcbit_chan), GFP_KERNEL);
+	dev->b2 = kzalloc(sizeof(struct pcbit_chan), GFP_KERNEL);
 	if (!dev->b2) {
 		printk("pcbit_init: couldn't malloc pcbit_chan struct\n");
 		kfree(dev->b1);
@@ -123,8 +122,6 @@ int pcbit_init_dev(int board, int mem_ba
 		return -ENOMEM;
 	}
 
-	memset(dev->b1, 0, sizeof(struct pcbit_chan));
-	memset(dev->b2, 0, sizeof(struct pcbit_chan));
 	dev->b2->id = 1;
 
 	INIT_WORK(&dev->qdelivery, pcbit_deliver);
diff -puN drivers/isdn/pcbit/layer2.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/pcbit/layer2.c
--- a/drivers/isdn/pcbit/layer2.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/pcbit/layer2.c
@@ -369,13 +369,12 @@ pcbit_receive(struct pcbit_dev *dev)
 			kfree(dev->read_frame);
 			dev->read_frame = NULL;
 		}
-		frame = kmalloc(sizeof(struct frame_buf), GFP_ATOMIC);
+		frame = kzalloc(sizeof(struct frame_buf), GFP_ATOMIC);
 
 		if (frame == NULL) {
 			printk(KERN_WARNING "kmalloc failed\n");
 			return;
 		}
-		memset(frame, 0, sizeof(struct frame_buf));
 
 		cpu = pcbit_readb(dev);
 		proc = pcbit_readb(dev);
diff -puN drivers/isdn/sc/init.c~isdn-replace-kmallocmemset-with-kzalloc drivers/isdn/sc/init.c
--- a/drivers/isdn/sc/init.c~isdn-replace-kmallocmemset-with-kzalloc
+++ a/drivers/isdn/sc/init.c
@@ -271,14 +271,13 @@ static int __init sc_init(void)
 		 * Horray! We found a board, Make sure we can register
 		 * it with ISDN4Linux
 		 */
-		interface = kmalloc(sizeof(isdn_if), GFP_KERNEL);
+		interface = kzalloc(sizeof(isdn_if), GFP_KERNEL);
 		if (interface == NULL) {
 			/*
 			 * Oops, can't malloc isdn_if
 			 */
 			continue;
 		}
-		memset(interface, 0, sizeof(isdn_if));
 
 		interface->owner = THIS_MODULE;
 		interface->hl_hdrlen = 0;
@@ -294,7 +293,7 @@ static int __init sc_init(void)
 		/*
 		 * Allocate the board structure
 		 */
-		sc_adapter[cinst] = kmalloc(sizeof(board), GFP_KERNEL);
+		sc_adapter[cinst] = kzalloc(sizeof(board), GFP_KERNEL);
 		if (sc_adapter[cinst] == NULL) {
 			/*
 			 * Oops, can't alloc memory for the board
@@ -302,7 +301,6 @@ static int __init sc_init(void)
 			kfree(interface);
 			continue;
 		}
-		memset(sc_adapter[cinst], 0, sizeof(board));
 		spin_lock_init(&sc_adapter[cinst]->lock);
 
 		if(!register_isdn(interface)) {
@@ -326,7 +324,7 @@ static int __init sc_init(void)
 		/*
 		 * Allocate channels status structures
 		 */
-		sc_adapter[cinst]->channel = kmalloc(sizeof(bchan) * channels, GFP_KERNEL);
+		sc_adapter[cinst]->channel = kzalloc(sizeof(bchan) * channels, GFP_KERNEL);
 		if (sc_adapter[cinst]->channel == NULL) {
 			/*
 			 * Oops, can't alloc memory for the channels
@@ -336,7 +334,6 @@ static int __init sc_init(void)
 			kfree(sc_adapter[cinst]);
 			continue;
 		}
-		memset(sc_adapter[cinst]->channel, 0, sizeof(bchan) * channels);
 
 		/*
 		 * Lock down the hardware resources
_

Patches currently in -mm which might be from yan_952@hotmail.com are

origin.patch
isdn-replace-kmallocmemset-with-kzalloc.patch
acpi-replace-kmallocmemset-with-kzalloc.patch
git-mtd.patch
serial-replace-kmallocmemset-with-kzalloc.patch
usb-auerswald-replace-kmallocmemset-with-kzalloc.patch

