From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-lessen-the-impact-of-a-deprecation-warning.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:35 -0800
Message-ID: <201011161933.oAGJXmMF003136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674Ab0KPTd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: lessen the impact of a deprecation warning
has been removed from the -mm tree.  Its filename was
     hugetlbfs-lessen-the-impact-of-a-deprecation-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: lessen the impact of a deprecation warning
From: Dave Jones <davej@redhat.com>

WARN_ONCE is a bit strong for a deprecation warning, given that it spews a
huge backtrace.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-lessen-the-impact-of-a-deprecation-warning fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-lessen-the-impact-of-a-deprecation-warning
+++ a/fs/hugetlbfs/inode.c
@@ -932,8 +932,7 @@ struct file *hugetlb_file_setup(const ch
 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
-			WARN_ONCE(1,
-			  "Using mlock ulimits for SHM_HUGETLB deprecated\n");
+			printk_once(KERN_WARNING "Using mlock ulimits for SHM_HUGETLB is deprecated\n");
 		} else {
 			*user = NULL;
 			return ERR_PTR(-EPERM);
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch

