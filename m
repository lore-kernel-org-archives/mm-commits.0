From: akpm@linux-foundation.org
Subject: +
 mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch added to -mm tree
Date: Thu, 10 Oct 2013 12:53:49 -0700
Message-ID: <525705cd.aNB5LgTzVKQgIVt1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3JJTxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 15:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang@samsung.com, akpm@linux-foundation.org

Subject: + mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,weijie.yang@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 12:53:49 -0700


The patch titled
     Subject: mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch

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
Subject: mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes

WARNING: line over 80 characters
#75: FILE: mm/zswap.c:272:
+static struct zswap_entry *zswap_entry_find_get(struct rb_root *root, pgoff_t offset)

WARNING: line over 80 characters
#106: FILE: mm/zswap.c:427:
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated, page is locked

total: 0 errors, 2 warnings, 222 lines checked

./patches/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes mm/zswap.c
--- a/mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes
+++ a/mm/zswap.c
@@ -269,7 +269,8 @@ static struct zswap_entry *zswap_rb_sear
 	return NULL;
 }
 
-static struct zswap_entry *zswap_entry_find_get(struct rb_root *root, pgoff_t offset)
+static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
+						pgoff_t offset)
 {
 	struct zswap_entry *entry = NULL;
 
@@ -424,7 +425,8 @@ enum zswap_get_swap_ret {
  *
  * If success, the swap cache page is returned in retpage
  * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
- * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated, page is locked
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated, page is
+ * locked
  * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
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

