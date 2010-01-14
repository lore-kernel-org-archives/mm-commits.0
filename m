From: akpm@linux-foundation.org
Subject: + mm-remove-function-free_hot_page-fix.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:58:06 -0800
Message-ID: <201001150023.o0F0N8U8008686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756213Ab0AOAZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 19:25:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lihong.hi@gmail.com, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, xiyou.wangcong@gmail.com


The patch titled
     mm-remove-function-free_hot_page-fix
has been added to the -mm tree.  Its filename is
     mm-remove-function-free_hot_page-fix.patch

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
Subject: mm-remove-function-free_hot_page-fix
From: Andrew Morton <akpm@linux-foundation.org>

hm, that couldn't possible have worked for you :(

Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Li Hong <lihong.hi@gmail.com>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/page_alloc.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-remove-function-free_hot_page-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-function-free_hot_page-fix
+++ a/include/linux/gfp.h
@@ -325,7 +325,7 @@ void free_pages_exact(void *virt, size_t
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_hot_page(struct page *page);
+extern void free_hot_cold_page(struct page *page, int cold);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff -puN mm/page_alloc.c~mm-remove-function-free_hot_page-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-function-free_hot_page-fix
+++ a/mm/page_alloc.c
@@ -1094,7 +1094,7 @@ void mark_free_pages(struct zone *zone)
  * Free a 0-order page
  * cold == 1 ? free a cold page : free a hot page
  */
-static void free_hot_cold_page(struct page *page, int cold)
+void free_hot_cold_page(struct page *page, int cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ttyh-make-function-static-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-usb-core-sysfsc-set_reset_quirk-remove-unused-local.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

