From: akpm@linux-foundation.org
Subject: [merged] mm-readaheadc-do_readhead-dont-check-for-readpage.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:39 -0800
Message-ID: <5283e313.iL4oQd3DSUoPmDg1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [merged] mm-readaheadc-do_readhead-dont-check-for-readpage.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:39 -0800


The patch titled
     Subject: mm/readahead.c:do_readhead(): don't check for ->readpage
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-do_readhead-dont-check-for-readpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/readahead.c:do_readhead(): don't check for ->readpage

The callee force_page_cache_readahead() already does this and unlike
do_readahead(), force_page_cache_readahead() remembers to check for
->readpages() as well.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~mm-readaheadc-do_readhead-dont-check-for-readpage mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-do_readhead-dont-check-for-readpage
+++ a/mm/readahead.c
@@ -569,7 +569,7 @@ static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
 	     pgoff_t index, unsigned long nr)
 {
-	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
+	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
 	force_page_cache_readahead(mapping, filp, index, nr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-remove-unrelated-header-files-and-export-symbol-fix.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

