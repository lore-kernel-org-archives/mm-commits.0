From: akpm@linux-foundation.org
Subject: + fix-the-graphic-corruption-issue-on-ia64-machines.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:50:04 -0700
Message-ID: <200706262150.l5QLo4Yh002812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757413AbXFZVui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:50:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: izumi2005@soft.fujitsu.com, adaplas@pol.net, ntachino@redhat.com, tony.luck@intel.com


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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/vt.c~fix-the-graphic-corruption-issue-on-ia64-machines drivers/char/vt.c
--- a/drivers/char/vt.c~fix-the-graphic-corruption-issue-on-ia64-machines
+++ a/drivers/char/vt.c
@@ -3572,12 +3572,12 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	}
 	vc = vc_cons[fg_console].d;
+	blank_state = blank_normal_wait;
 	if (vc->vc_mode != KD_TEXT)
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
 		mod_timer(&console_timer, jiffies + blankinterval);
-		blank_state = blank_normal_wait;
 	}
 
 	console_blanked = 0;
_

Patches currently in -mm which might be from izumi2005@soft.fujitsu.com are

fix-the-graphic-corruption-issue-on-ia64-machines.patch
