From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 46/93] power: use show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:32:16 -0700
Message-ID: <20200609043216.ZOKDVK2bH%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:18 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, gregkh@linuxfoundation.org, len.brown@intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pavel@ucw.cz, rafael.j.wysocki@intel.com, torvalds@linux-foundation.org

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
