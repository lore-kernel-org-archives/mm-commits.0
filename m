From: akpm@linux-foundation.org
Subject: + input-fix-uninitialized-old_keycode-oops-in-input_set_keycode.patch added to -mm tree
Date: Fri, 23 Jul 2010 12:17:41 -0700
Message-ID: <201007231917.o6NJHgkp003474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258Ab0GWTS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Jul 2010 15:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarod@redhat.com, Valdis.Kletnieks@vt.edu, dtor@mail.ru, kmcmartin@redhat.com


The patch titled
     input: fix uninitialized old_keycode oops in input_set_keycode
has been added to the -mm tree.  Its filename is
     input-fix-uninitialized-old_keycode-oops-in-input_set_keycode.patch

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
Subject: input: fix uninitialized old_keycode oops in input_set_keycode
From: Jarod Wilson <jarod@redhat.com>

Patch as suggested by Kyle McMartin, in response to Red Hat bugzilla
615707, filed against a rawhide kernel carrying ir-core enabling patches
from the linuxtv staging/other tree.  Fix is based on the similar logic in
input_set_keycode_big, and is confirmed by the bz reporter.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Cc: Kyle McMartin <kmcmartin@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/input.c~input-fix-uninitialized-old_keycode-oops-in-input_set_keycode drivers/input/input.c
--- a/drivers/input/input.c~input-fix-uninitialized-old_keycode-oops-in-input_set_keycode
+++ a/drivers/input/input.c
@@ -929,6 +929,7 @@ int input_set_keycode(struct input_dev *
 		if (retval)
 			goto out;
 
+		old_keycode = kt_entry.keycode;
 		kt_entry.keycode = keycode;
 
 		retval = dev->setkeycodebig(dev, &kt_entry);
_

Patches currently in -mm which might be from jarod@redhat.com are

linux-next.patch
input-fix-uninitialized-old_keycode-oops-in-input_set_keycode.patch
input-fix-wiring-up-default-setkeycode-setkeycodebig.patch

