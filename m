From: akpm@linux-foundation.org
Subject: [merged] aoe-remove-call-to-request-handler-from-i-o-completion.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:57 -0800
Message-ID: <20121218201058.A13E620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46279 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRULA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:00 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so63469eei.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: remove call to request handler from I/O completion
has been removed from the -mm tree.  Its filename was
     aoe-remove-call-to-request-handler-from-i-o-completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: remove call to request handler from I/O completion

There is no need to call the request handler function in the I/O
completion routine.  The user impact of not doing it is a more "nice" aoe
driver that is less susceptible to causing soft lockups.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-remove-call-to-request-handler-from-i-o-completion drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-remove-call-to-request-handler-from-i-o-completion
+++ a/drivers/block/aoe/aoecmd.c
@@ -1139,8 +1139,6 @@ badrsp:
 	if (buf && --buf->nframesout == 0 && buf->resid == 0)
 		aoe_end_buf(d, buf);
 
-	aoecmd_work(d);
