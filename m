From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?rapidio-avoid-data-race-between-file-operation-callbacks-?=
 =?US-ASCII?Q?and-mport=5Fcdev=5Fadd.patch?= removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:53 -0700
Message-ID: <20200605201953.Qz1fuezBV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgFEUTy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.bou9@gmail.com, allison@lohutok.net, andrianov@ispras.ru, dan.carpenter@oracle.com, hubcap@omnibond.com, ira.weiny@intel.com, madhuparnabhowmik10@gmail.com, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, tglx@linutronix.de


The patch titled
     Subject: rapidio: avoid data race between file operation callbacks and mport_cdev_add().
has been removed from the -mm tree.  Its filename was
     rapidio-avoid-data-race-between-file-operation-callbacks-and-mport_cdev_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: rapidio: avoid data race between file operation callbacks and mport_cdev_add().

Fields of md(mport_dev) are set after cdev_device_add().  However, the
file operation callbacks can be called after cdev_device_add() and
therefore accesses to fields of md in the callbacks can race with the rest
of the mport_cdev_add() function.

One such example is INIT_LIST_HEAD(&md->portwrites) in mport_cdev_add(),
the list is initialised after cdev_device_add().  This can race with
list_add_tail(&pw_filter->md_node,&md->portwrites) in
rio_mport_add_pw_filter() which is called by unlocked_ioctl.

To avoid such data races use cdev_device_add() after initializing md.

Found by Linux Driver Verification project (linuxtesting.org).

Link: http://lkml.kernel.org/r/20200426112950.1803-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Acked-by: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-avoid-data-race-between-file-operation-callbacks-and-mport_cdev_add
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2384,13 +2384,6 @@ static struct mport_dev *mport_cdev_add(
 	cdev_init(&md->cdev, &mport_fops);
 	md->cdev.owner = THIS_MODULE;
 
-	ret = cdev_device_add(&md->cdev, &md->dev);
-	if (ret) {
-		rmcd_error("Failed to register mport %d (err=%d)",
-		       mport->id, ret);
-		goto err_cdev;
-	}
