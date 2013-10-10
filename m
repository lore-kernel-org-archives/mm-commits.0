From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch added to -mm tree
Date: Thu, 10 Oct 2013 14:26:48 -0700
Message-ID: <52571b98.UNh9CiyHOSzCqc16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab3JJV0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:26:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: + mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:26:48 -0700


The patch titled
     Subject: mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch

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
ipc-update-locking-scheme-comments-fix.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

