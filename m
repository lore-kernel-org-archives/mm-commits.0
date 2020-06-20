From: akpm@linux-foundation.org
Subject: + rapidio-rio_mport_cdev-use-struct_size-helper.patch added
 to -mm tree
Date: Sat, 20 Jun 2020 15:34:15 -0700
Message-ID: <20200620223415.GKB76%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgFTWeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 18:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, alex.bou9@gmail.com, gustavoars@kernel.org


The patch titled
     Subject: drivers/rapidio/devices/rio_mport_cdev.c: use struct_size() helper
has been added to the -mm tree.  Its filename is
     rapidio-rio_mport_cdev-use-struct_size-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rio_mport_cdev-use-struct_size-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rio_mport_cdev-use-struct_size-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: drivers/rapidio/devices/rio_mport_cdev.c: use struct_size() helper

Make use of the struct_size() helper instead of an open-coded version in
order to avoid any potential type mistakes.

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses KSPP ID: https://github.com/KSPP/linux/issues/83

Link: http://lkml.kernel.org/r/20200619170843.GA24923@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-rio_mport_cdev-use-struct_size-helper
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1710,8 +1710,7 @@ static int rio_mport_add_riodev(struct m
 	if (rval & RIO_PEF_SWITCH) {
 		rio_mport_read_config_32(mport, destid, hopcount,
 					 RIO_SWP_INFO_CAR, &swpinfo);
-		size += (RIO_GET_TOTAL_PORTS(swpinfo) *
-			 sizeof(rswitch->nextdev[0])) + sizeof(*rswitch);
+		size += struct_size(rswitch, nextdev, RIO_GET_TOTAL_PORTS(swpinfo));
 	}
 
 	rdev = kzalloc(size, GFP_KERNEL);
_

Patches currently in -mm which might be from gustavoars@kernel.org are

rapidio-rio_mport_cdev-use-struct_size-helper.patch
rapidio-use-struct_size-helper.patch
