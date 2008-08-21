From: akpm@linux-foundation.org
Subject: - eeepc-laptop-fix-user-after-free.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:48:54 -0700
Message-ID: <200808210348.m7L3mshx015589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774AbYHUDtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, corentincj@iksaif.net, hmh@hmh.eng.br, mjg@redhat.com, stable@kernel.org, sziwan@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     eeepc-laptop: fix user after free
has been removed from the -mm tree.  Its filename was
     eeepc-laptop-fix-user-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc-laptop: fix user after free
From: Matthew Garrett <mjg59@srcf.ucam.org>

eeepc-laptop uses the hwmon struct after unregistering the device, causing
an oops on module unload.  Flip the ordering to fix.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeepc-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/eeepc-laptop.c~eeepc-laptop-fix-user-after-free drivers/misc/eeepc-laptop.c
--- a/drivers/misc/eeepc-laptop.c~eeepc-laptop-fix-user-after-free
+++ a/drivers/misc/eeepc-laptop.c
@@ -553,9 +553,9 @@ static void eeepc_hwmon_exit(void)
 	hwmon = eeepc_hwmon_device;
 	if (!hwmon)
 		return ;
-	hwmon_device_unregister(hwmon);
 	sysfs_remove_group(&hwmon->kobj,
 			   &hwmon_attribute_group);
+	hwmon_device_unregister(hwmon);
 	eeepc_hwmon_device = NULL;
 }
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

linux-next.patch
eeepc-laptop-use-standard-interfaces.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch

