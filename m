From: akpm@linux-foundation.org
Subject: [folded-merged]
 relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch
 removed from -mm tree
Date: Tue, 11 Oct 2016 13:37:51 -0700
Message-ID: <57fd4d9f.R6WNGhTdS2c22x9B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37609 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754886AbcJKUhw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: select CONFIG_IRQ_WORK
has been removed from the -mm tree.  Its filename was
     relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch

This patch was dropped because it was folded into relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch

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
@@ -1288,6 +1288,7 @@ config SYSFS_DEPRECATED_V2
 
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
+	select IRQ_WORK
 	help
 	  This option enables support for relay interface support in
 	  certain file systems (such as debugfs).
_

Patches currently in -mm which might be from arnd@arndb.de are

relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch
kthread-kthread-worker-api-cleanup-fix.patch

