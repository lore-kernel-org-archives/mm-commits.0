From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch removed from -mm tree
Date: Thu, 07 Mar 2013 13:47:16 -0800
Message-ID: <20130307214716.A9DD531C3AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52910 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3CGVrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 16:47:18 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so94133vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 13:47:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.savkov@gmail.com, aaron.lu@intel.com, ibm-acpi@hmh.eng.br, maciej.rutecki@gmail.com, matthew.garrett@nebula.com, msb@chromium.org, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/platform/x86/thinkpad_acpi.c: move hotkey_thread_mutex lock after set_freezable()
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Artem Savkov <artem.savkov@gmail.com>
Subject: drivers/platform/x86/thinkpad_acpi.c: move hotkey_thread_mutex lock after set_freezable()

set_freezable() runs try_to_freeze() during which no locks should be held.
hotkey_thread_mutex lock should be moved closer to where it is actually
needed.

This fixes a boot-time lockdep warning which results from "lockdep: check
that no locks held at freeze time".

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -2462,13 +2462,13 @@ static int hotkey_kthread(void *data)
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
@@ -2522,8 +2522,8 @@ static int hotkey_kthread(void *data)
 		si ^= 1;
 	}
 
-exit:
 	mutex_unlock(&hotkey_thread_mutex);
+exit:
 	return 0;
 }
 
_

Patches currently in -mm which might be from artem.savkov@gmail.com are

thinkpad-acpi-kill-hotkey_thread_mutex.patch

