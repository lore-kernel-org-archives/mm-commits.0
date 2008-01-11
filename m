From: akpm@linux-foundation.org
Subject: + macintosh-fix-fabrication-of-caplock-key-events.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:45:10 -0800
Message-ID: <200801110045.m0B0jAJE018228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963AbYAKAqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wingo@pobox.com, amcnabb@mcnabbs.org, benh@kernel.crashing.org, dtor@mail.ru, paulus@samba.org


The patch titled
     macintosh: fix fabrication of caplock key events
has been added to the -mm tree.  Its filename is
     macintosh-fix-fabrication-of-caplock-key-events.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macintosh: fix fabrication of caplock key events
From: Andy Wingo <wingo@pobox.com>

If the user has turned on the "restore_caplock_events" parameter, the code
mangles the capslock events correctly, then erroneously ignores those
events.  Fix logic to allow correct fallthrough.

Signed-off-by: Andy Wingo <wingo@pobox.com>
Cc: Andrew McNabb <amcnabb@mcnabbs.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adbhid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/macintosh/adbhid.c~macintosh-fix-fabrication-of-caplock-key-events drivers/macintosh/adbhid.c
--- a/drivers/macintosh/adbhid.c~macintosh-fix-fabrication-of-caplock-key-events
+++ a/drivers/macintosh/adbhid.c
@@ -322,8 +322,9 @@ adbhid_input_keycode(int id, int scancod
 			input_sync(ahid->input);
 			input_report_key(ahid->input, KEY_CAPSLOCK, 0);
 			input_sync(ahid->input);
+			return;
 		}
-		return;
+		break;
 #ifdef CONFIG_PPC_PMAC
 	case ADB_KEY_POWER_OLD: /* Power key on PBook 3400 needs remapping */
 		switch(pmac_call_feature(PMAC_FTR_GET_MB_INFO,
_

Patches currently in -mm which might be from wingo@pobox.com are

macintosh-fix-fabrication-of-caplock-key-events.patch
