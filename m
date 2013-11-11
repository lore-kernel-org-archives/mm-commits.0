From: akpm@linux-foundation.org
Subject: [wrecked] anon_inodefs-forbid-open-via-proc.patch removed from
 -mm tree
Date: Mon, 11 Nov 2013 10:42:28 -0800
Message-ID: <52812514.6HugX9jl6OKN+1Xz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3KKSm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:42:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luto@amacapital.net, oleg@redhat.com

Subject: [wrecked] anon_inodefs-forbid-open-via-proc.patch removed from -mm tree
To: oleg@redhat.com,luto@amacapital.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:42:28 -0800


The patch titled
     Subject: anon_inodefs: forbid open via /proc
has been removed from the -mm tree.  Its filename was
     anon_inodefs-forbid-open-via-proc.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: anon_inodefs: forbid open via /proc

open("/proc/pid/$anon-fd") should fail, we can't create the new file with
correct f_op/etc correctly.  Currently this creates the bogus file with
the empty anon_inode_fops, this is harmless but still wrong and
misleading.

Add anon_inode_fops->anon_open() which simply returns ENXIO like
sock_no_open() does in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/anon_inodes.c~anon_inodefs-forbid-open-via-proc fs/anon_inodes.c
--- a/fs/anon_inodes.c~anon_inodefs-forbid-open-via-proc
+++ a/fs/anon_inodes.c
@@ -24,7 +24,15 @@
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
 static struct inode *anon_inode_inode;
-static const struct file_operations anon_inode_fops;
+
+static int anon_open(struct inode *inode, struct file *file)
+{
+	return -ENXIO;
+}
+
+static const struct file_operations anon_inode_fops = {
+	.open = anon_open,
+};
 
 /*
  * anon_inodefs_dname() is called from d_path().
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-make-kthread_create-killable.patch
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

