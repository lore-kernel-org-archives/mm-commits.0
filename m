From: akpm@linux-foundation.org
Subject: + fix-hpet_unregister_irq_handler-for-emulation.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:11:36 -0800
Message-ID: <200802290111.m1T1BaJt030620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764043AbYB2BMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:12:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     Fix hpet_(un)register_irq_handler() for emulation
has been added to the -mm tree.  Its filename is
     fix-hpet_unregister_irq_handler-for-emulation.patch

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
Subject: Fix hpet_(un)register_irq_handler() for emulation
From: David Howells <dhowells@redhat.com>

Fix hpet_(un)register_irq_handler() for when CONFIG_HPET_EMULATE_RTC=n.  They
are provided macros that substitute value 0, but if they are called as
functions and the return value isn't checked, the following warnings appear:

	drivers/char/rtc.c: In function `rtc_init':
	drivers/char/rtc.c:1063: warning: statement with no effect
	drivers/char/rtc.c: In function `rtc_exit':
	drivers/char/rtc.c:1157: warning: statement with no effect

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/rtc.c~fix-hpet_unregister_irq_handler-for-emulation drivers/char/rtc.c
--- a/drivers/char/rtc.c~fix-hpet_unregister_irq_handler-for-emulation
+++ a/drivers/char/rtc.c
@@ -110,8 +110,8 @@ static int rtc_has_irq = 1;
 #define hpet_set_rtc_irq_bit(arg)		0
 #define hpet_rtc_timer_init()			do { } while (0)
 #define hpet_rtc_dropped_irq()			0
-#define hpet_register_irq_handler(h)		0
-#define hpet_unregister_irq_handler(h)		0
+#define hpet_register_irq_handler(h)		({ 0; })
+#define hpet_unregister_irq_handler(h)		({ 0; })
 #ifdef RTC_IRQ
 static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {
_

Patches currently in -mm which might be from dhowells@redhat.com are

fix-hpet_unregister_irq_handler-for-emulation.patch
git-hrt.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-switch-to-proc_create.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch

