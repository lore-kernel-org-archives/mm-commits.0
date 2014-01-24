From: akpm@linux-foundation.org
Subject: + ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
 added to -mm tree
Date: Fri, 24 Jan 2014 14:32:33 -0800
Message-ID: <52e2ea01.AGVaB0K7HC4lglfy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaAXWce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 17:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liucn@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: + ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,mfasheh@suse.com,younger.liucn@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 14:32:33 -0800


The patch titled
     Subject: ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix
has been added to the -mm tree.  Its filename is
     ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch

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

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

