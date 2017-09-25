From: akpm@linux-foundation.org
Subject: + rapidio-idt_gen2-constify-rio_device_id.patch added to -mm tree
Date: Mon, 25 Sep 2017 16:12:59 -0700
Message-ID: <59c98d7b.MtIVUxij+KSLYlZg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964968AbdIYXNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 19:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: idt_gen2: constify rio_device_id
has been added to the -mm tree.  Its filename is
     rapidio-idt_gen2-constify-rio_device_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-idt_gen2-constify-rio_device_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-idt_gen2-constify-rio_device_id.patch

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
Subject: rapidio: idt_gen2: constify rio_device_id

rio_device_id are not supposed to change at runtime.  rio driver is
working with const 'id_table'.  So mark the non-const rio_device_id
structs as const.

Link: http://lkml.kernel.org/r/1503734627-6058-2-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-idt_gen2-constify-rio_device_id drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-idt_gen2-constify-rio_device_id
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -458,7 +458,7 @@ static void idtg2_remove(struct rio_dev
 	idtg2_sysfs(rdev, false);
 }
 
-static struct rio_device_id idtg2_id_table[] = {
+static const struct rio_device_id idtg2_id_table[] = {
 	{RIO_DEVICE(RIO_DID_IDTCPS1848, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTCPS1616, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTVPS1616, RIO_VID_IDT)},
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

rapidio-idt_gen2-constify-rio_device_id.patch
rapidio-idt_gen3-constify-rio_device_id.patch
rapidio-idtcps-constify-rio_device_id.patch
rapidio-tsi568-constify-rio_device_id.patch
rapidio-tsi57x-constify-rio_device_id.patch

