From: akpm@linux-foundation.org
Subject: + drivers-edac-use-round_jiffies_relative.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:18:03 -0700
Message-ID: <200710192118.l9JLI3kL020584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966160AbXJSVSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, alan@lxorguk.ukuu.org.uk, arjan@linux.intel.com, dougthompson@xmission.com


The patch titled
     drivers-edac: use round_jiffies_relative
has been added to the -mm tree.  Its filename is
     drivers-edac-use-round_jiffies_relative.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: use round_jiffies_relative
From: Anton Blanchard <anton@samba.org>

When rounding a relative timeout we need to use round_jiffies_relative().

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    4 ++--
 drivers/edac/edac_pci.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/edac/edac_device.c~drivers-edac-use-round_jiffies_relative drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-use-round_jiffies_relative
+++ a/drivers/edac/edac_device.c
@@ -440,7 +440,7 @@ static void edac_device_workq_function(s
 	 */
 	if (edac_dev->poll_msec == 1000)
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
-				round_jiffies(edac_dev->delay));
+				round_jiffies_relative(edac_dev->delay));
 	else
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
 				edac_dev->delay);
@@ -472,7 +472,7 @@ void edac_device_workq_setup(struct edac
 	 */
 	if (edac_dev->poll_msec == 1000)
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
-				round_jiffies(edac_dev->delay));
+				round_jiffies_relative(edac_dev->delay));
 	else
 		queue_delayed_work(edac_workqueue, &edac_dev->work,
 				edac_dev->delay);
diff -puN drivers/edac/edac_pci.c~drivers-edac-use-round_jiffies_relative drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~drivers-edac-use-round_jiffies_relative
+++ a/drivers/edac/edac_pci.c
@@ -246,7 +246,7 @@ static void edac_pci_workq_function(stru
 		/* if we are on a one second period, then use round */
 		msec = edac_pci_get_poll_msec();
 		if (msec == 1000)
-			delay = round_jiffies(msecs_to_jiffies(msec));
+			delay = round_jiffies_relative(msecs_to_jiffies(msec));
 		else
 			delay = msecs_to_jiffies(msec);
 
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
git-infiniband.patch
drivers-edac-use-round_jiffies_relative.patch
