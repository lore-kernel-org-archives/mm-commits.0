From: akpm@linux-foundation.org
Subject: + usb-core-driver-fix-warning.patch added to -mm tree
Date: Wed, 30 Jul 2008 01:50:39 -0700
Message-ID: <200807300850.m6U8odvA016986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbYG3IvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 04:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb/core/driver: fix warning
has been added to the -mm tree.  Its filename is
     usb-core-driver-fix-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
