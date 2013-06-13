From: akpm@linux-foundation.org
Subject: +
 drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard.patch added to
 -mm tree
Date: Thu, 13 Jun 2013 12:55:51 -0700
Message-ID: <51ba23c7.KDB1wViSD6TZefFq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3FMTzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 15:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jani.nikula@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, cpanceac@gmail.com, annndddrr@gmail.com, chris@chris-wilson.co.uk

Subject: + drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard.patch added to -mm tree
To: chris@chris-wilson.co.uk,annndddrr@gmail.com,cpanceac@gmail.com,daniel.vetter@ffwll.ch,greg@kroah.com,jani.nikula@intel.com
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 12:55:51 -0700


The patch titled
     Subject: drm/i915: quirk away phantom LVDS on Intel's D510MO mainboard
has been added to the -mm tree.  Its filename is
     drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: drm/i915: quirk away phantom LVDS on Intel's D510MO mainboard

This replaceable mainboard only has a VGA-out, yet it claims to also have
a connected LVDS header.

Addresses https://bugs.freedesktop.org/show_bug.cgi?id=63860

[jani.nikula@intel.com: use DMI_EXACT_MATCH for board name.]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reported-by: <annndddrr@gmail.com>
Cc: Cornel Panceac <cpanceac@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -690,6 +690,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Q900"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Intel D510MO",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D510MO"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are

origin.patch
linux-next.patch
dmi-add-support-for-exact-dmi-matches-in-addition-to-substring-matching.patch
drm-i915-quirk-away-phantom-lvds-on-intels-d510mo-mainboard.patch
drm-i915-quirk-away-phantom-lvds-on-intels-d525mw-mainboard.patch

