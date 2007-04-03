From: akpm@linux-foundation.org
Subject: + swsusp-fix-memory-shrinker.patch added to -mm tree
Date: Tue, 03 Apr 2007 14:19:06 -0700
Message-ID: <200704032119.l33LJ7Af003554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945956AbXDCVTr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 17:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jirislaby@gmail.com, pavel@ucw.cz


The patch titled
     swsusp: fix memory shrinker
has been added to the -mm tree.  Its filename is
     swsusp-fix-memory-shrinker.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: fix memory shrinker
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a bug in the swsusp's memory shrinker that causes some systems using
highmem to refuse to suspend to disk if image_size is set above 1/2 of
available RAM.

Special thanks to Jiri Slaby for reporting the problem and assistance in
debugging it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/swsusp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/swsusp.c~swsusp-fix-memory-shrinker kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~swsusp-fix-memory-shrinker
+++ a/kernel/power/swsusp.c
@@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
 		size += highmem_size;
 		for_each_zone (zone)
 			if (populated_zone(zone)) {
+				tmp += snapshot_additional_pages(zone);
 				if (is_highmem(zone)) {
 					highmem_size -=
 					zone_page_state(zone, NR_FREE_PAGES);
 				} else {
 					tmp -= zone_page_state(zone, NR_FREE_PAGES);
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
-					tmp += snapshot_additional_pages(zone);
 				}
 			}
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
swsusp-fix-memory-shrinker.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
