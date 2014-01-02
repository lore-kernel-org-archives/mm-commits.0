From: akpm@linux-foundation.org
Subject: + mm-remap_file_pages-remove-unneeded-access_once.patch added to
 -mm tree
Date: Thu, 02 Jan 2014 13:22:45 -0800
Message-ID: <52c5d8a5.nLrxytD4Uh/WrlPp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABVWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 16:22:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, pageexec@freemail.hu, keescook@chromium.org, hughd@google.com, gorcunov@openvz.org, dvyukov@google.com, akpm@linux-foundation.org

Subject: + mm-remap_file_pages-remove-unneeded-access_once.patch added to -mm tree
To: akpm@linux-foundation.org,dvyukov@google.com,gorcunov@openvz.org,hughd@google.com,keescook@chromium.org,pageexec@freemail.hu,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 13:22:45 -0800


The patch titled
     Subject: mm: remap_file_pages(): remove unneeded ACCESS_ONCE
has been added to the -mm tree.  Its filename is
     mm-remap_file_pages-remove-unneeded-access_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remap_file_pages-remove-unneeded-access_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remap_file_pages-remove-unneeded-access_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: remap_file_pages(): remove unneeded ACCESS_ONCE

This was included to make it clear that the memory at *vma is about to be
freed, but the ACCESS_ONCE() isn't actually needed and we have a nice code
comment in there.


Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/fremap.c~mm-remap_file_pages-remove-unneeded-access_once mm/fremap.c
--- a/mm/fremap.c~mm-remap_file_pages-remove-unneeded-access_once
+++ a/mm/fremap.c
@@ -209,7 +209,7 @@ get_write_lock:
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
 			/* mmap_region may free vma; grab the info now */
-			vm_flags = ACCESS_ONCE(vma->vm_flags);
+			vm_flags = vma->vm_flags;
 
 			addr = mmap_region(file, start, size, vm_flags, pgoff);
 			fput(file);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-remap_file_pages-remove-unneeded-access_once.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

