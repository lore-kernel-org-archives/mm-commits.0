From: akpm@linux-foundation.org
Subject: + drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc.patch added to -mm tree
Date: Wed, 03 Jun 2009 15:57:57 -0700
Message-ID: <200906032257.n53MvvO6008921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbZFCW6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 18:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarod@redhat.com, florian@demmer.org, jbarnes@virtuousgeek.org


The patch titled
     drm: intel: add ignore lvds quirk info for AOpen Mini PC
has been added to the -mm tree.  Its filename is
     drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc.patch

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
Subject: drm: intel: add ignore lvds quirk info for AOpen Mini PC
From: Jarod Wilson <jarod@redhat.com>

Fix a FIXME in the intel LVDS bring-up code, adding the appropriate
blacklist entry for the AOpen Mini PC, courtesy of a dmidecode dump from
Florian Demmer.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Cc: Florian Demmer <florian@demmer.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-intel-add-ignore-lvds-quirk-info-for-aopen-mini-pc
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -424,8 +424,14 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
 		},
 	},
