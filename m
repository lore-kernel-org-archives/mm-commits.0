From: akpm@linux-foundation.org
Subject: + include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch added to -mm tree
Date: Wed, 16 Apr 2014 14:22:13 -0700
Message-ID: <534ef485.WkauyEpMv0t7JKFI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbaDPVWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 17:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebott@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch added to -mm tree
To: akpm@linux-foundation.org,sebott@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 14:22:13 -0700


The patch titled
     Subject: include/linux/mmdebug.h: add VM_WARN_ON() and VM_WARN_ON_ONCE()
has been added to the -mm tree.  Its filename is
     include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch

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
Subject: include/linux/mmdebug.h: add VM_WARN_ON() and VM_WARN_ON_ONCE()

WARN_ON() and WARN_ON_ONCE(), dependent on CONFIG_DEBUG_VM

Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/mmdebug.h~include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once
+++ a/include/linux/mmdebug.h
@@ -11,9 +11,13 @@ extern void dump_page_badflags(struct pa
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #define VM_BUG_ON_PAGE(cond, page) \
 	do { if (unlikely(cond)) { dump_page(page, NULL); BUG(); } } while (0)
+#define VM_WARN_ON(cond) WARN_ON(cond)
+#define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
+#define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

