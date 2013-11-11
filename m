From: akpm@linux-foundation.org
Subject: + debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch
 added to -mm tree
Date: Mon, 11 Nov 2013 15:18:55 -0800
Message-ID: <528165df.Yl8YoZOnrIUZOnrN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3KKXS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, eilong@broadcom.com, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: + debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch added to -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,eilong@broadcom.com,gregkh@linuxfoundation.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:18:55 -0800


The patch titled
     Subject: debugfs: use list_next_entry() in debugfs_remove_recursive()
has been added to the -mm tree.  Its filename is
     debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: debugfs: use list_next_entry() in debugfs_remove_recursive()

Change debugfs_remove_recursive() to use list_next_entry(child), no
changes in generated code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/debugfs/inode.c~debugfs-use-list_next_entry-in-debugfs_remove_recursive fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~debugfs-use-list_next_entry-in-debugfs_remove_recursive
+++ a/fs/debugfs/inode.c
@@ -566,8 +566,7 @@ void debugfs_remove_recursive(struct den
 	mutex_lock(&parent->d_inode->i_mutex);
 
 	if (child != dentry) {
-		next = list_entry(child->d_u.d_child.next, struct dentry,
-					d_u.d_child);
+		next = list_next_entry(child, d_u.d_child);
 		goto up;
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-make-kthread_create-killable.patch
list-introduce-list_next_entry-and-list_prev_entry.patch
list-change-list_for_each_entry-to-use-list__entry.patch
list-introduce-list_last_entry-use-list_firstlast_entry.patch
debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch
exec-ptrace-fix-get_dumpable-incorrect-tests.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

