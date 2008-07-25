From: akpm@linux-foundation.org
Subject: - parport-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:05 -0700
Message-ID: <200807252255.m6PMt5XM002947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbYGYXHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     parport: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     parport-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:". 
Add MODULE_ALIAS() to the hotpluggable parport platform drivers, to
re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_ax88796.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/parport/parport_ax88796.c~parport-fix-platform-driver-hotplug-coldplug drivers/parport/parport_ax88796.c
--- a/drivers/parport/parport_ax88796.c~parport-fix-platform-driver-hotplug-coldplug
+++ a/drivers/parport/parport_ax88796.c
@@ -406,6 +406,8 @@ static int parport_ax88796_resume(struct
 #define parport_ax88796_resume  NULL
 #endif
 
+MODULE_ALIAS("platform:ax88796-pp");
+
 static struct platform_driver axdrv = {
 	.driver		= {
 		.name	= "ax88796-pp",
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
linux-next.patch
use-warn-in-drivers-base.patch

