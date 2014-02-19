From: akpm@linux-foundation.org
Subject: + hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
 added to -mm tree
Date: Wed, 19 Feb 2014 12:58:31 -0800
Message-ID: <53051af7.wkFHl42BmdKThppP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaBSU6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 15:58:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sougata@tuxera.com, slava@dubeyko.com, khoroshilov@ispras.ru, hch@lst.de, akpm@linux-foundation.org

Subject: + hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hch@lst.de,khoroshilov@ispras.ru,slava@dubeyko.com,sougata@tuxera.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 12:58:31 -0800


The patch titled
     Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix
has been added to the -mm tree.  Its filename is
     hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

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
Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix

remove now-unused label `out'

Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix
+++ a/fs/hfsplus/extents.c
@@ -598,7 +598,6 @@ void hfsplus_file_truncate(struct inode
 	hip->alloc_blocks = blk_cnt;
 out_unlock:
 	mutex_unlock(&hip->extents_lock);
-out:
 	hip->phys_size = inode->i_size;
 	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
 		sb->s_blocksize_bits;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
mmnuma-reorganize-change_pmd_range-fix.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

