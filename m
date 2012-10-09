From: akpm@linux-foundation.org
Subject: + rapidio-use-msleep-in-discovery-wait.patch added to -mm tree
Date: Tue, 09 Oct 2012 13:03:19 -0700
Message-ID: <20121009200320.9F912100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40016 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2JIUDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 16:03:21 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so681325ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 13:03:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: use msleep in discovery wait
has been added to the -mm tree.  Its filename is
     rapidio-use-msleep-in-discovery-wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rapidio-use-msleep-in-discovery-wait.patch
rapidio-update-asynchronous-discovery-initialization.patch
rapidio-update-for-destination-id-allocation.patch

