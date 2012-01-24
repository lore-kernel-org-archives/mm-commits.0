From: akpm@linux-foundation.org
Subject: + thermal-thermal_sys-fix-build-warning.patch added to -mm tree
Date: Tue, 24 Jan 2012 14:39:51 -0800
Message-ID: <20120124223951.9BDCCA03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:61387 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2AXWjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:39:54 -0500
Received: by faaa19 with SMTP id a19so163875faa.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 14:39:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, fabio.estevam@freescale.com


The patch titled
     Subject: thermal: thermal_sys: Fix build warning
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
Subject: thermal: thermal_sys: Fix build warning

Fix the following build warning:

drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used

,which happens when CONFIG_NET is not set.

Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Change since v1:
- Sent corrupted patch in v1, and fixed now

index dd9a574..11f5955 100644
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
