From: akpm@osdl.org
Subject: + char-moxa-eliminate-typedefs.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:53:14 -0800
Message-ID: <200701022153.l02LrEjA031024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbXABVxX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, eliminate typedefs
has been added to the -mm tree.  Its filename is
     char-moxa-eliminate-typedefs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, eliminate typedefs
From: Jiri Slaby <jirislaby@gmail.com>

Do not use typedefs, use directly struct <something> instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-eliminate-typedefs drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-eliminate-typedefs
+++ a/drivers/char/moxa.c
@@ -94,32 +94,32 @@ static struct pci_device_id moxa_pcibrds
 MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
 #endif /* CONFIG_PCI */
 
-typedef struct _moxa_isa_board_conf {
+struct moxa_isa_board_conf {
 	int boardType;
 	int numPorts;
 	unsigned long baseAddr;
-} moxa_isa_board_conf;
+};
 
-static moxa_isa_board_conf moxa_isa_boards[] =
+static struct moxa_isa_board_conf moxa_isa_boards[] =
 {
 /*       {MOXA_BOARD_C218_ISA,8,0xDC000}, */
 };
 
-typedef struct _moxa_pci_devinfo {
+struct moxa_pci_devinfo {
 	ushort busNum;
 	ushort devNum;
 	struct pci_dev *pdev;
-} moxa_pci_devinfo;
+};
 
-typedef struct _moxa_board_conf {
+struct moxa_board_conf {
 	int boardType;
 	int numPorts;
 	unsigned long baseAddr;
 	int busType;
-	moxa_pci_devinfo pciInfo;
-} moxa_board_conf;
+	struct moxa_pci_devinfo pciInfo;
+};
 
-static moxa_board_conf moxa_boards[MAX_BOARDS];
+static struct moxa_board_conf moxa_boards[MAX_BOARDS];
 static void __iomem *moxaBaseAddr[MAX_BOARDS];
 static int loadstat[MAX_BOARDS];
 
@@ -273,7 +273,8 @@ static struct timer_list moxaEmptyTimer[
 static DEFINE_SPINLOCK(moxa_lock);
 
 #ifdef CONFIG_PCI
-static int moxa_get_PCI_conf(struct pci_dev *p, int board_type, moxa_board_conf * board)
+static int moxa_get_PCI_conf(struct pci_dev *p, int board_type,
+		struct moxa_board_conf *board)
 {
 	board->baseAddr = pci_resource_start (p, 2);
 	board->boardType = board_type;
@@ -1369,7 +1370,6 @@ struct mon_str {
 	int rxcnt[MAX_PORTS];
 	int txcnt[MAX_PORTS];
 };
-typedef struct mon_str mon_st;
 
 #define 	DCD_changed	0x01
 #define 	DCD_oldstate	0x80
@@ -1386,7 +1386,7 @@ static char moxaDCDState[MAX_PORTS];
 static char moxaLowChkFlag[MAX_PORTS];
 static int moxaLowWaterChk;
 static int moxaCard;
-static mon_st moxaLog;
+static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
 static ushort moxaBreakCnt[MAX_PORTS];
 
@@ -1485,7 +1485,8 @@ int MoxaDriverIoctl(unsigned int cmd, un
 	}
 	switch (cmd) {
 	case MOXA_GET_CONF:
-		if(copy_to_user(argp, &moxa_boards, MAX_BOARDS * sizeof(moxa_board_conf)))
+		if(copy_to_user(argp, &moxa_boards, MAX_BOARDS *
+				sizeof(struct moxa_board_conf)))
 			return -EFAULT;
 		return (0);
 	case MOXA_INIT_DRIVER:
@@ -1494,7 +1495,7 @@ int MoxaDriverIoctl(unsigned int cmd, un
 		return (0);
 	case MOXA_GETDATACOUNT:
 		moxaLog.tick = jiffies;
-		if(copy_to_user(argp, &moxaLog, sizeof(mon_st)))
+		if(copy_to_user(argp, &moxaLog, sizeof(struct mon_str)))
 			return -EFAULT;
 		return (0);
 	case MOXA_FLUSH_QUEUE:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
shrink_slab-handle-bad-shrinkers.patch
