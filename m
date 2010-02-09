From: akpm@linux-foundation.org
Subject: [merged] libertas-if_spi-needs-linux-semaphoreh.patch removed from -mm tree
Date: Tue, 09 Feb 2010 11:09:48 -0800
Message-ID: <201002091909.o19J9mSn028428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482Ab0BITKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 14:10:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, andrey@cozybit.com, colin@cozybit.com, dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     libertas/if_spi: needs linux/semaphore.h
has been removed from the -mm tree.  Its filename was
     libertas-if_spi-needs-linux-semaphoreh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libertas/if_spi: needs linux/semaphore.h
From: Randy Dunlap <randy.dunlap@oracle.com>

libertas/if_spi.c needs to #include linux/semaphore.h to fix build errors:

drivers/net/wireless/libertas/if_spi.c:59: error: field 'spi_ready' has incomplete type
drivers/net/wireless/libertas/if_spi.c:60: error: field 'spi_thread_terminated' has incomplete type
drivers/net/wireless/libertas/if_spi.c:785: error: implicit declaration of function 'down_interruptible'
drivers/net/wireless/libertas/if_spi.c:787: error: implicit declaration of function 'up'
drivers/net/wireless/libertas/if_spi.c:834: error: implicit declaration of function 'down'
drivers/net/wireless/libertas/if_spi.c:943: error: implicit declaration of function 'sema_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>
Cc: Colin McCabe <colin@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/if_spi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/libertas/if_spi.c~libertas-if_spi-needs-linux-semaphoreh drivers/net/wireless/libertas/if_spi.c
--- a/drivers/net/wireless/libertas/if_spi.c~libertas-if_spi-needs-linux-semaphoreh
+++ a/drivers/net/wireless/libertas/if_spi.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/semaphore.h>
 #include <linux/spi/libertas_spi.h>
 #include <linux/spi/spi.h>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
msi-laptop-depends-on-rfkill.patch
i2c-fix-xiic-build-error.patch
pci-hotplug-fix-ibmphp-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

