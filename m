From: akpm@linux-foundation.org
Subject: +
 dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching.patch added to -mm tree
Date: Thu, 13 Jun 2013 12:55:50 -0700
Message-ID: <51ba23c6.1By/1TSucdRz+r/2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3FMTzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 15:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, daniel.vetter@ffwll.ch, cpanceac@gmail.com, chris@chris-wilson.co.uk, annndddrr@gmail.com, jani.nikula@intel.com

Subject: + dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching.patch added to -mm tree
To: jani.nikula@intel.com,annndddrr@gmail.com,chris@chris-wilson.co.uk,cpanceac@gmail.com,daniel.vetter@ffwll.ch,greg@kroah.com
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 12:55:50 -0700


The patch titled
     Subject: dmi: add support for exact DMI matches in addition to substring matching
has been added to the -mm tree.  Its filename is
     dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: dmi: add support for exact DMI matches in addition to substring matching

dmi_match() considers a substring match to be a successful match.  This is
not always sufficient to distinguish between DMI data for different
systems.  Add support for exact string matching using strcmp() in addition
to the substring matching using strstr().

The specific use case in the i915 driver is to allow us to use an exact
match for D510MO, without also incorrectly matching D510MOV:

{
	.ident = "Intel D510MO",
	.matches = {
		DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
		DMI_EXACT_MATCH(DMI_BOARD_NAME, "D510MO"),
	},
}

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: <annndddrr@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Cornel Panceac <cpanceac@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c     |   12 +++++++++---
 include/linux/mod_devicetable.h |    6 ++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching
+++ a/drivers/firmware/dmi_scan.c
@@ -551,9 +551,15 @@ static bool dmi_matches(const struct dmi
 		int s = dmi->matches[i].slot;
 		if (s == DMI_NONE)
 			break;
-		if (dmi_ident[s]
-		    && strstr(dmi_ident[s], dmi->matches[i].substr))
-			continue;
+		if (dmi_ident[s]) {
+			if (!dmi->matches[i].exact_match &&
+			    strstr(dmi_ident[s], dmi->matches[i].substr))
+				continue;
+			else if (dmi->matches[i].exact_match &&
+				 !strcmp(dmi_ident[s], dmi->matches[i].substr))
+				continue;
+		}
+
 		/* No match */
 		return false;
 	}
diff -puN include/linux/mod_devicetable.h~dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching
+++ a/include/linux/mod_devicetable.h
@@ -456,7 +456,8 @@ enum dmi_field {
 };
 
 struct dmi_strmatch {
-	unsigned char slot;
+	unsigned char slot:7;
+	unsigned char exact_match:1;
 	char substr[79];
 };
 
@@ -474,7 +475,8 @@ struct dmi_system_id {
  */
 #define dmi_device_id dmi_system_id
 
-#define DMI_MATCH(a, b)	{ a, b }
+#define DMI_MATCH(a, b)	{ .slot = a, .substr = b }
+#define DMI_EXACT_MATCH(a, b)	{ .slot = a, .substr = b, .exact_match = 1 }
 
 #define PLATFORM_NAME_SIZE	20
 #define PLATFORM_MODULE_PREFIX	"platform:"
_

Patches currently in -mm which might be from jani.nikula@intel.com are

linux-next.patch
dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching.patch
drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard.patch
drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard.patch

