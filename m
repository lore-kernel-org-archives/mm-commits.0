From: akpm@linux-foundation.org
Subject: + hugetlbfs-lessen-the-impact-of-a-deprecation-warning.patch added to -mm tree
Date: Wed, 10 Nov 2010 20:47:07 -0800
Message-ID: <201011110449.oAB4nXmH025447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406Ab0KKEtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 23:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     hugetlbfs: lessen the impact of a deprecation warning
has been added to the -mm tree.  Its filename is
     hugetlbfs-lessen-the-impact-of-a-deprecation-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
hugetlbfs-lessen-the-impact-of-a-deprecation-warning.patch

