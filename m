From: akpm@linux-foundation.org
Subject: + lib-more-scalable-list_sort-fix.patch added to -mm tree
Date: Mon, 01 Feb 2010 11:48:24 -0800
Message-ID: <201002011948.o11JmOgO008448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755958Ab0BATtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 14:49:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com, dedekind@infradead.org, don.mullis@gmail.com


The patch titled
     lib-more-scalable-list_sort-fix
has been added to the -mm tree.  Its filename is
     lib-more-scalable-list_sort-fix.patch

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
Subject: lib-more-scalable-list_sort-fix
From: Andrew Morton <akpm@linux-foundation.org>

style tweaks, fix comment, make list_sort_test __init.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/list_sort.c~lib-more-scalable-list_sort-fix lib/list_sort.c
--- a/lib/list_sort.c~lib-more-scalable-list_sort-fix
+++ a/lib/list_sort.c
@@ -61,16 +61,16 @@ static void merge_and_restore_back_links
 		}
 		tail = tail->next;
 	}
-	tail->next = a?:b;
+	tail->next = a ? : b;
 
 	do {
 		/*
 		 * In worst cases this loop may run many iterations.
 		 * Continue callbacks to the client even though no
-		 * element comparison is need, so the client's cmp()
+		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(void) (*cmp)(priv, tail, tail);
+		(*cmp)(priv, tail, tail);
 
 		tail->next->prev = tail;
 		tail = tail->next;
@@ -159,7 +159,7 @@ static int cmp(void *priv, struct list_h
  */
 #define LIST_SORT_TEST_LENGTH (512+128+2) /* not including head */
 
-static int list_sort_test(void)
+static int __init list_sort_test(void)
 {
 	int i, r = 1, count;
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

