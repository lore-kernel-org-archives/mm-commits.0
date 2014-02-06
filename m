From: akpm@linux-foundation.org
Subject: +
 ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix.patch
 added to -mm tree
Date: Thu, 06 Feb 2014 15:50:37 -0800
Message-ID: <52f41fcd.uFl46p2vYbZ+PfyQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaBFXui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 18:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, akpm@linux-foundation.org

Subject: + ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 15:50:37 -0800


The patch titled
     Subject: ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix
has been added to the -mm tree.  Its filename is
     ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix.patch

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
Subject: ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix

add missed ocfs2_inode_unlock()

Cc: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix
+++ a/fs/ocfs2/file.c
@@ -2631,6 +2631,7 @@ static loff_t ocfs2_file_llseek(struct f
 		 */
 		ret = ocfs2_inode_lock(inode, NULL, 0);
 		if (ret < 0) {
+			ocfs2_inode_unlock(inode, 0);
 			mlog_errno(ret);
 			goto out;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

