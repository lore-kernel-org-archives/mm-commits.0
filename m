From: akpm@linux-foundation.org
Subject: - fix-hpet_unregister_irq_handler-for-emulation.patch removed from -mm tree
Date: Fri, 29 Feb 2008 16:46:14 -0800
Message-ID: <200803010046.m210kE8i029027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737AbYCAAqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix hpet_(un)register_irq_handler() for emulation
has been removed from the -mm tree.  Its filename was
     fix-hpet_unregister_irq_handler-for-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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

