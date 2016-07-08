From: akpm@linux-foundation.org
Subject: + ocfs2-improve-recovery-performance-v2-fix.patch added to -mm
 tree
Date: Fri, 08 Jul 2016 14:24:11 -0700
Message-ID: <578019fb.iY7H6YVy8t9IiS8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbcGHVYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-improve-recovery-performance-v2-fix
has been added to the -mm tree.  Its filename is
     ocfs2-improve-recovery-performance-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-improve-recovery-performance-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-improve-recovery-performance-v2-fix.patch

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
Subject: ocfs2-improve-recovery-performance-v2-fix

clean up the for loop p_blkno handling

Cc: "Gang He" <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2-fix fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2-fix
+++ a/fs/ocfs2/journal.c
@@ -1172,14 +1172,12 @@ static int ocfs2_force_read_journal(stru
 			goto bail;
 		}
 
-		for (i = 0; i < p_blocks; i++) {
+		for (i = 0; i < p_blocks; i++, p_blkno++) {
 			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
-			if (!bh) {
-				p_blkno++;
+			if (!bh)
 				continue;
-			}
 
 			brelse(bh);
 			bh = NULL;
@@ -1194,7 +1192,6 @@ static int ocfs2_force_read_journal(stru
 
 			brelse(bh);
 			bh = NULL;
-			p_blkno++;
 		}
 
 		v_blkno += p_blocks;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
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
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

