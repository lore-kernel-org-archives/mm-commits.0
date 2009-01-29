From: akpm@linux-foundation.org
Subject: + lis3lv02d-add-axes-knowledge-for-hp-6710.patch added to -mm tree
Date: Wed, 28 Jan 2009 16:56:09 -0800
Message-ID: <200901290056.n0T0u91t016821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbZA2A4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 19:56:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gkmarty@gmail.com, eric.piel@tremplin-utc.net, pavel@suse.cz


The patch titled
     lis3lv02d: add axes knowledge for HP 6710
has been added to the -mm tree.  Its filename is
     lis3lv02d-add-axes-knowledge-for-hp-6710.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3lv02d: add axes knowledge for HP 6710
From: Martin Kebert <gkmarty@gmail.com>

Add support for the HP laptops of model 6710x for having correctly setup
axes.

Signed-off-by: Martin Kebert <gkmarty@gmail.com>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6710 drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6710
+++ a/drivers/hwmon/hp_accel.c
@@ -156,6 +156,7 @@ static struct axis_conversion lis3lv02d_
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_swap_yz_inverted = {2, -1, -3};
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -177,9 +178,9 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
+	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
- * "NC671xx" "HP Compaq 671"
  * "NC6910" "HP Compaq 6910"
  * HP Compaq 8710x Notebook PC / Mobile Workstation
  * "NC2400" "HP Compaq nc2400"
_

Patches currently in -mm which might be from gkmarty@gmail.com are

lis3lv02d-add-axes-knowledge-for-hp-6710.patch

