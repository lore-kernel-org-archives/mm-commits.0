From: akpm@linux-foundation.org
Subject: [merged] rapidio-use-msleep-in-discovery-wait.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:03 -0700
Message-ID: <20121011205903.AF0BC100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56649 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:04 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so270541ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: use msleep in discovery wait
has been removed from the -mm tree.  Its filename was
     rapidio-use-msleep-in-discovery-wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: use msleep in discovery wait

Use msleep() for code clarity as suggested by Andrew Morton in his
comments for the original patch: https://lkml.org/lkml/2012/10/3/546.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-use-msleep-in-discovery-wait drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-use-msleep-in-discovery-wait
+++ a/drivers/rapidio/rio-scan.c
@@ -1391,7 +1391,7 @@ int __devinit rio_disc_mport(struct rio_
 		while (time_before(jiffies, to_end)) {
 			if (rio_enum_complete(mport))
 				goto enum_done;
-			schedule_timeout_uninterruptible(msecs_to_jiffies(10));
+			msleep(10);
 		}
 
 		pr_debug("RIO: discovery timeout on mport %d %s\n",
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

