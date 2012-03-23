From: akpm@linux-foundation.org
Subject: [merged] thermal-thermal_sys-fix-build-warning.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:37 -0700
Message-ID: <20120323182237.69768A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:39895 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab2CWSWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:38 -0400
Received: by ggnd2 with SMTP id d2so538399ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: festevam@gmail.com, durgadoss.r@intel.com, fabio.estevam@freescale.com, guenter.roeck@ericsson.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/thermal/thermal_sys.c: fix build warning
has been removed from the -mm tree.  Its filename was
     thermal-thermal_sys-fix-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: drivers/thermal/thermal_sys.c: fix build warning

With CONFIG_NET=n:

drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used

Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'

[akpm@linux-foundation.org: make thermal_event_seqnum local to generate_netlink_event()]
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning
+++ a/drivers/thermal/thermal_sys.c
@@ -60,8 +60,6 @@ static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static DEFINE_MUTEX(thermal_list_lock);
 
-static unsigned int thermal_event_seqnum;
