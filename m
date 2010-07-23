From: akpm@linux-foundation.org
Subject: + input-fix-wiring-up-default-setkeycode-setkeycodebig.patch added to -mm tree
Date: Fri, 23 Jul 2010 12:17:46 -0700
Message-ID: <201007231917.o6NJHkVD003482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258Ab0GWTSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Jul 2010 15:18:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarod@redhat.com, Valdis.Kletnieks@vt.edu, dtor@mail.ru, kmcmartin@redhat.com


The patch titled
     input: fix wiring up default setkeycode/setkeycodebig
has been added to the -mm tree.  Its filename is
     input-fix-wiring-up-default-setkeycode-setkeycodebig.patch

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
Subject: input: fix wiring up default setkeycode/setkeycodebig
From: Jarod Wilson <jarod@redhat.com>

I believe there's a mistake in 94977ff15f4214ee4630cf4a67195a1d48da771c,
where the conditions on which to set a setkeycodebig function are
incorrect.  Previously, we had the case where if the dev didn't provide
its own setkeycode, we'd set the default input layer one.  Now, we set
setkeycode big if the dev provides its own setkeycode but doesn't provide
setkeycodebig.  Devices that provide neither setkeycode nor setkeycodebig
wind up with neither, which blows up horribly later on down the road when
a setkeycode{,big} operation is attempted.  Such is the case with the
thinkpad_acpi driver's input device registered for the extra hotkey
buttons on my own t61.  This makes it happy again, and seems to be an
obvious fix for a thinko.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Cc: Kyle McMartin <kmcmartin@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/input.c~input-fix-wiring-up-default-setkeycode-setkeycodebig drivers/input/input.c
--- a/drivers/input/input.c~input-fix-wiring-up-default-setkeycode-setkeycodebig
+++ a/drivers/input/input.c
@@ -1929,7 +1929,7 @@ int input_register_device(struct input_d
 			dev->getkeycodebig_from_scancode = input_default_getkeycode_from_scancode;
 	}
 
-	if (dev->setkeycode) {
+	if (!dev->setkeycode) {
 		if (!dev->setkeycodebig)
 			dev->setkeycodebig = input_default_setkeycode;
 	}
_

Patches currently in -mm which might be from jarod@redhat.com are

linux-next.patch
input-fix-uninitialized-old_keycode-oops-in-input_set_keycode.patch
input-fix-wiring-up-default-setkeycode-setkeycodebig.patch

