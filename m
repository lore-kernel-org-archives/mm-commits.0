From: akpm@linux-foundation.org
Subject: + rapidio-tsi568-constify-rio_device_id.patch added to -mm tree
Date: Mon, 25 Sep 2017 16:13:05 -0700
Message-ID: <59c98d81.t80bnRxr3uU6PVb7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59300 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964968AbdIYXNG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 19:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: tsi568: constify rio_device_id
has been added to the -mm tree.  Its filename is
     rapidio-tsi568-constify-rio_device_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi568-constify-rio_device_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi568-constify-rio_device_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: rapidio: tsi568: constify rio_device_id

rio_device_id are not supposed to change at runtime.  rio driver is
working with const 'id_table'.  So mark the non-const rio_device_id
structs as const.

Link: http://lkml.kernel.org/r/1503734627-6058-5-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/tsi568.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/switches/tsi568.c~rapidio-tsi568-constify-rio_device_id drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-tsi568-constify-rio_device_id
+++ a/drivers/rapidio/switches/tsi568.c
@@ -169,7 +169,7 @@ static void tsi568_remove(struct rio_dev
 	spin_unlock(&rdev->rswitch->lock);
 }
 
-static struct rio_device_id tsi568_id_table[] = {
+static const struct rio_device_id tsi568_id_table[] = {
 	{RIO_DEVICE(RIO_DID_TSI568, RIO_VID_TUNDRA)},
 	{ 0, }	/* terminate list */
 };
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

rapidio-idt_gen2-constify-rio_device_id.patch
rapidio-idt_gen3-constify-rio_device_id.patch
rapidio-idtcps-constify-rio_device_id.patch
rapidio-tsi568-constify-rio_device_id.patch
rapidio-tsi57x-constify-rio_device_id.patch

