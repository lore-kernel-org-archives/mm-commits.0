From: akpm@linux-foundation.org
Subject: + remove-newline-from-the-description-of-module-parameters.patch added to -mm tree
Date: Wed, 30 Jul 2008 00:55:30 -0700
Message-ID: <200807300755.m6U7tUAL014883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbYG3H7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 03:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: niels@nixpanic.net, airlied@linux.ie, ecashin@coraid.com, jeff@garzik.org, linville@tuxdriver.com, mchehab@infradead.org, niels.devos@wincor-nixdorf.com, randy.dunlap@oracle.com, rolandd@cisco.com


The patch titled
     Remove newline from the description of module parameters
has been added to the -mm tree.  Its filename is
     remove-newline-from-the-description-of-module-parameters.patch

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
Subject: Remove newline from the description of module parameters
From: Niels de Vos <niels@nixpanic.net>

Some module parameters with only one line have the '\n' at the end of the
description.  This is not needed nor wanted as after the description the
type (i.e.  int) is followed by a newline.

Some modules contain a multi-line description, these are not affected
by this patch.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Ed L. Cashin <ecashin@coraid.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c                    |    4 ++--
 drivers/block/aoe/aoenet.c                  |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c |    2 +-
 drivers/media/video/cs5345.c                |    2 +-
 drivers/media/video/cs53l32a.c              |    2 +-
 drivers/media/video/mt9v022.c               |    2 +-
 drivers/net/netconsole.c                    |    2 +-
 drivers/net/tokenring/3c359.c               |    8 ++++----
 drivers/net/wireless/ipw2200.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/video/matrox/matroxfb_base.c        |    2 +-
 12 files changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~remove-newline-from-the-description-of-module-parameters drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/acpi/asus_acpi.c
@@ -78,9 +78,9 @@ MODULE_LICENSE("GPL");
 static uid_t asus_uid;
 static gid_t asus_gid;
 module_param(asus_uid, uint, 0);
-MODULE_PARM_DESC(asus_uid, "UID for entries in /proc/acpi/asus.\n");
+MODULE_PARM_DESC(asus_uid, "UID for entries in /proc/acpi/asus");
 module_param(asus_gid, uint, 0);
-MODULE_PARM_DESC(asus_gid, "GID for entries in /proc/acpi/asus.\n");
+MODULE_PARM_DESC(asus_gid, "GID for entries in /proc/acpi/asus");
 
 /* For each model, all features implemented, 
  * those marked with R are relative to HOTK, A for absolute */
diff -puN drivers/block/aoe/aoenet.c~remove-newline-from-the-description-of-module-parameters drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/block/aoe/aoenet.c
@@ -30,7 +30,7 @@ enum {
 
 static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
-MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"\n");
+MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
 
 #ifndef MODULE
 static int __init aoe_iflist_setup(char *str)
diff -puN drivers/gpu/drm/radeon/radeon_drv.c~remove-newline-from-the-description-of-module-parameters drivers/gpu/drm/radeon/radeon_drv.c
--- a/drivers/gpu/drm/radeon/radeon_drv.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/gpu/drm/radeon/radeon_drv.c
@@ -38,7 +38,7 @@
 
 int radeon_no_wb;
 
-MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers\n");
+MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);
 
 static int dri_library_name(struct drm_device *dev, char *buf)
diff -puN drivers/infiniband/hw/ipath/ipath_iba7220.c~remove-newline-from-the-description-of-module-parameters drivers/infiniband/hw/ipath/ipath_iba7220.c
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -528,7 +528,7 @@ static const struct ipath_cregs ipath_72
 
 static char int_type[16] = "auto";
 module_param_string(interrupt_type, int_type, sizeof(int_type), 0444);
-MODULE_PARM_DESC(int_type, " interrupt_type=auto|force_msi|force_intx\n");
+MODULE_PARM_DESC(int_type, " interrupt_type=auto|force_msi|force_intx");
 
 /* packet rate matching delay; chip has support */
 static u8 rate_to_delay[2][2] = {
diff -puN drivers/media/video/cs5345.c~remove-newline-from-the-description-of-module-parameters drivers/media/video/cs5345.c
--- a/drivers/media/video/cs5345.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/media/video/cs5345.c
@@ -35,7 +35,7 @@ static int debug;
 
 module_param(debug, bool, 0644);
 
-MODULE_PARM_DESC(debug, "Debugging messages\n\t\t\t0=Off (default), 1=On");
+MODULE_PARM_DESC(debug, "Debugging messages, 0=Off (default), 1=On");
 
 
 /* ----------------------------------------------------------------------- */
diff -puN drivers/media/video/cs53l32a.c~remove-newline-from-the-description-of-module-parameters drivers/media/video/cs53l32a.c
--- a/drivers/media/video/cs53l32a.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/media/video/cs53l32a.c
@@ -39,7 +39,7 @@ static int debug;
 
 module_param(debug, bool, 0644);
 
-MODULE_PARM_DESC(debug, "Debugging messages\n\t\t\t0=Off (default), 1=On");
+MODULE_PARM_DESC(debug, "Debugging messages, 0=Off (default), 1=On");
 
 static unsigned short normal_i2c[] = { 0x22 >> 1, I2C_CLIENT_END };
 
diff -puN drivers/media/video/mt9v022.c~remove-newline-from-the-description-of-module-parameters drivers/media/video/mt9v022.c
--- a/drivers/media/video/mt9v022.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/media/video/mt9v022.c
@@ -25,7 +25,7 @@
 
 static char *sensor_type;
 module_param(sensor_type, charp, S_IRUGO);
-MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"\n");
+MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 
 /* mt9v022 selected register addresses */
 #define MT9V022_CHIP_VERSION		0x00
diff -puN drivers/net/netconsole.c~remove-newline-from-the-description-of-module-parameters drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/net/netconsole.c
@@ -53,7 +53,7 @@ MODULE_LICENSE("GPL");
 
 static char config[MAX_PARAM_LENGTH];
 module_param_string(netconsole, config, MAX_PARAM_LENGTH, 0);
-MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]\n");
+MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]");
 
 #ifndef	MODULE
 static int __init option_setup(char *opt)
diff -puN drivers/net/tokenring/3c359.c~remove-newline-from-the-description-of-module-parameters drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/net/tokenring/3c359.c
@@ -95,20 +95,20 @@ MODULE_DESCRIPTION("3Com 3C359 Velocity 
 static int ringspeed[XL_MAX_ADAPTERS] = {0,} ;
 
 module_param_array(ringspeed, int, NULL, 0);
-MODULE_PARM_DESC(ringspeed,"3c359: Ringspeed selection - 4,16 or 0") ; 
+MODULE_PARM_DESC(ringspeed,"3c359: Ringspeed selection - 4,16 or 0") ;
 
 /* Packet buffer size */
 
 static int pkt_buf_sz[XL_MAX_ADAPTERS] = {0,} ;
  
 module_param_array(pkt_buf_sz, int, NULL, 0) ;
-MODULE_PARM_DESC(pkt_buf_sz,"3c359: Initial buffer size") ; 
+MODULE_PARM_DESC(pkt_buf_sz,"3c359: Initial buffer size") ;
 /* Message Level */
 
-static int message_level[XL_MAX_ADAPTERS] = {0,} ; 
+static int message_level[XL_MAX_ADAPTERS] = {0,} ;
 
 module_param_array(message_level, int, NULL, 0) ;
-MODULE_PARM_DESC(message_level, "3c359: Level of reported messages \n") ; 
+MODULE_PARM_DESC(message_level, "3c359: Level of reported messages") ;
 /* 
  *	This is a real nasty way of doing this, but otherwise you
  *	will be stuck with 1555 lines of hex #'s in the code.
diff -puN drivers/net/wireless/ipw2200.c~remove-newline-from-the-description-of-module-parameters drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/net/wireless/ipw2200.c
@@ -11946,7 +11946,7 @@ module_param(auto_create, int, 0444);
 MODULE_PARM_DESC(auto_create, "auto create adhoc network (default on)");
 
 module_param(led, int, 0444);
-MODULE_PARM_DESC(led, "enable led control on some systems (default 0 off)\n");
+MODULE_PARM_DESC(led, "enable led control on some systems (default 0 off)");
 
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
diff -puN drivers/net/wireless/iwlwifi/iwl-4965.c~remove-newline-from-the-description-of-module-parameters drivers/net/wireless/iwlwifi/iwl-4965.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2469,7 +2469,7 @@ MODULE_PARM_DESC(antenna, "select antenn
 module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
-MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])\n");
+MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(
diff -puN drivers/video/matrox/matroxfb_base.c~remove-newline-from-the-description-of-module-parameters drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~remove-newline-from-the-description-of-module-parameters
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -2536,7 +2536,7 @@ module_param(fh, int, 0);
 MODULE_PARM_DESC(fh, "Startup horizontal frequency, 0-999kHz, 1000-INF Hz");
 module_param(fv, int, 0);
 MODULE_PARM_DESC(fv, "Startup vertical frequency, 0-INF Hz\n"
-"You should specify \"fv:max_monitor_vsync,fh:max_monitor_hsync,maxclk:max_monitor_dotclock\"\n");
+"You should specify \"fv:max_monitor_vsync,fh:max_monitor_hsync,maxclk:max_monitor_dotclock\"");
 module_param(grayscale, int, 0);
 MODULE_PARM_DESC(grayscale, "Sets display into grayscale. Works perfectly with paletized videomode (4, 8bpp), some limitations apply to 16, 24 and 32bpp videomodes (default=nograyscale)");
 module_param(cross4MB, int, 0);
_

Patches currently in -mm which might be from niels@nixpanic.net are

remove-newline-from-the-description-of-module-parameters.patch

