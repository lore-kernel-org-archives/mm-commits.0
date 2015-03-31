From: akpm@linux-foundation.org
Subject: + ocfs2-make-mlog_errno-return-the-errno.patch added to -mm tree
Date: Tue, 31 Mar 2015 15:13:58 -0700
Message-ID: <551b1c26.H+Q1b9PB7c+f8tyw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbCaWN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 18:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: make mlog_errno return the errno
has been added to the -mm tree.  Its filename is
     ocfs2-make-mlog_errno-return-the-errno.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-make-mlog_errno-return-the-errno.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-make-mlog_errno-return-the-errno.patch

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
Subject: ocfs2: make mlog_errno return the errno

ocfs2 does

	mlog_errno(v);
	return v;

in many places.  Change mlog_errno() so we can do

	return mlog_errno(v);

For some weird reason this patch reduces the size of ocfs2 by 6k:

akpm3:/usr/src/25> size fs/ocfs2/ocfs2.ko
   text    data     bss     dec     hex filename
1146613   82767  832192 2061572  1f7504 fs/ocfs2/ocfs2.ko-before
1140857   82767  832192 2055816  1f5e88 fs/ocfs2/ocfs2.ko-after

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/masklog.h~ocfs2-make-mlog_errno-return-the-errno fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~ocfs2-make-mlog_errno-return-the-errno
+++ a/fs/ocfs2/cluster/masklog.h
@@ -196,13 +196,14 @@ extern struct mlog_bits mlog_and_bits, m
 	}								\
 } while (0)
 
-#define mlog_errno(st) do {						\
+#define mlog_errno(st) ({						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
 	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
 	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
-} while (0)
+	st;								\
+})
 
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
 	if (cond) {							\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

