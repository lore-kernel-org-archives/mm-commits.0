From: akpm@linux-foundation.org
Subject: + memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
 added to -mm tree
Date: Wed, 13 Aug 2014 13:50:55 -0700
Message-ID: <53ebcfaf.ccvkbFGzwJVZHATY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:38625 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaHMUu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:50:56 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so41581qgd.3
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:50:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch

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
Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix

use conventional comment layout

Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix
+++ a/drivers/base/memory.c
@@ -378,7 +378,7 @@ static int __zones_online_to(unsigned lo
 {
 	struct zone *zone_next;
 
-	/*The mem block is the last block of memory.*/
+	/* The mem block is the last block of memory. */
 	if (!pfn_valid(end_pfn + 1))
 		return 1;
 	zone_next = page_zone(first_page + nr_pages);
@@ -400,7 +400,7 @@ static ssize_t show_zones_online_to(stru
 	end_pfn = start_pfn + nr_pages;
 	first_page = pfn_to_page(start_pfn);
 
-	/*The block contains more than one zone can not be offlined.*/
+	/* The block contains more than one zone can not be offlined. */
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return sprintf(buf, "none\n");
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
drivers-gpu-drm-nouveau-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

