From: akpm@linux-foundation.org
Subject: + fix-the-graphic-corruption-issue-on-ia64-machines.patch added to -mm tree
Date: Tue, 03 Jul 2007 10:46:20 -0700
Message-ID: <200707031746.l63HkLNv005789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863AbXGCRqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 13:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: izumi2005@soft.fujitsu.com, adaplas@pol.net, ntachino@redhat.com, tony.luck@intel.com, zaitcev@redhat.com


The patch titled
     Fix the graphic corruption issue on IA64 machines
has been added to the -mm tree.  Its filename is
     fix-the-graphic-corruption-issue-on-ia64-machines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix the graphic corruption issue on IA64 machines
From: izumi <izumi2005@soft.fujitsu.com>

VGA console driver can misunderstand the current mode(Text/Graphic) under
"disable console blanking" setting.  When "disable console blank" is set
(blankinterval=0), "do_unblank_screen()" function returns without changing
"blank_state", and when "blank_state" is "blank_off", "do_blank_screen()
function returns without invoking sw->con_blank() function.  That's why VGA
console driver can misunderstand the current mode.

Signed-off-by: Nobuhiro Tachino <ntachino@redhat.com>
Signed-off-by: Taku Izumi <izumi2005@soft.fujitsu.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/vt.c~fix-the-graphic-corruption-issue-on-ia64-machines drivers/char/vt.c
--- a/drivers/char/vt.c~fix-the-graphic-corruption-issue-on-ia64-machines
+++ a/drivers/char/vt.c
@@ -3506,9 +3506,6 @@ void do_blank_screen(int entering_gfx)
 		}
 		return;
 	}
-	if (blank_state != blank_normal_wait)
-		return;
-	blank_state = blank_off;
 
 	/* entering graphics mode? */
 	if (entering_gfx) {
@@ -3516,10 +3513,15 @@ void do_blank_screen(int entering_gfx)
 		save_screen(vc);
 		vc->vc_sw->con_blank(vc, -1, 1);
 		console_blanked = fg_console + 1;
+		blank_state = blank_off;
 		set_origin(vc);
 		return;
 	}
 
+	if (blank_state != blank_normal_wait)
+		return;
+	blank_state = blank_off;
+
 	/* don't blank graphics */
 	if (vc->vc_mode != KD_TEXT) {
 		console_blanked = fg_console + 1;
_

Patches currently in -mm which might be from izumi2005@soft.fujitsu.com are

fix-the-graphic-corruption-issue-on-ia64-machines.patch
