From: akpm@linux-foundation.org
Subject: [merged] pci-hotplug-fix-ibmphp-build-error.patch removed from -mm tree
Date: Thu, 11 Feb 2010 13:07:20 -0800
Message-ID: <201002112107.o1BL7KAp028708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757025Ab0BKVHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 16:07:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci hotplug: fix ibmphp build error
has been removed from the -mm tree.  Its filename was
     pci-hotplug-fix-ibmphp-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci hotplug: fix ibmphp build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/pci/hotplug/ibmphp_hpc.c:135: error: implicit declaration of function 'init_MUTEX'
drivers/pci/hotplug/ibmphp_hpc.c:136: error: implicit declaration of function 'init_MUTEX_LOCKED'
drivers/pci/hotplug/ibmphp_hpc.c:797: error: implicit declaration of function 'down'
drivers/pci/hotplug/ibmphp_hpc.c:807: error: implicit declaration of function 'up'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_hpc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/hotplug/ibmphp_hpc.c~pci-hotplug-fix-ibmphp-build-error drivers/pci/hotplug/ibmphp_hpc.c
--- a/drivers/pci/hotplug/ibmphp_hpc.c~pci-hotplug-fix-ibmphp-build-error
+++ a/drivers/pci/hotplug/ibmphp_hpc.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 #include <linux/kthread.h>
 #include "ibmphp.h"
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
msi-laptop-depends-on-rfkill.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
i2c-fix-xiic-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

