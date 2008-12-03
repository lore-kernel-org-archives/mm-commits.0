From: akpm@linux-foundation.org
Subject: + drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events.patch added to -mm tree
Date: Tue, 02 Dec 2008 22:12:17 -0800
Message-ID: <200812030612.mB36CHOj004870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbYLCGMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 01:12:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: impulze@impulze.org, dtor@mail.ru


The patch titled
     drivers/input/keyboard/atkbd.c: use function for generation of keyrelease events
has been added to the -mm tree.  Its filename is
     drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events.patch

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
Subject: drivers/input/keyboard/atkbd.c: use function for generation of keyrelease events
From: Daniel Mierswa <impulze@impulze.org>

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff -puN drivers/input/keyboard/atkbd.c~drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events
+++ a/drivers/input/keyboard/atkbd.c
@@ -834,6 +834,19 @@ static void atkbd_disconnect(struct seri
 }
 
 /*
+ * generate release events for the keycodes given in keys[]
+ */
+static void atkbd_gen_release_event(struct atkbd* atkbd, const unsigned int *keys,
+			unsigned int nr_keys)
+{
+	unsigned int i;
+
+	if (atkbd->set == 2)
+		for (i = 0; i < nr_keys; i++)
+			__set_bit(keys[i], atkbd->force_release_mask);
+}
+
+/*
  * Most special keys (Fn+F?) on Dell laptops do not generate release
  * events so we have to do it ourselves.
  */
@@ -842,12 +855,9 @@ static void atkbd_dell_laptop_keymap_fix
 	const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
 	};
-	int i;
 
-	if (atkbd->set == 2)
-		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
-			__set_bit(forced_release_keys[i],
-				  atkbd->force_release_mask);
+	atkbd_gen_release_event(atkbd, forced_release_keys,
+		ARRAY_SIZE(forced_release_keys));
 }
 
 /*
@@ -859,12 +869,9 @@ static void atkbd_hp_keymap_fixup(struct
 	const unsigned int forced_release_keys[] = {
 		0x94,
 	};
-	int i;
 
-	if (atkbd->set == 2)
-		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
-			__set_bit(forced_release_keys[i],
-					atkbd->force_release_mask);
+	atkbd_gen_release_event(atkbd, forced_release_keys,
+		ARRAY_SIZE(forced_release_keys));
 }
 
 /*
_

Patches currently in -mm which might be from impulze@impulze.org are

drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events.patch
drivers-input-keyboard-atkbdc-make-forced_release_keys-static.patch
drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch

