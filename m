From: akpm@linux-foundation.org
Subject: + eeepc-laptop-fix-user-after-free.patch added to -mm tree
Date: Fri, 15 Aug 2008 16:23:33 -0700
Message-ID: <200808152323.m7FNNXMC024997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbYHOXYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Aug 2008 19:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, corentincj@iksaif.net, hmh@hmh.eng.br, mjg@redhat.com, stable@kernel.org, sziwan@users.sourceforge.net


The patch titled
     eeepc-laptop: fix user after free
has been added to the -mm tree.  Its filename is
     eeepc-laptop-fix-user-after-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

eeepc-laptop-fix-user-after-free.patch
linux-next.patch
eeepc-laptop-use-standard-interfaces.patch

