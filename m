From: akpm@linux-foundation.org
Subject: + memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 13:13:06 -0700
Message-ID: <53ed1852.HgB7y1knZbAeKB2R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52921 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaHNUNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 16:13:08 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so194450vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 13:13:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rdunlap@infradead.org, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2
has been added to the -mm tree.  Its filename is
     memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch

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
Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2

fix build with CONFIG_MEMORY_HOTREMOVE=n

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2 drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2
+++ a/drivers/base/memory.c
@@ -373,6 +373,7 @@ static ssize_t show_phys_device(struct d
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static int __zones_online_to(unsigned long end_pfn,
 				struct page *first_page, unsigned long nr_pages)
 {
@@ -432,12 +433,13 @@ static ssize_t show_zones_online_to(stru
 
 	return sprintf(buf, "%s\n", zone->name);
 }
+static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
+#endif
 
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
 static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
 static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
-static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
 
 /*
  * Block size attribute stuff
@@ -584,7 +586,9 @@ static struct attribute *memory_memblk_a
 	&dev_attr_state.attr,
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
+#ifdef CONFIG_MEMORY_HOTREMOVE
 	&dev_attr_zones_online_to.attr,
+#endif
 	NULL
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-gpu-drm-nouveau-fix-build.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
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

