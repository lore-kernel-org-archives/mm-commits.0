From: akpm@linux-foundation.org
Subject: - aerdrv-fix-sanity-check-in-report_resume.patch removed from -mm tree
Date: Fri, 09 Jan 2009 15:19:53 -0800
Message-ID: <200901092336.n09NaLKW023603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbZAIXgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 18:36:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, jbarnes@virtuousgeek.org, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     aerdrv: fix sanity check in report_resume
has been removed from the -mm tree.  Its filename was
     aerdrv-fix-sanity-check-in-report_resume.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aerdrv: fix sanity check in report_resume
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

What we have to check here before calling that err_handler->resume is
non-NULL.  It seems that this block has been copy&pasted from
report_slot_reset.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~aerdrv-fix-sanity-check-in-report_resume drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~aerdrv-fix-sanity-check-in-report_resume
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -250,14 +250,14 @@ static void report_resume(struct pci_dev
 
 	dev->error_state = pci_channel_io_normal;
 
-	if (!dev->driver ||
-		!dev->driver->err_handler ||
-		!dev->driver->err_handler->slot_reset)
+	if (!dev->driver)
 		return;
