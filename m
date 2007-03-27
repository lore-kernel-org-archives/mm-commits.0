From: akpm@linux-foundation.org
Subject: - resend-iphase-64bit-cleanup.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:57:12 -0800
Message-ID: <200703270557.l2R5vCRm008575@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934054AbXC0F50 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     iPhase: 64bit cleanup
has been removed from the -mm tree.  Its filename was
     resend-iphase-64bit-cleanup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: iPhase: 64bit cleanup
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>

Date: Thu, 09 Nov 2006 16:12:30 -0800 (PST)

This fixes the most obvious 64-bit problems, but it is still very very
broken in other aspects.  It is bad enough that I feel irresponsible
turning it on in the 64-bit build.

For example, it takes an ioremap()'d value, and accesses it as a
regular cpu pointer which will explode on many architectures since
all such accesses should go through asm/io.h accessors.

Specifically I'm talking about dev->seg_ram, it is initialized like
this:

	base = ioremap(real_base,iadev->pci_map_size);  /* ioremap is not resolved ??? */  
 ...
	iadev->seg_ram = base + ACTUAL_SEG_RAM_BASE;  
 ...

Then used like this:

     desc1 = *(u_short *)(dev->seg_ram + dev->host_tcq_wr);

and this:

        *(u_short *) (dev->seg_ram + dev->host_tcq_wr) = 0;

and this:

           *(u_short *)(dev->seg_ram + dev->ffL.tcq_rd) = i+1;

and this:

  desc_num = *(u_short *)(dev->seg_ram + dev->ffL.tcq_rd);

and this:

     desc_num = *(u_short *)(dev->seg_ram + dev->ffL.tcq_rd);

and this:

      SchedTbl = (u16*)(dev->seg_ram+CBR_SCHED_TABLE*dev->memSize); 
 ...
      TstSchedTbl = (u16*)(SchedTbl+testSlot);  //set index and read in value
 ...
          memcpy((caddr_t)&cbrVC,(caddr_t)TstSchedTbl,sizeof(cbrVC));
 ...
       memcpy((caddr_t)TstSchedTbl, (caddr_t)&vcIndex,sizeof(TstSchedTbl));

Really, this driver has a ton of unresolved portability problems.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/Kconfig  |    2 +-
 drivers/atm/iphase.c |   23 ++++++++++-------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/atm/Kconfig~resend-iphase-64bit-cleanup drivers/atm/Kconfig
--- a/drivers/atm/Kconfig~resend-iphase-64bit-cleanup
+++ a/drivers/atm/Kconfig
@@ -286,7 +286,7 @@ config ATM_HORIZON_DEBUG
 
 config ATM_IA
 	tristate "Interphase ATM PCI x575/x525/x531"
-	depends on PCI && ATM && !64BIT
+	depends on PCI && ATM
 	---help---
 	  This is a driver for the Interphase (i)ChipSAR adapter cards
 	  which include a variety of variants in term of the size of the
diff -puN drivers/atm/iphase.c~resend-iphase-64bit-cleanup drivers/atm/iphase.c
--- a/drivers/atm/iphase.c~resend-iphase-64bit-cleanup
+++ a/drivers/atm/iphase.c
@@ -93,10 +93,6 @@ module_param(IADebugFlag, uint, 0644);
 
 MODULE_LICENSE("GPL");
 
-#if BITS_PER_LONG != 32
-#  error FIXME: this driver only works on 32-bit platforms
-#endif
-
 /**************************** IA_LIB **********************************/
 
 static void ia_init_rtn_q (IARTN_Q *que) 
@@ -1408,7 +1404,6 @@ static int rx_init(struct atm_dev *dev) 
 	struct abr_vc_table  *abr_vc_table; 
 	u16 *vc_table;  
 	u16 *reass_table;  
-        u16 *ptr16;
 	int i,j, vcsize_sel;  
 	u_short freeq_st_adr;  
 	u_short *freeq_start;  
@@ -1423,14 +1418,15 @@ static int rx_init(struct atm_dev *dev) 
 		printk(KERN_ERR DEV_LABEL "can't allocate DLEs\n");
 		goto err_out;
 	}
-	iadev->rx_dle_q.start = (struct dle*)dle_addr;  
+	iadev->rx_dle_q.start = (struct dle *)dle_addr;
 	iadev->rx_dle_q.read = iadev->rx_dle_q.start;  
 	iadev->rx_dle_q.write = iadev->rx_dle_q.start;  
-	iadev->rx_dle_q.end = (struct dle*)((u32)dle_addr+sizeof(struct dle)*DLE_ENTRIES);  
+	iadev->rx_dle_q.end = (struct dle*)((unsigned long)dle_addr+sizeof(struct dle)*DLE_ENTRIES);
 	/* the end of the dle q points to the entry after the last  
 	DLE that can be used. */  
   
 	/* write the upper 20 bits of the start address to rx list address register */  
+	/* We know this is 32bit bus addressed so the following is safe */
 	writel(iadev->rx_dle_dma & 0xfffff000,
 	       iadev->dma + IPHASE5575_RX_LIST_ADDR);  
 	IF_INIT(printk("Tx Dle list addr: 0x%08x value: 0x%0x\n", 
@@ -1584,11 +1580,12 @@ static int rx_init(struct atm_dev *dev) 
 	   Set Packet Aging Interval count register to overflow in about 4 us
  	*/  
         writew(0xF6F8, iadev->reass_reg+PKT_TM_CNT );
-        ptr16 = (u16*)j;
-        i = ((u32)ptr16 >> 6) & 0xff;
-	ptr16  += j - 1;
-	i |=(((u32)ptr16 << 2) & 0xff00);
+
+        i = (j >> 6) & 0xFF;
+        j += 2 * (j - 1);
+        i |= ((j << 2) & 0xFF00);
         writew(i, iadev->reass_reg+TMOUT_RANGE);
+
         /* initiate the desc_tble */
         for(i=0; i<iadev->num_tx_desc;i++)
             iadev->desc_tbl[i].timestamp = 0;
@@ -1911,7 +1908,7 @@ static int tx_init(struct atm_dev *dev) 
 	iadev->tx_dle_q.start = (struct dle*)dle_addr;  
 	iadev->tx_dle_q.read = iadev->tx_dle_q.start;  
 	iadev->tx_dle_q.write = iadev->tx_dle_q.start;  
-	iadev->tx_dle_q.end = (struct dle*)((u32)dle_addr+sizeof(struct dle)*DLE_ENTRIES);  
+	iadev->tx_dle_q.end = (struct dle*)((unsigned long)dle_addr+sizeof(struct dle)*DLE_ENTRIES);
 
 	/* write the upper 20 bits of the start address to tx list address register */  
 	writel(iadev->tx_dle_dma & 0xfffff000,
@@ -2913,7 +2910,7 @@ static int ia_pkt_tx (struct atm_vcc *vc
                  dev_kfree_skb_any(skb);
           return 0;
         }
-        if ((u32)skb->data & 3) {
+        if ((unsigned long)skb->data & 3) {
            printk("Misaligned SKB\n");
            if (vcc->pop)
                  vcc->pop(vcc, skb);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
generic_serial-fix-decoding-of-baud-rate.patch
tty-minor-merge-correction.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-misc-minor-merge-fixups.patch
pata_pdc202xx_old-lba48-bug.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
