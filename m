From: akpm@linux-foundation.org
Subject: + hpilo-reduce-frequency-of-io-operations.patch added to -mm tree
Date: Tue, 10 Mar 2009 13:57:37 -0700
Message-ID: <200903102057.n2AKvbMe004183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZCJU6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 16:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.altobelli@hp.com


The patch titled
     hpilo: reduce frequency of IO operations
has been added to the -mm tree.  Its filename is
     hpilo-reduce-frequency-of-io-operations.patch

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
Subject: hpilo: reduce frequency of IO operations
From: David Altobelli <david.altobelli@hp.com>

Change hpilo open and close logic to spin for 10usec between checking device,
rather than every usec.

Because the loop is coded to take up to 10ms, it seemed prudent to
increase the interval between polling the device, to reduce the load on
the system and allow more other work to happen.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |    6 +++---
 drivers/misc/hpilo.h |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/misc/hpilo.c~hpilo-reduce-frequency-of-io-operations drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-reduce-frequency-of-io-operations
+++ a/drivers/misc/hpilo.c
@@ -209,7 +209,7 @@ static void ilo_ccb_close(struct pci_dev
 	/* give iLO some time to process stop request */
 	for (retries = MAX_WAIT; retries > 0; retries--) {
 		doorbell_set(driver_ccb);
-		udelay(1);
+		udelay(WAIT_TIME);
 		if (!(ioread32(&device_ccb->send_ctrl) & (1 << CTRL_BITPOS_A))
 		    &&
 		    !(ioread32(&device_ccb->recv_ctrl) & (1 << CTRL_BITPOS_A)))
@@ -312,7 +312,7 @@ static int ilo_ccb_open(struct ilo_hwinf
 	for (i = MAX_WAIT; i > 0; i--) {
 		if (ilo_pkt_dequeue(hw, driver_ccb, SENDQ, &pkt_id, NULL, NULL))
 			break;
-		udelay(1);
+		udelay(WAIT_TIME);
 	}
 
 	if (i) {
@@ -759,7 +759,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.0");
+MODULE_VERSION("1.1");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
diff -puN drivers/misc/hpilo.h~hpilo-reduce-frequency-of-io-operations drivers/misc/hpilo.h
--- a/drivers/misc/hpilo.h~hpilo-reduce-frequency-of-io-operations
+++ a/drivers/misc/hpilo.h
@@ -19,8 +19,12 @@
 #define MAX_ILO_DEV	1
 /* max number of files */
 #define MAX_OPEN	(MAX_CCB * MAX_ILO_DEV)
+/* total wait time in usec */
+#define MAX_WAIT_TIME	10000
+/* per spin wait time in usec */
+#define WAIT_TIME	10
 /* spin counter for open/close delay */
-#define MAX_WAIT	10000
+#define MAX_WAIT	(MAX_WAIT_TIME / WAIT_TIME)
 
 /*
  * Per device, used to track global memory allocations.
_

Patches currently in -mm which might be from david.altobelli@hp.com are

hpilo-reduce-frequency-of-io-operations.patch

