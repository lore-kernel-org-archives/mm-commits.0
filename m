From: akpm@linux-foundation.org
Subject: +
 fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch added
 to -mm tree
Date: Tue, 30 Jun 2020 16:47:41 -0700
Message-ID: <20200630234741.Axfko%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgF3Xrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 19:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, fengyubo3@huawei.com


The patch titled
     Subject: fatfs: switch write_lock to read_lock in fat_ioctl_get_attributes
has been added to the -mm tree.  Its filename is
     fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yubo Feng <fengyubo3@huawei.com>
Subject: fatfs: switch write_lock to read_lock in fat_ioctl_get_attributes

There is no need to hold write_lock in fat_ioctl_get_attributes. 
write_lock may make an impact on concurrency of fat_ioctl_get_attributes.

Link: http://lkml.kernel.org/r/1593308053-12702-1-git-send-email-fengyubo3@huawei.com
Signed-off-by: Yubo Feng <fengyubo3@huawei.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fat/file.c~fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes
+++ a/fs/fat/file.c
@@ -25,9 +25,9 @@ static int fat_ioctl_get_attributes(stru
 {
 	u32 attr;
 
-	inode_lock(inode);
+	inode_lock_shared(inode);
 	attr = fat_make_attrs(inode);
-	inode_unlock(inode);
+	inode_unlock_shared(inode);
 
 	return put_user(attr, user_attr);
 }
_

Patches currently in -mm which might be from fengyubo3@huawei.com are

fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch
