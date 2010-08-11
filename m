From: akpm@linux-foundation.org
Subject: + fix-scripts-mod-modpostc-fix-memory-leak.patch added to -mm tree
Date: Tue, 10 Aug 2010 22:24:36 -0700
Message-ID: <201008110522.o7B5MqOj005524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304Ab0HKFXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 01:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ext-alexey.fomenko@nokia.com, mmarek@suse.cz, rusty@rustcorp.com.au, sfr@canb.auug.org.au, tsrk@tsrk.net


The patch titled
     fix "scripts/mod/modpost.c: fix memory leak"
has been added to the -mm tree.  Its filename is
     fix-scripts-mod-modpostc-fix-memory-leak.patch

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
Subject: fix "scripts/mod/modpost.c: fix memory leak"
From: Andrew Morton <akpm@linux-foundation.org>

Fix error introduced by 37ed19d5cce35a40d3913cf9aa208ce9f60db3d7
("scripts/mod/modpost.c: fix memory leak").

- don't kfree("")

- fix one missed conversion

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: Trevor Keith <tsrk@tsrk.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/mod/modpost.c~fix-scripts-mod-modpostc-fix-memory-leak scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~fix-scripts-mod-modpostc-fix-memory-leak
+++ a/scripts/mod/modpost.c
@@ -14,6 +14,7 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <ctype.h>
+#include <string.h>
 #include "modpost.h"
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
@@ -1167,7 +1168,7 @@ static char *sec2annotation(const char *
 			strcat(p, " ");
 		return r; /* we leak her but we do not care */
 	} else {
-		return "";
+		return strdup("");
 	}
 }
 
@@ -1302,7 +1303,7 @@ static void report_sec_mismatch(const ch
 		"%s%s so it may be used outside an exit section.\n",
 		from, prl_from, fromsym, from_p,
 		to, prl_to, tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		prl_to, tosym, to_p);
 		free(prl_from);
 		free(prl_to);
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-net-wireless-libertas-cfgc-needs-schedh.patch
fix-hwmon-coretemp-update-hotplug-condition-check.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mmc-recognize-csd-structure.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-add-support-for-ds3232-rtc.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems.patch
kfifo-add-example-files-to-the-kernel-sample-directory.patch
fix-scripts-mod-modpostc-fix-memory-leak.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
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

