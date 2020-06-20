From: akpm@linux-foundation.org
Subject: + rapidio-use-struct_size-helper.patch added to -mm tree
Date: Sat, 20 Jun 2020 15:34:18 -0700
Message-ID: <20200620223418.zqorv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgFTWeT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 18:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, alex.bou9@gmail.com, gustavoars@kernel.org


The patch titled
     Subject: drivers/rapidio/rio-scan.c: use struct_size() helper
has been added to the -mm tree.  Its filename is
     rapidio-use-struct_size-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-use-struct_size-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-use-struct_size-helper.patch

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
Subject: drivers/rapidio/rio-scan.c: use struct_size() helper

Make use of the struct_size() helper instead of an open-coded version in
order to avoid any potential type mistakes.

Also, while there, use the preferred form for passing a size of a struct. 
The alternative form where struct name is spelled out hurts readability
and introduces an opportunity for a bug when the pointer variable type is
changed but the corresponding sizeof that is passed as argument is not.

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses KSPP ID: https://github.com/KSPP/linux/issues/83

Link: http://lkml.kernel.org/r/20200619170445.GA22641@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/rapidio/rio-scan.c~rapidio-use-struct_size-helper
+++ a/drivers/rapidio/rio-scan.c
@@ -330,7 +330,7 @@ static struct rio_dev *rio_setup_device(
 	size_t size;
 	u32 swpinfo = 0;
 
-	size = sizeof(struct rio_dev);
+	size = sizeof(*rdev);
 	if (rio_mport_read_config_32(port, destid, hopcount,
 				     RIO_PEF_CAR, &result))
 		return NULL;
@@ -338,10 +338,8 @@ static struct rio_dev *rio_setup_device(
 	if (result & (RIO_PEF_SWITCH | RIO_PEF_MULTIPORT)) {
 		rio_mport_read_config_32(port, destid, hopcount,
 					 RIO_SWP_INFO_CAR, &swpinfo);
-		if (result & RIO_PEF_SWITCH) {
-			size += (RIO_GET_TOTAL_PORTS(swpinfo) *
-				sizeof(rswitch->nextdev[0])) + sizeof(*rswitch);
-		}
+		if (result & RIO_PEF_SWITCH)
+			size += struct_size(rswitch, nextdev, RIO_GET_TOTAL_PORTS(swpinfo));
 	}
 
 	rdev = kzalloc(size, GFP_KERNEL);
_

Patches currently in -mm which might be from gustavoars@kernel.org are

rapidio-rio_mport_cdev-use-struct_size-helper.patch
rapidio-use-struct_size-helper.patch
