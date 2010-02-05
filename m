From: akpm@linux-foundation.org
Subject: + pci-hotplug-fix-ibmphp-build-error.patch added to -mm tree
Date: Fri, 05 Feb 2010 12:20:19 -0800
Message-ID: <201002052020.o15KKJBa018980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755443Ab0BEUU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 15:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org


The patch titled
     pci hotplug: fix ibmphp build error
has been added to the -mm tree.  Its filename is
     pci-hotplug-fix-ibmphp-build-error.patch

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

origin.patch
linux-next.patch
msi-laptop-depends-on-rfkill.patch
i2c-fix-xiic-build-error.patch
pci-hotplug-fix-ibmphp-build-error.patch
libertas-if_spi-needs-linux-semaphoreh.patch
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

