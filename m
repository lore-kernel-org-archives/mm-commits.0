From: akpm@linux-foundation.org
Subject: + mmc-omap-abort-stuck-commands.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:29 -0700
Message-ID: <200803172227.m2HMRUZL001546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYCQW1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: abort stuck commands
has been added to the -mm tree.  Its filename is
     mmc-omap-abort-stuck-commands.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: abort stuck commands
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

When a card is removed while it is being accessed, a command can get stuck so
that no timeout or end of command interrupt ever occurs.  The command getting
stuck is almost always CDM12, but also the other commands can get stuck. 
Catch a stuck command with a timer and try sending the initiliazation stream
until the controller starts running again and responds with the end of command
status.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   93 +++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-abort-stuck-commands drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-abort-stuck-commands
+++ a/drivers/mmc/host/omap.c
@@ -134,6 +134,9 @@ struct mmc_omap_host {
 	unsigned char		bus_mode;
 	unsigned char		hw_bus_mode;
 
+	struct work_struct	cmd_abort;
+	struct timer_list	cmd_timer;
+
 	unsigned int		sg_len;
 	int			sg_idx;
 	u16 *			buffer;
@@ -314,6 +317,8 @@ mmc_omap_start_command(struct mmc_omap_h
 	if (host->data && !(host->data->flags & MMC_DATA_WRITE))
 		cmdreg |= 1 << 15;
 
+	mod_timer(&host->cmd_timer, jiffies + HZ/2);
+
 	OMAP_MMC_WRITE(host, CTO, 200);
 	OMAP_MMC_WRITE(host, ARGL, cmd->arg & 0xffff);
 	OMAP_MMC_WRITE(host, ARGH, cmd->arg >> 16);
@@ -373,9 +378,37 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 }
 
 static void
+mmc_omap_send_abort(struct mmc_omap_host *host)
+{
+	struct mmc_omap_slot *slot = host->current_slot;
+	unsigned int restarts, passes, timeout;
+	u16 stat = 0;
+
+	/* Sending abort takes 80 clocks. Have some extra and round up */
+	timeout = (120*1000000 + slot->fclk_freq - 1)/slot->fclk_freq;
+	restarts = 0;
+	while (restarts < 10000) {
+		OMAP_MMC_WRITE(host, STAT, 0xFFFF);
+		OMAP_MMC_WRITE(host, CMD, (3 << 12) | (1 << 7));
+
+		passes = 0;
+		while (passes < timeout) {
+			stat = OMAP_MMC_READ(host, STAT);
+			if (stat & OMAP_MMC_STAT_END_OF_CMD)
+				goto out;
+			udelay(1);
+			passes++;
+		}
+
+		restarts++;
+	}
+out:
+	OMAP_MMC_WRITE(host, STAT, stat);
+}
+
+static void
 mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	int loops;
 	u16 ie;
 
 	if (host->dma_in_use)
@@ -386,16 +419,8 @@ mmc_omap_abort_xfer(struct mmc_omap_host
 
 	ie = OMAP_MMC_READ(host, IE);
 	OMAP_MMC_WRITE(host, IE, 0);
-	OMAP_MMC_WRITE(host, CMD, 1 << 7);
-	loops = 0;
-	while (!(OMAP_MMC_READ(host, STAT) & OMAP_MMC_STAT_END_OF_CMD)) {
-		udelay(1);
-		loops++;
-		if (loops == 100000)
-			break;
-	}
-	OMAP_MMC_WRITE(host, STAT, OMAP_MMC_STAT_END_OF_CMD);
 	OMAP_MMC_WRITE(host, IE, ie);
+	mmc_omap_send_abort(host);
 }
 
 static void
@@ -451,6 +476,8 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 {
 	host->cmd = NULL;
 
+	del_timer(&host->cmd_timer);
+
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
 			/* response type 2 */
@@ -486,6 +513,47 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 	}
 }
 
+/*
+ * Abort stuck command. Can occur when card is removed while it is being
+ * read.
+ */
+static void mmc_omap_abort_command(struct work_struct *work)
+{
+	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
+						  cmd_abort);
+	u16 ie;
+
+	ie = OMAP_MMC_READ(host, IE);
+	OMAP_MMC_WRITE(host, IE, 0);
+
+	if (!host->cmd) {
+		OMAP_MMC_WRITE(host, IE, ie);
+		return;
+	}
+
+	dev_dbg(mmc_dev(host->mmc), "Aborting stuck command CMD%d\n",
+		host->cmd->opcode);
+
+	if (host->data && host->dma_in_use)
+		mmc_omap_release_dma(host, host->data, 1);
+
+	host->data = NULL;
+	host->sg_len = 0;
+
+	mmc_omap_send_abort(host);
+	host->cmd->error = -ETIMEDOUT;
+	mmc_omap_cmd_done(host, host->cmd);
+	OMAP_MMC_WRITE(host, IE, ie);
+}
+
+static void
+mmc_omap_cmd_timer(unsigned long data)
+{
+	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+
+	schedule_work(&host->cmd_abort);
+}
+
 /* PIO only */
 static void
 mmc_omap_sg_to_buf(struct mmc_omap_host *host)
@@ -1255,6 +1323,11 @@ static int __init mmc_omap_probe(struct 
 		goto err_free_mem_region;
 	}
 
+	INIT_WORK(&host->cmd_abort, mmc_omap_abort_command);
+	init_timer(&host->cmd_timer);
+	host->cmd_timer.function = mmc_omap_cmd_timer;
+	host->cmd_timer.data = (unsigned long) host;
+
 	spin_lock_init(&host->dma_lock);
 	init_timer(&host->dma_timer);
 	spin_lock_init(&host->slot_lock);
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-abort-stuck-commands.patch
mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch
mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

