From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch removed
 from -mm tree
Date: Wed, 15 Oct 2014 13:22:34 -0700
Message-ID: <543ed78a.bu/uEjM3fKWZZdNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaJOUWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix

fix missed unlock on error path

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix
+++ a/fs/ocfs2/journal.c
@@ -2160,8 +2160,7 @@ static int ocfs2_recover_orphans(struct
 			ret = ocfs2_inode_lock(inode, &di_bh, 1);
 			if (ret) {
 				mlog_errno(ret);
-				spin_unlock(&oi->ip_lock);
-				goto out;
+				goto out_unlock;
 			}
 			ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
 			ocfs2_inode_unlock(inode, 1);
@@ -2173,14 +2172,13 @@ static int ocfs2_recover_orphans(struct
 					OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS);
 			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
-				goto out;
+				goto out_unlock;
 			}
 			ret = ocfs2_del_inode_from_orphan(osb, handle, inode);
 			if (ret) {
 				mlog_errno(ret);
 				ocfs2_commit_trans(osb, handle);
-				spin_unlock(&oi->ip_lock);
-				goto out;
+				goto out_unlock;
 			}
 			ocfs2_commit_trans(osb, handle);
 		}
@@ -2200,7 +2198,10 @@ static int ocfs2_recover_orphans(struct
 		inode = iter;
 	}
 
-out:
+	return ret;
+
+out_unlock:
+	spin_unlock(&oi->ip_lock);
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

