From: akpm@linux-foundation.org
Subject: + mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch added to -mm tree
Date: Mon, 25 Jul 2016 15:27:44 -0700
Message-ID: <57969260.C2SKB6WmRmMK1axy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbcGYW1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 18:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@kernel.org, mpatocka@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-optimize-copy_page_to-from_iter_iovec-fix-fix
has been added to the -mm tree.  Its filename is
     mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch

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
Subject: mm-optimize-copy_page_to-from_iter_iovec-fix-fix

change copy_page_from_iter_iovec() as well

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec-fix-fix lib/iov_iter.c
--- a/lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec-fix-fix
+++ a/lib/iov_iter.c
@@ -242,8 +242,7 @@ static size_t copy_page_from_iter_iovec(
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-#ifdef CONFIG_HIGHMEM
-	if (!fault_in_pages_readable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -274,7 +273,6 @@ static size_t copy_page_from_iter_iovec(
 		copy = min(bytes, iov->iov_len - skip);
 	}
 	/* Too bad - revert to non-atomic kmap */
-#endif
 
 	kaddr = kmap(page);
 	to = kaddr + offset;
@@ -295,9 +293,7 @@ static size_t copy_page_from_iter_iovec(
 	}
 	kunmap(page);
 
-#ifdef CONFIG_HIGHMEM
 done:
-#endif
 	if (skip == iov->iov_len) {
 		iov++;
 		skip = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-resriction-on-the-kexec_load-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

