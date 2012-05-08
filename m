From: akpm@linux-foundation.org
Subject: + isdn-add-missing-kern_cont.patch added to -mm tree
Date: Tue, 08 May 2012 14:58:05 -0700
Message-ID: <20120508215805.55350A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35692 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2EHV6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 17:58:12 -0400
Received: by wgbdt11 with SMTP id dt11so383064wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 14:58:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, davem@davemloft.net, isdn@linux-pingi.de


The patch titled
     Subject: ISDN: add missing KERN_CONT
has been added to the -mm tree.  Its filename is
     isdn-add-missing-kern_cont.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: ISDN: add missing KERN_CONT

Prevent this behaviour:

ISDN subsystem Rev: 1.1.2.3/
1.1.2.2/
1.1.2.3/
1.1.2.2/
1.1.2.2

Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/isdn/i4l/isdn_common.c~isdn-add-missing-kern_cont drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~isdn-add-missing-kern_cont
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -2351,18 +2351,18 @@ static int __init isdn_init(void)
 	strcpy(tmprev, isdn_revision);
 	printk(KERN_NOTICE "ISDN subsystem Rev: %s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_net_revision);
-	printk("%s/", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_ppp_revision);
-	printk("%s/", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_audio_revision);
-	printk("%s/", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_v110_revision);
-	printk("%s", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s", isdn_getrev(tmprev));
 
 #ifdef MODULE
-	printk(" loaded\n");
+	printk(KERN_CONT " loaded\n");
 #else
-	printk("\n");
+	printk(KERN_CONG "\n");
 #endif
 	isdn_info_update();
 	return 0;
_
Subject: Subject: ISDN: add missing KERN_CONT

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-division-by-0-in-percpu_pagelist_fraction.patch
brlocks-lglocks-cleanups.patch
mm-add-missing-kern_cont-to-free_area_init_nodes.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch

