From: akpm@linux-foundation.org
Subject: - input-add-switch-for-dock-events.patch removed from -mm tree
Date: Mon, 21 Jul 2008 14:34:07 -0700
Message-ID: <200807212134.m6LLY7Zh025645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbYGUVfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 17:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, dtor@mail.ru, kristen.c.accardi@intel.com, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     input: add switch for dock events
has been removed from the -mm tree.  Its filename was
     input-add-switch-for-dock-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add switch for dock events
From: Matthew Garrett <mjg59@srcf.ucam.org>

Add a SW_DOCK switch to input.h.  ACPI docks currently send their docking
status as a uevent, but not all docks are ACPI or correspond to a device. 
In that case, it makes more sense to simply generate an input event on
docking or undocking.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/input.h~input-add-switch-for-dock-events include/linux/input.h
--- a/include/linux/input.h~input-add-switch-for-dock-events
+++ a/include/linux/input.h
@@ -642,6 +642,7 @@ struct input_absinfo {
 #define SW_RFKILL_ALL		0x03  /* rfkill master switch, type "any"
 					 set = radio enabled */
 #define SW_RADIO		SW_RFKILL_ALL	/* deprecated */
+#define SW_DOCK			0x04  /* set = plugged into dock */
 #define SW_MAX			0x0f
 #define SW_CNT			(SW_MAX+1)
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
misc-add-hp-wmi-laptop-extras-driver.patch

