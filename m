From: akpm@linux-foundation.org
Subject: +
 mm-improve-readability-of-transparent_hugepage_enabled-fix.patch added to
 -mm tree
Date: Thu, 15 Jun 2017 13:10:28 -0700
Message-ID: <5942e9b4.pvOsYviIvaXL4BHp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFOUKe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-improve-readability-of-transparent_hugepage_enabled-fix
has been added to the -mm tree.  Its filename is
     mm-improve-readability-of-transparent_hugepage_enabled-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-readability-of-transparent_hugepage_enabled-fix.patch

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
Subject: mm-improve-readability-of-transparent_hugepage_enabled-fix

resolve vs mm-make-pr_set_thp_disable-immediately-active.patch

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled-fix include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled-fix
+++ a/include/linux/huge_mm.h
@@ -89,7 +89,13 @@ extern unsigned long transparent_hugepag
 
 static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_NOHUGEPAGE) || is_vma_temporary_stack(vma))
+	if (vma->vm_flags & VM_NOHUGEPAGE))
+		return false;
+
+	if (is_vma_temporary_stack(vma))
+		return false;
+
+	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

