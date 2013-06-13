From: akpm@linux-foundation.org
Subject: +
 drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard.patch added to
 -mm tree
Date: Thu, 13 Jun 2013 12:55:52 -0700
Message-ID: <51ba23c8.RtoOh/0JzYG0AJBk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3FMTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 15:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, daniel.vetter@ffwll.ch, cpanceac@gmail.com, chris@chris-wilson.co.uk, annndddrr@gmail.com, jani.nikula@intel.com

Subject: + drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard.patch added to -mm tree
To: jani.nikula@intel.com,annndddrr@gmail.com,chris@chris-wilson.co.uk,cpanceac@gmail.com,daniel.vetter@ffwll.ch,greg@kroah.com
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 12:55:52 -0700


The patch titled
     Subject: drm/i915: quirk away phantom LVDS on Intel's D525MW mainboard
has been added to the -mm tree.  Its filename is
     drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard.patch

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
Subject: drm/i915: quirk away phantom LVDS on Intel's D525MW mainboard

This replaceable mainboard only has a VGA-out, yet it claims to also have
a connected LVDS header.

Addresses https://bugs.freedesktop.org/show_bug.cgi?id=65256

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reported-by: Cornel Panceac <cpanceac@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <annndddrr@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -698,6 +698,14 @@ static const struct dmi_system_id intel_
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D510MO"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Intel D525MW",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D525MW"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
_

Patches currently in -mm which might be from jani.nikula@intel.com are

linux-next.patch
dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching.patch
drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard.patch
drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard.patch

