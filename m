From: akpm@linux-foundation.org
Subject: +
 relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch
 added to -mm tree
Date: Mon, 12 Sep 2016 15:01:03 -0700
Message-ID: <57d7259f.9XjhvSYw5BZCEkzR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756405AbcILWBE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 18:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: select CONFIG_IRQ_WORK
has been added to the -mm tree.  Its filename is
     relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: relay: select CONFIG_IRQ_WORK

The relay code was changed to use irq_work, and it now fails to build
if that is disabled:

kernel/relay.o: In function `__relay_reset':
relay.c:(.text.__relay_reset+0xb0): undefined reference to `irq_work_sync'
kernel/relay.o: In function `relay_close_buf':
relay.c:(.text.relay_close_buf+0x14): undefined reference to `irq_work_sync'
kernel/relay.o: In function `relay_switch_subbuf':

This adds the necessary Kconfig select statement.

Link: http://lkml.kernel.org/r/20160912154035.3222156-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: c37d49250a7b ("relay: Use irq_work instead of plain timer for deferred wakeup")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix init/Kconfig
--- a/init/Kconfig~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix
+++ a/init/Kconfig
@@ -1278,6 +1278,7 @@ config SYSFS_DEPRECATED_V2
 
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
+	select IRQ_WORK
 	help
 	  This option enables support for relay interface support in
 	  certain file systems (such as debugfs).
_

Patches currently in -mm which might be from arnd@arndb.de are

compat-remove-compat_printk.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch
kthread-kthread-worker-api-cleanup-fix.patch

