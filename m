From: akpm@linux-foundation.org
Subject: + rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch added to -mm tree
Date: Thu, 20 May 2010 13:23:54 -0700
Message-ID: <201005202023.o4KKNstG002772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab0ETUZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 16:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, a.zummo@towertech.it, herton@mandriva.com.br, maltesch@gmx.de, p_gortmaker@yahoo.com, ralf@linux-mips.org, randy.dunlap@oracle.com, stable@kernel.org


The patch titled
     rtc-cmos: do dev_set_drvdata() earlier in the initialization
has been added to the -mm tree.  Its filename is
     rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch

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
Subject: rtc-cmos: do dev_set_drvdata() earlier in the initialization
From: Dan Carpenter <error27@gmail.com>


The bug is an oops when dev_get_drvdata() returned null in
cmos_update_irq_enable().  The call tree looks like this:
  rtc_dev_ioctl()
    => rtc_update_irq_enable()
      => cmos_update_irq_enable()

It's caused by a race condition in the module initialization.  It is
rtc_device_register() which makes the ioctl operations live so I moved
the call to dev_set_drvdata() before the call to rtc_device_register().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15963

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Malte Schroder <maltesch@gmx.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization
+++ a/drivers/rtc/rtc-cmos.c
@@ -717,6 +717,9 @@ cmos_do_probe(struct device *dev, struct
 		}
 	}
 
+	cmos_rtc.dev = dev;
+	dev_set_drvdata(dev, &cmos_rtc);
+
 	cmos_rtc.rtc = rtc_device_register(driver_name, dev,
 				&cmos_rtc_ops, THIS_MODULE);
 	if (IS_ERR(cmos_rtc.rtc)) {
@@ -724,8 +727,6 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup0;
 	}
 
-	cmos_rtc.dev = dev;
-	dev_set_drvdata(dev, &cmos_rtc);
 	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
include-linux-gfph-spelling-fixes.patch
include-linux-gfph-fix-coding-style.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

