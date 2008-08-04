From: akpm@linux-foundation.org
Subject: - usb-core-driver-fix-warning.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:38 -0700
Message-ID: <200808042007.m74K7cSo027805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077AbYHDUHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb/core/driver: fix warning
has been removed from the -mm tree.  Its filename was
     usb-core-driver-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb/core/driver: fix warning
From: Alexander Beregalov <a.beregalov@gmail.com>

usb/core/driver: fix warning:
drivers/usb/core/driver.c:834: warning: 'do_unbind_rebind' defined but not used

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/driver.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/core/driver.c~usb-core-driver-fix-warning drivers/usb/core/driver.c
--- a/drivers/usb/core/driver.c~usb-core-driver-fix-warning
+++ a/drivers/usb/core/driver.c
@@ -774,6 +774,7 @@ void usb_deregister(struct usb_driver *d
 }
 EXPORT_SYMBOL_GPL(usb_deregister);
 
+#ifdef CONFIG_PM
 
 /* Forced unbinding of a USB interface driver, either because
  * it doesn't support pre_reset/post_reset/reset_resume or
@@ -872,8 +873,6 @@ static void do_unbind_rebind(struct usb_
 	}
 }
 
-#ifdef CONFIG_PM
