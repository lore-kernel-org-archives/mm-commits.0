From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch removed from -mm tree
Date: Wed, 16 Oct 2013 13:44:07 -0700
Message-ID: <525efa97.h7/jaze0lZcgeLtR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JPUoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Oct 2013 16:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Oct 2013 13:44:07 -0700


The patch titled
     Subject: mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch

This patch was dropped because it was folded into mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix

tweak comment layout and grammar

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix
+++ a/mm/hugetlb.c
@@ -701,17 +701,15 @@ static void prep_compound_gigantic_page(
 		__SetPageTail(p);
 		/*
 		 * For gigantic hugepages allocated through bootmem at
-		 * boot, it's safer to be consistent with the
-		 * not-gigantic hugepages and to clear the PG_reserved
-		 * bit from all tail pages too. Otherwse drivers using
-		 * get_user_pages() to access tail pages, may get the
-		 * reference counting wrong if they see the
-		 * PG_reserved bitflag set on a tail page (despite the
-		 * head page didn't have PG_reserved set). Enforcing
-		 * this consistency between head and tail pages,
-		 * allows drivers to optimize away a check on the head
-		 * page when they need know if put_page is needed after
-		 * get_user_pages() or not.
+		 * boot, it's safer to be consistent with the not-gigantic
+		 * hugepages and clear the PG_reserved bit from all tail pages
+		 * too.  Otherwse drivers using get_user_pages() to access tail
+		 * pages may get the reference counting wrong if they see
+		 * PG_reserved set on a tail page (despite the head page not
+		 * having PG_reserved set).  Enforcing this consistency between
+		 * head and tail pages allows drivers to optimize away a check
+		 * on the head page when they need know if put_page() is needed
+		 * after get_user_pages().
 		 */
 		__ClearPageReserved(p);
 		set_page_count(p, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments.patch
mm-zswap-bugfix-memory-leak-when-re-swapon.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

