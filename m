From: akpm@linux-foundation.org
Subject: + memorystick-rtsx-add-cancel_work-when-remove-driver.patch added to -mm tree
Date: Thu, 12 Jun 2014 14:44:41 -0700
Message-ID: <539a1f49.4WFBbY+hLZanaEHn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFLVom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 17:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wei_wang@realsil.com.cn, sameo@linux.intel.com, rogerable@realtek.com, oakad@yahoo.com, maximlevitsky@gmail.com, gregkh@linuxfoundation.org, micky_ching@realsil.com.cn

Subject: + memorystick-rtsx-add-cancel_work-when-remove-driver.patch added to -mm tree
To: micky_ching@realsil.com.cn,gregkh@linuxfoundation.org,maximlevitsky@gmail.com,oakad@yahoo.com,rogerable@realtek.com,sameo@linux.intel.com,wei_wang@realsil.com.cn
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 14:44:41 -0700


The patch titled
     Subject: drivers/memstick/host/rtsx_pci_ms.c: add cancel_work when remove driver
has been added to the -mm tree.  Its filename is
     memorystick-rtsx-add-cancel_work-when-remove-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memorystick-rtsx-add-cancel_work-when-remove-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memorystick-rtsx-add-cancel_work-when-remove-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Micky Ching <micky_ching@realsil.com.cn>
Subject: drivers/memstick/host/rtsx_pci_ms.c: add cancel_work when remove driver

Add cancel_work_sync() in rtsx_pci_ms_drv_remove() to cancel pending
request work when removing the driver.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Cc: Samuel Ortiz <sameo@linux.intel.com> says:
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Roger Tseng <rogerable@realtek.com>
Cc: Wei WANG <wei_wang@realsil.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/rtsx_pci_ms.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/memstick/host/rtsx_pci_ms.c~memorystick-rtsx-add-cancel_work-when-remove-driver drivers/memstick/host/rtsx_pci_ms.c
--- a/drivers/memstick/host/rtsx_pci_ms.c~memorystick-rtsx-add-cancel_work-when-remove-driver
+++ a/drivers/memstick/host/rtsx_pci_ms.c
@@ -601,6 +601,7 @@ static int rtsx_pci_ms_drv_remove(struct
 	pcr->slots[RTSX_MS_CARD].card_event = NULL;
 	msh = host->msh;
 	host->eject = true;
+	cancel_work_sync(&host->handle_req);
 
 	mutex_lock(&host->host_mutex);
 	if (host->req) {
_

Patches currently in -mm which might be from micky_ching@realsil.com.cn are

origin.patch
memorystick-rtsx-add-cancel_work-when-remove-driver.patch

