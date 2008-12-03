From: akpm@linux-foundation.org
Subject: + aerdrv-fix-sanity-check-in-report_resume.patch added to -mm tree
Date: Tue, 02 Dec 2008 18:37:40 -0800
Message-ID: <200812030237.mB32beu3015470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872AbYLCCiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 21:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, jbarnes@virtuousgeek.org, yanmin.zhang@intel.com


The patch titled
     aerdrv: fix sanity check in report_resume
has been added to the -mm tree.  Its filename is
     aerdrv-fix-sanity-check-in-report_resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~aerdrv-fix-sanity-check-in-report_resume drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~aerdrv-fix-sanity-check-in-report_resume
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -252,7 +252,7 @@ static void report_resume(struct pci_dev
 
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
-		!dev->driver->err_handler->slot_reset)
+		!dev->driver->err_handler->resume)
 		return;
 
 	err_handler = dev->driver->err_handler;
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

linux-next.patch
aerdrv-fix-sanity-check-in-report_resume.patch

