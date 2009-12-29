From: akpm@linux-foundation.org
Subject: [merged] fix-section-mismatch-in-early-ehci-dbgp.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:20 -0800
Message-ID: <200912292133.nBTLXKHH008700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbZL2VdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, greg@kroah.com, jason.wessel@windriver.com, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     usb: fix section mismatch in early ehci dbgp
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-in-early-ehci-dbgp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fix section mismatch in early ehci dbgp
From: "Jan Beulich" <JBeulich@novell.com>

Commit 917778267fbe67703ab7d5c6f0b7a05d4c3df485 ("USB: ehci-dbgp:
stability improvements and external re-init") removed __init from
ehci_wait_for_port(), but left it in place on ehci_reset_port(), which is
being called from the former function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/early/ehci-dbgp.c~fix-section-mismatch-in-early-ehci-dbgp drivers/usb/early/ehci-dbgp.c
--- a/drivers/usb/early/ehci-dbgp.c~fix-section-mismatch-in-early-ehci-dbgp
+++ a/drivers/usb/early/ehci-dbgp.c
@@ -613,7 +613,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(dbgp_external_startup);
 
-static int __init ehci_reset_port(int port)
+static int ehci_reset_port(int port)
 {
 	u32 portsc;
 	u32 delay_time, delay;
_

Patches currently in -mm which might be from JBeulich@novell.com are


