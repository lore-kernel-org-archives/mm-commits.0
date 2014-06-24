From: akpm@linux-foundation.org
Subject: [merged]
 memorystick-rtsx-add-cancel_work-when-remove-driver.patch removed from -mm
 tree
Date: Tue, 24 Jun 2014 12:02:27 -0700
Message-ID: <53a9cb43.R3mDLHJedb4v1KIE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaFXTC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: micky_ching@realsil.com.cn, gregkh@linuxfoundation.org, maximlevitsky@gmail.com, oakad@yahoo.com, rogerable@realtek.com, sameo@linux.intel.com, wei_wang@realsil.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/memstick/host/rtsx_pci_ms.c: add cancel_work when remove driver
has been removed from the -mm tree.  Its filename was
     memorystick-rtsx-add-cancel_work-when-remove-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

