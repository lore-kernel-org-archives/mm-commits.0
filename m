From: akpm@linux-foundation.org
Subject: [merged]
 backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:25 -0800
Message-ID: <52e2b885.X2CX1P2ip+aK/7DE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:25 -0800


The patch titled
     Subject: backlight: kb3886_bl: fix incorrect placement of __initdata marker
has been removed from the -mm tree.  Its filename was
     backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: kb3886_bl: fix incorrect placement of __initdata marker

The __initdata marker can be virtually anywhere on the line, EXCEPT right
after "struct".  The preferred location is before the "=" sign if there is
one, or before the trailing ";" otherwise.  It also fixes the following
chechpatch warning.

  WARNING: __initdata should be placed after kb3886bl_device_table[]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/kb3886_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -78,7 +78,7 @@ static struct kb3886bl_machinfo *bl_mach
 static unsigned long kb3886bl_flags;
 #define KB3886BL_SUSPENDED     0x01
 
-static struct dmi_system_id __initdata kb3886bl_device_table[] = {
+static struct dmi_system_id kb3886bl_device_table[] __initdata = {
 	{
 		.ident = "Sahara Touch-iT",
 		.matches = {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

