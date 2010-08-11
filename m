From: akpm@linux-foundation.org
Subject: + drivers-acpi-debugfsc-needs-uaccessh.patch added to -mm tree
Date: Wed, 11 Aug 2010 14:13:46 -0700
Message-ID: <201008112143.o7BLhkZg016120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717Ab0HKVnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 17:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     drivers/acpi/debugfs.c needs uaccess.h
has been added to the -mm tree.  Its filename is
     drivers-acpi-debugfsc-needs-uaccessh.patch

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
Subject: drivers/acpi/debugfs.c needs uaccess.h
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 akpmconfig:

drivers/acpi/debugfs.c: In function 'cm_write':
drivers/acpi/debugfs.c:36: error: implicit declaration of function 'copy_from_user'

Please fold this into the base patch to prevent bisection holes.

Cc: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/debugfs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/debugfs.c~drivers-acpi-debugfsc-needs-uaccessh drivers/acpi/debugfs.c
--- a/drivers/acpi/debugfs.c~drivers-acpi-debugfsc-needs-uaccessh
+++ a/drivers/acpi/debugfs.c
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/uaccess.h>
 #include <linux/debugfs.h>
 #include <acpi/acpi_drivers.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-fix-bogus-preemption-logic.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
drivers-acpi-debugfsc-needs-uaccessh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

