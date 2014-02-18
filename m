From: akpm@linux-foundation.org
Subject: + hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch added to -mm tree
Date: Tue, 18 Feb 2014 14:07:38 -0800
Message-ID: <5303d9aa.4bESaWfXALhMOTKs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaBRWHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 17:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sougata@tuxera.com, slava@dubeyko.com, khoroshilov@ispras.ru, hch@lst.de, akpm@linux-foundation.org

Subject: + hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hch@lst.de,khoroshilov@ispras.ru,slava@dubeyko.com,sougata@tuxera.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 14:07:38 -0800


The patch titled
     Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix
has been added to the -mm tree.  Its filename is
     hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch

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
Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix

take extents_lock before taking a copy of ->alloc_blocks

Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix
+++ a/fs/hfsplus/extents.c
@@ -556,11 +556,13 @@ void hfsplus_file_truncate(struct inode
 
 	blk_cnt = (inode->i_size + HFSPLUS_SB(sb)->alloc_blksz - 1) >>
 			HFSPLUS_SB(sb)->alloc_blksz_shift;
+
+	mutex_lock(&hip->extents_lock);
+
 	alloc_cnt = hip->alloc_blocks;
 	if (blk_cnt == alloc_cnt)
-		goto out;
+		goto out_unlock;
 
-	mutex_lock(&hip->extents_lock);
 	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
 	if (res) {
 		mutex_unlock(&hip->extents_lock);
@@ -594,6 +596,7 @@ void hfsplus_file_truncate(struct inode
 	hfs_find_exit(&fd);
 
 	hip->alloc_blocks = blk_cnt;
+out_unlock:
 	mutex_unlock(&hip->extents_lock);
 out:
 	hip->phys_size = inode->i_size;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

