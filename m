From: akpm@linux-foundation.org
Subject: [merged] power-use-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:38:28 -0700
Message-ID: <20200610003828.-pktWN5Yg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgFJAi3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, gregkh@linuxfoundation.org, len.brown@intel.com, mm-commits@vger.kernel.org, pavel@ucw.cz, rafael.j.wysocki@intel.com


The patch titled
     Subject: power: use show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     power-use-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: power: use show_stack_loglvl()

Aligning with other watchdog messages just before panic - use KERN_EMERG.

Link: http://lkml.kernel.org/r/20200418201944.482088-47-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/main.c~power-use-show_stack_loglvl
+++ a/drivers/base/power/main.c
@@ -519,7 +519,7 @@ static void dpm_watchdog_handler(struct
 	struct dpm_watchdog *wd = from_timer(wd, t, timer);
 
 	dev_emerg(wd->dev, "**** DPM device timeout ****\n");
-	show_stack(wd->tsk, NULL);
+	show_stack_loglvl(wd->tsk, NULL, KERN_EMERG);
 	panic("%s %s: unrecoverable failure\n",
 		dev_driver_string(wd->dev), dev_name(wd->dev));
 }
_

Patches currently in -mm which might be from dima@arista.com are
