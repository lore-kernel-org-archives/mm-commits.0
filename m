From: akpm@linux-foundation.org
Subject: + input-add-lenovo-3000-n100-to-nomux-blacklist.patch added to -mm tree
Date: Mon, 03 Mar 2008 14:03:29 -0800
Message-ID: <200803032203.m23M3Tmo008938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYCCWEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 17:04:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, cddesjardins@gmail.com, dtor@mail.ru


The patch titled
     input: add Lenovo 3000 N100 to nomux blacklist
has been added to the -mm tree.  Its filename is
     input-add-lenovo-3000-n100-to-nomux-blacklist.patch

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
Subject: input: add Lenovo 3000 N100 to nomux blacklist
From: Jiri Kosina <jkosina@suse.cz>

Lenovo 3000 N100 needs entry in nomux blacklist.

Reported-by: Christopher Desjardins <cddesjardins@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-add-lenovo-3000-n100-to-nomux-blacklist drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-add-lenovo-3000-n100-to-nomux-blacklist
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -277,6 +277,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
 		},
 	},
+	{
+		.ident = "Lenovo 3000 n100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "3000 N100"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
elantech-touchpad-driver.patch
input-add-lenovo-3000-n100-to-nomux-blacklist.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
ati_remote2-autorepeat-and-loadable-keymap-support.patch
ipwireless-fix-potential-tty-==-null-dereference.patch
ipwireless-remove-dead-code.patch

