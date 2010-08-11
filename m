From: akpm@linux-foundation.org
Subject: + drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch added to -mm tree
Date: Wed, 11 Aug 2010 16:06:24 -0700
Message-ID: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757391Ab0HKXg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 19:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gcosta@redhat.com, hpa@zytor.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, ying.huang@intel.com


The patch titled
     drivers/acpi/apei/erst-dbg.c: get_user(u64) doesn't work on i386
has been added to the -mm tree.  Its filename is
     drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch

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
Subject: drivers/acpi/apei/erst-dbg.c: get_user(u64) doesn't work on i386
From: Andrew Morton <akpm@linux-foundation.org>

Might be an x86 bug?  A get_user() on a u64 on i386 expands to

#define __get_user_8(__ret_gu, __val_gu, ptr)				\
		__get_user_x(X, __ret_gu, __val_gu, ptr)

which emits a call to __get_user_X(), which doesn't exist.

Kludge around it with copy_from_user().



While we're there, teach it how to print size_t's:

drivers/acpi/apei/erst-dbg.c: In function 'erst_dbg_read':
drivers/acpi/apei/erst-dbg.c:106: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'ssize_t'

Cc: Glauber Costa <gcosta@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/erst-dbg.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/apei/erst-dbg.c~drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386 drivers/acpi/apei/erst-dbg.c
--- a/drivers/acpi/apei/erst-dbg.c~drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386
+++ a/drivers/acpi/apei/erst-dbg.c
@@ -57,9 +57,10 @@ static long erst_dbg_ioctl(struct file *
 
 	switch (cmd) {
 	case APEI_ERST_CLEAR_RECORD:
-		rc = get_user(record_id, (u64 __user *)arg);
+		rc = copy_from_user(&record_id, (const void __user *)arg,
+					sizeof(record_id));
 		if (rc)
-			return rc;
+			return -EFAULT;
 		return erst_clear(record_id);
 	case APEI_ERST_GET_RECORD_COUNT:
 		rc = erst_get_record_count();
@@ -104,7 +105,7 @@ retry:
 		goto out;
 	if (len > ERST_DBG_RECORD_LEN_MAX) {
 		pr_warning(ERST_DBG_PFX
-			   "Record (ID: 0x%llx) length is too long: 0x%lx\n",
+			   "Record (ID: 0x%llx) length is too long: 0x%zx\n",
 			   id, len);
 		rc = -EIO;
 		goto out;
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
drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-scsi-qla4xxx-fix-build.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
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

