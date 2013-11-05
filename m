From: akpm@linux-foundation.org
Subject: + mm-factor-commit-limit-calculation-fix.patch added to -mm tree
Date: Tue, 05 Nov 2013 15:53:33 -0800
Message-ID: <527984fd.J9lWOeatDwsCXBSh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3KEXxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: + mm-factor-commit-limit-calculation-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com,jmarchan@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:53:33 -0800


The patch titled
     Subject: mm-factor-commit-limit-calculation-fix
has been added to the -mm tree.  Its filename is
     mm-factor-commit-limit-calculation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-factor-commit-limit-calculation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-factor-commit-limit-calculation-fix.patch

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-factor-commit-limit-calculation-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

