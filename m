From: akpm@linux-foundation.org
Subject: + drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch added to -mm tree
Date: Mon, 25 Feb 2013 15:54:51 -0800
Message-ID: <20130225235451.C9B6E31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:42785 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3BYXyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 18:54:53 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so166728yen.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 15:54:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.savkov@gmail.com, ibm-acpi@hmh.eng.br, matthew.garrett@nebula.com, rjw@sisk.pl


The patch titled
     Subject: drivers/platform/x86/thinkpad_acpi.c: move hotkey_thread_mutex lock after set_freezable()
has been added to the -mm tree.  Its filename is
     drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Artem Savkov <artem.savkov@gmail.com>
Subject: drivers/platform/x86/thinkpad_acpi.c: move hotkey_thread_mutex lock after set_freezable()

set_freezable() runs try_to_freeze() during which no locks should be held.
hotkey_thread_mutex lock should be moved closer to where it is actually
needed.

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -2463,13 +2463,13 @@ static int hotkey_kthread(void *data)
 	unsigned int poll_freq;
 	bool was_frozen;
 
-	mutex_lock(&hotkey_thread_mutex);
-
 	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
 		goto exit;
 
 	set_freezable();
 
+	mutex_lock(&hotkey_thread_mutex);
+
 	so = 0;
 	si = 1;
 	t = 0;
@@ -2523,8 +2523,8 @@ static int hotkey_kthread(void *data)
 		si ^= 1;
 	}
 
-exit:
 	mutex_unlock(&hotkey_thread_mutex);
+exit:
 	return 0;
 }
 
_

Patches currently in -mm which might be from artem.savkov@gmail.com are

drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch
drm-convert-to-idr_alloc-fix.patch
drm-convert-to-idr_alloc-fix-fix.patch

