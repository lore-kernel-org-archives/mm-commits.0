From: akpm@linux-foundation.org
Subject: + hp-wmi-additional-keycode-or-typo.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:43:45 -0700
Message-ID: <200810161943.m9GJhjNa009205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbYJPToC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, mjg@redhat.com


The patch titled
     HP-WMI: additional keycode (or typo)
has been added to the -mm tree.  Its filename is
     hp-wmi-additional-keycode-or-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: HP-WMI: additional keycode (or typo)
From: Eric Piel <eric.piel@tremplin-utc.net>

On my HP 2510, pressing the (i) button generates an unknown keycode:
0x213b. So here is a patch adding support for it. However, as it seems
there is already support for a similar button connected to 0x231b as
keycode, I wonder if it could be a typo in the driver?

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hp-wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/hp-wmi.c~hp-wmi-additional-keycode-or-typo drivers/misc/hp-wmi.c
--- a/drivers/misc/hp-wmi.c~hp-wmi-additional-keycode-or-typo
+++ a/drivers/misc/hp-wmi.c
@@ -82,6 +82,7 @@ static struct key_entry hp_wmi_keymap[] 
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
 	{KE_KEY, 0x20e6, KEY_PROG1},
 	{KE_KEY, 0x2142, KEY_MEDIA},
+	{KE_KEY, 0x213b, KEY_INFO},
 	{KE_KEY, 0x231b, KEY_HELP},
 	{KE_END, 0}
 };
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

hp-wmi-additional-keycode-or-typo.patch

