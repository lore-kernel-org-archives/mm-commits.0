From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-idt_gen3-constify-rio_device_id.patch
 removed from -mm tree
Date: Fri, 17 Nov 2017 14:27:26 -0800
Message-ID: <5a0f624e.gvqMOMpsUmuxS07D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936888AbdKQW12 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 17:27:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: idt_gen3: constify rio_device_id
has been removed from the -mm tree.  Its filename was
     rapidio-idt_gen3-constify-rio_device_id.patch

This patch was dropped because it was folded into rapidio-idt_gen2-constify-rio_device_id.patch

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: rapidio: idt_gen3: constify rio_device_id

rio_device_id are not supposed to change at runtime.  rio driver is
working with const 'id_table'.  So mark the non-const rio_device_id
structs as const.

Link: http://lkml.kernel.org/r/1503734627-6058-3-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/switches/idt_gen3.c~rapidio-idt_gen3-constify-rio_device_id drivers/rapidio/switches/idt_gen3.c
--- a/drivers/rapidio/switches/idt_gen3.c~rapidio-idt_gen3-constify-rio_device_id
+++ a/drivers/rapidio/switches/idt_gen3.c
@@ -348,7 +348,7 @@ static void idtg3_shutdown(struct rio_de
 	}
 }
 
-static struct rio_device_id idtg3_id_table[] = {
+static const struct rio_device_id idtg3_id_table[] = {
 	{RIO_DEVICE(RIO_DID_IDTRXS1632, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTRXS2448, RIO_VID_IDT)},
 	{ 0, }	/* terminate list */
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

rapidio-idt_gen2-constify-rio_device_id.patch
rapidio-idtcps-constify-rio_device_id.patch
rapidio-tsi568-constify-rio_device_id.patch
rapidio-tsi57x-constify-rio_device_id.patch

