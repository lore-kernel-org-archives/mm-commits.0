From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch removed from
 -mm tree
Date: Mon, 10 Feb 2014 14:21:48 -0800
Message-ID: <52f950fc.YDylUwKxdxi6cvm4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBJWVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liucn@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,mfasheh@suse.com,younger.liucn@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:21:48 -0800


The patch titled
     Subject: ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch

This patch was dropped because it was folded into ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix

return -EROFS, not 0

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Younger Liu <younger.liucn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix
+++ a/fs/ocfs2/file.c
@@ -186,7 +186,7 @@ static int ocfs2_sync_file(struct file *
 			      (unsigned long long)datasync);
 
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return 0;
+		return -EROFS;
 
 	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (err)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch
mm-memory-failurec-move-refcount-only-in-mf_count_increased-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

