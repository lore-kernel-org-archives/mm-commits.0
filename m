From: akpm@osdl.org
Subject: - create-driver-symlink-in-snd-aoa.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:39 -0800
Message-ID: <200612072318.kB7NIde4031047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54107 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163964AbWLGXTY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     create driver symlink in snd-aoa
has been removed from the -mm tree.  Its filename was
     create-driver-symlink-in-snd-aoa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: create driver symlink in snd-aoa
From: Olaf Hering <olaf@aepfle.de>

create sysfs driver symlink for snd-aoa in /sys/bus/aoa-soundbus/devices/*/

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/aoa/fabrics/snd-aoa-fabric-layout.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN sound/aoa/fabrics/snd-aoa-fabric-layout.c~create-driver-symlink-in-snd-aoa sound/aoa/fabrics/snd-aoa-fabric-layout.c
--- a/sound/aoa/fabrics/snd-aoa-fabric-layout.c~create-driver-symlink-in-snd-aoa
+++ a/sound/aoa/fabrics/snd-aoa-fabric-layout.c
@@ -1107,6 +1107,9 @@ static struct soundbus_driver aoa_soundb
 	.suspend = aoa_fabric_layout_suspend,
 	.resume = aoa_fabric_layout_resume,
 #endif
+	.driver = {
+		.owner = THIS_MODULE,
+	}
 };
 
 static int __init aoa_fabric_layout_init(void)
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
git-alsa.patch
git-ieee1394.patch

