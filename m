From: akpm@linux-foundation.org
Subject: + thermal-thermal_sys-fix-build-warning.patch added to -mm tree
Date: Tue, 24 Jan 2012 14:40:47 -0800
Message-ID: <20120124224047.65B46A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61687 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2AXWks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:40:48 -0500
Received: by yenr8 with SMTP id r8so445683yen.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 14:40:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, durgadoss.r@intel.com, fabio.estevam@freescale.com, guenter.roeck@ericsson.com, khali@linux-fr.org


The patch titled
     Subject: drivers/thermal/thermal_sys.c: fix build warning
has been added to the -mm tree.  Its filename is
     thermal-thermal_sys-fix-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: drivers/thermal/thermal_sys.c: fix build warning

With CONFIG_NET=n:

drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used

Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning
+++ a/drivers/thermal/thermal_sys.c
@@ -60,8 +60,6 @@ static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static DEFINE_MUTEX(thermal_list_lock);
 
-static unsigned int thermal_event_seqnum;
