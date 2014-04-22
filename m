From: akpm@linux-foundation.org
Subject: +
 hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch added to -mm tree
Date: Tue, 22 Apr 2014 13:44:37 -0700
Message-ID: <5356d4b5.v/3epq4KLqBrwv60%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbaDVUoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 16:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, sougata@tuxera.com, slava@dubeyko.com, htl10@users.sourceforge.net, hch@infradead.org, anton@tuxera.com, akpm@linux-foundation.org

Subject: + hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch added to -mm tree
To: akpm@linux-foundation.org,anton@tuxera.com,hch@infradead.org,htl10@users.sourceforge.net,slava@dubeyko.com,sougata@tuxera.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 13:44:37 -0700


The patch titled
     Subject: hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix
has been added to the -mm tree.  Its filename is
     hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch

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
Subject: hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix

fix build

fs/hfsplus/xattr_user.c: In function 'hfsplus_user_getxattr':
fs/hfsplus/xattr_user.c:21: error: 'NLS_MAX_CHARSET_SIZE' undeclared (first use in this function)
fs/hfsplus/xattr_user.c:21: error: (Each undeclared identifier is reported only once

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr_user.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/xattr_user.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix fs/hfsplus/xattr_user.c
--- a/fs/hfsplus/xattr_user.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix
+++ a/fs/hfsplus/xattr_user.c
@@ -6,6 +6,8 @@
  * Handler for user extended attributes.
  */
 
+#include <linux/nls.h>
+
 #include "hfsplus_fs.h"
 #include "xattr.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
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
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages-fix.patch
mm-gupc-tweaks.patch
mm-gupc-tweaks-fix.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
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

