From: akpm@linux-foundation.org
Subject: + cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:33:09 -0700
Message-ID: <201008121933.o7CJX9p3008601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab0HLTdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tomasz.buchert@inria.fr


The patch titled
     cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch

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
Subject: cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: else should follow close brace '}'
#85: FILE: kernel/cgroup_freezer.c:250:
+	}
+	else if (old_state == CGROUP_FREEZING) {

ERROR: else should follow close brace '}'
#89: FILE: kernel/cgroup_freezer.c:254:
+	}
+	else { /* old_state == CGROUP_FROZEN */

total: 2 errors, 0 warnings, 82 lines checked

./patches/cgroup_freezer-update_freezer_state-does-incorrect-state-transitions.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/cgroup_freezer.c~cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes
+++ a/kernel/cgroup_freezer.c
@@ -246,12 +246,10 @@ static void update_if_frozen(struct cgro
 
 	if (old_state == CGROUP_THAWED) {
 		BUG_ON(nfrozen > 0);
-	}
-	else if (old_state == CGROUP_FREEZING) {
+	} else if (old_state == CGROUP_FREEZING) {
 		if (nfrozen == ntotal)
 			freezer->state = CGROUP_FROZEN;
-	}
-	else { /* old_state == CGROUP_FROZEN */
+	} else { /* old_state == CGROUP_FROZEN */
 		BUG_ON(nfrozen != ntotal);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
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

