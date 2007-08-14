From: akpm@linux-foundation.org
Subject: - hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:01 -0700
Message-ID: <200708140503.l7E531QA032018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935498AbXHNFLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: do not try to mark invalid PFNs as nosave
has been removed from the -mm tree.  Its filename was
     hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Hibernation: do not try to mark invalid PFNs as nosave
From: Rafael J. Wysocki <rjw@sisk.pl>

On some systems some PFNs reported by the early initialization code as
'nosave' may be invalid.  If we try to set the corresponding bits in the
hibernation bitmap, BUG_ON() in memory_bm_find_bit() will be triggered and
the system won't be able to boot (cf. 
https://bugzilla.novell.com/show_bug.cgi?id=296242).

Prevent this from happening by verifying if the 'nosave' PFNs are valid in
mark_nosave_pages().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/power/snapshot.c~hibernation-do-not-try-to-mark-invalid-pfns-as-nosave kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~hibernation-do-not-try-to-mark-invalid-pfns-as-nosave
+++ a/kernel/power/snapshot.c
@@ -709,7 +709,8 @@ static void mark_nosave_pages(struct mem
 				region->end_pfn << PAGE_SHIFT);
 
 		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
-			memory_bm_set_bit(bm, pfn);
+			if (pfn_valid(pfn))
+				memory_bm_set_bit(bm, pfn);
 	}
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch
git-avr32.patch
uli526x-add-suspend-and-resume-routines.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
shrink_slab-handle-bad-shrinkers.patch
