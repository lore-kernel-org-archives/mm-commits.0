From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-blocking-wait-for-discovery-ready.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:34 -0700
Message-ID: <20121005202035.45A4F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45383 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:36 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so173067yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix blocking wait for discovery ready
has been removed from the -mm tree.  Its filename was
     rapidio-fix-blocking-wait-for-discovery-ready.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: fix blocking wait for discovery ready

The following set of patches provides modifications targeting support of
multiple RapidIO master port (mport) devices on a CPU-side of
RapidIO-capable board.  While the RapidIO subsystem code has definitions
suitable for multi-controller/multi-net support, the existing
implementation cannot be considered ready for multiple mport
configurations.  

=========== NOTES: =============

a) The patches below do not address RapidIO side view of multiport
   processing elements defined in Part 6 of RapidIO spec Rev.2.1 (section
   6.4.1).  These devices have Base Device ID CSR (0x60) and Component Tag
   CSR (0x6C) shared by all SRIO ports.  For example, Freescale's P4080,
   P3041 and P5020 have a dual-port SRIO controller implemented according
   the specification.  Enumeration/discovery of such devices from RapidIO
   side may require device-specific fixups.

b) Devices referenced above may also require implementation specific
   code to setup a host device ID for mport device.  These operations are
   not addressed by patches in this package.  

=================================

Details about provided patches:

1. Fix blocking wait for discovery ready

   While it does not happen on PowerPC based platforms, there is
   possibility of stalled CPU warning dump on x86 based platforms that run
   RapidIO discovery process if they wait too long for being enumerated.

   Currently users can avoid it by disabling the soft-lockup detector
   using "nosoftlockup" kernel parameter OR by ensuring that enumeration
   is completed before soft-lockup is detected.

   This patch eliminates blocking wait and keeps a scheduler running. 
   It also is required for patch 3 below which introduces asynchronous
   discovery process.

2. Use device lists handling on per-net basis

   This patch allows to correctly support multiple RapidIO nets and
   resolves possible issues caused by using single global list of devices
   during RapidIO system enumeration/discovery.  The most common sign of
   existing issue is incorrect contents of switch routing tables in
   systems with multiple mport controllers while single-port configuration
   performs as expected.

   The patch does not eliminate the global RapidIO device list but
   changes some routines in enumeration/discovery to use per-net device
   lists instead.  This way compatibility with upper layer RIO routines is
   preserved.

3.  Run discovery as an asynchronous process

   This patch modifies RapidIO initialization routine to asynchronously
   run the discovery process for each corresponding mport.  This allows
   having an arbitrary order of enumerating and discovering mports without
   creating a deadlock situation if an enumerator port was registered
   after a discovering one.

   On boards with multiple discovering mports it also eliminates order
   dependency between mports and may reduce total time of RapidIO
   subsystem initialization.

   Making netID matching to mportID ensures consistent netID assignment
   in multiport RapidIO systems with asynchronous discovery process
   (global counter implementation is affected by race between threads).

4. Rework RIONET to support multiple RIO master ports

   In the current version of the driver rionet_probe() has comment "XXX
   Make multi-net safe".  Now it is a good time to address this comment.

   This patch makes RIONET driver multi-net safe/capable by introducing
   per-net lists of RapidIO network peers.  It also enables to register
   network adapters for all available mport devices.

5. Add destination ID allocation mechanism

   The patch replaces a single global destination ID counter with
   per-net allocation mechanism to allow independent destID management for
   each available RapidIO network.  Using bitmap based mechanism instead
   of counters allows destination ID release and reuse in systems that
   support hot-swap.




This patch:

Fix blocking wait loop in the RapidIO discovery routine to avoid warning
dumps about stalled CPU on x86 platforms.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   60 +++++++++++------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-blocking-wait-for-discovery-ready drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-blocking-wait-for-discovery-ready
+++ a/drivers/rapidio/rio-scan.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
+#include <linux/sched.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
 
@@ -39,8 +40,6 @@
 LIST_HEAD(rio_devices);
 static LIST_HEAD(rio_switches);
 
-static void rio_enum_timeout(unsigned long);
-
 static void rio_init_em(struct rio_dev *rdev);
 
 DEFINE_SPINLOCK(rio_global_list_lock);
@@ -49,9 +48,6 @@ static int next_destid = 0;
 static int next_net = 0;
 static int next_comptag = 1;
 
-static struct timer_list rio_enum_timer =
-TIMER_INITIALIZER(rio_enum_timeout, 0, 0);
-
 static int rio_mport_phys_table[] = {
 	RIO_EFB_PAR_EP_ID,
 	RIO_EFB_PAR_EP_REC_ID,
@@ -1234,20 +1230,6 @@ static void rio_build_route_tables(void)
 }
 
 /**
- * rio_enum_timeout- Signal that enumeration timed out
- * @data: Address of timeout flag.
- *
- * When the enumeration complete timer expires, set a flag that
- * signals to the discovery process that enumeration did not
- * complete in a sane amount of time.
- */
-static void rio_enum_timeout(unsigned long data)
-{
-	/* Enumeration timed out, set flag */
-	*(int *)data = 1;
-}
-
-/**
  * rio_disc_mport- Start discovery through a master port
  * @mport: Master port to send transactions
  *
@@ -1260,34 +1242,33 @@ static void rio_enum_timeout(unsigned lo
 int __devinit rio_disc_mport(struct rio_mport *mport)
 {
 	struct rio_net *net = NULL;
-	int enum_timeout_flag = 0;
+	unsigned long to_end;
 
 	printk(KERN_INFO "RIO: discover master port %d, %s\n", mport->id,
 	       mport->name);
 
 	/* If master port has an active link, allocate net and discover peers */
 	if (rio_mport_is_active(mport)) {
-		if (!(net = rio_alloc_net(mport))) {
-			printk(KERN_ERR "RIO: Failed to allocate new net\n");
-			goto bail;
+		pr_debug("RIO: wait for enumeration to complete...\n");
+
+		to_end = jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
+		while (time_before(jiffies, to_end)) {
+			if (rio_enum_complete(mport))
+				goto enum_done;
+			schedule_timeout_uninterruptible(msecs_to_jiffies(10));
 		}
 
-		pr_debug("RIO: wait for enumeration complete...");
+		pr_debug("RIO: discovery timeout on mport %d %s\n",
+			 mport->id, mport->name);
+		goto bail;
+enum_done:
+		pr_debug("RIO: ... enumeration done\n");
 
-		rio_enum_timer.expires =
-		    jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
-		rio_enum_timer.data = (unsigned long)&enum_timeout_flag;
-		add_timer(&rio_enum_timer);
-		while (!rio_enum_complete(mport)) {
-			mdelay(1);
-			if (enum_timeout_flag) {
-				del_timer_sync(&rio_enum_timer);
-				goto timeout;
-			}
+		net = rio_alloc_net(mport);
+		if (!net) {
+			printk(KERN_ERR "RIO: Failed to allocate new net\n");
+			goto bail;
 		}
-		del_timer_sync(&rio_enum_timer);
-
-		pr_debug("done\n");
 
 		/* Read DestID assigned by enumerator */
 		rio_local_read_config_32(mport, RIO_DID_CSR,
@@ -1307,9 +1288,6 @@ int __devinit rio_disc_mport(struct rio_
 	}
 
 	return 0;
