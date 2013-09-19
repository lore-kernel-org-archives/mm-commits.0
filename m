From: akpm@linux-foundation.org
Subject: + drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:13:18 -0700
Message-ID: <523b76fe.Hk5Ex5IOhHbjvJGl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3ISWNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, michael.opdenacker@free-electrons.com

Subject: + drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:13:18 -0700


The patch titled
     Subject: drivers/cdrom/gdrom.c: remove deprecated IRQF_DISABLED
has been added to the -mm tree.  Its filename is
     drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: drivers/cdrom/gdrom.c: remove deprecated IRQF_DISABLED

Remove the IRQF_DISABLED flag from drivers/cdrom/gdrom.c.

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/gdrom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-remove-deprecated-irqf_disabled drivers/cdrom/gdrom.c
--- a/drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-remove-deprecated-irqf_disabled
+++ a/drivers/cdrom/gdrom.c
@@ -561,11 +561,11 @@ static int gdrom_set_interrupt_handlers(
 	int err;
 
 	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
-		IRQF_DISABLED, "gdrom_command", &gd);
+		0, "gdrom_command", &gd);
 	if (err)
 		return err;
 	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
-		IRQF_DISABLED, "gdrom_dma", &gd);
+		0, "gdrom_dma", &gd);
 	if (err)
 		free_irq(HW_EVENT_GDROM_CMD, &gd);
 	return err;
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
h8300-remove-deprecated-irqf_disabled.patch
drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
cramfs-mark-as-obsolete.patch
linux-next.patch

