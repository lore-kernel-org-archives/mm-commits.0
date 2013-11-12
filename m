From: akpm@linux-foundation.org
Subject: [folded-merged] mm-factor-commit-limit-calculation-fix.patch
 removed from -mm tree
Date: Tue, 12 Nov 2013 14:36:38 -0800
Message-ID: <5282ad76.Slek0zOVhzHkJ4fc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3KLWgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:36:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-factor-commit-limit-calculation-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com,jmarchan@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:36:38 -0800


The patch titled
     Subject: mm-factor-commit-limit-calculation-fix
has been removed from the -mm tree.  Its filename was
     mm-factor-commit-limit-calculation-fix.patch

This patch was dropped because it was folded into mm-factor-commit-limit-calculation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-factor-commit-limit-calculation-fix

uninline vm_commit_limit()

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |   12 +-----------
 mm/mmap.c            |    9 +++++++++
 2 files changed, 10 insertions(+), 11 deletions(-)

diff -puN include/linux/mman.h~mm-factor-commit-limit-calculation-fix include/linux/mman.h
--- a/include/linux/mman.h~mm-factor-commit-limit-calculation-fix
+++ a/include/linux/mman.h
@@ -7,9 +7,6 @@
 #include <linux/atomic.h>
 #include <uapi/linux/mman.h>
 
-#include <linux/hugetlb.h>
-#include <linux/swap.h>
-
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
@@ -91,12 +88,5 @@ calc_vm_flag_bits(unsigned long flags)
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
 
-/*
- * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
- */
-static inline unsigned long vm_commit_limit()
-{
-	return ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
-}
+unsigned long vm_commit_limit(void);
 #endif /* _LINUX_MMAN_H */
diff -puN mm/mmap.c~mm-factor-commit-limit-calculation-fix mm/mmap.c
--- a/mm/mmap.c~mm-factor-commit-limit-calculation-fix
+++ a/mm/mmap.c
@@ -110,6 +110,15 @@ unsigned long vm_memory_committed(void)
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
 /*
+ * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+unsigned long vm_commit_limit(void)
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
mm-factor-commit-limit-calculation-fix-fix.patch
mm-factor-commit-limit-calculation-fix-fix-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

