From: akpm@linux-foundation.org
Subject: [merged] inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:12 -0700
Message-ID: <20130507174612.880F35A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:62089 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3EGRqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:13 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so73165ghr.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhaohongjiang@huawei.com, Jim.Somerville@windriver.com, eparis@parisplace.org, jmarchan@redhat.com, paul.gortmaker@windriver.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: invalid mask should return a error number but not set it
has been removed from the -mm tree.  Its filename was
     inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: inotify: invalid mask should return a error number but not set it

When we run the crackerjack testsuite, the inotify_add_watch test is
stalled.

This is caused by the invalid mask 0 - the task is waiting for the event
but it never comes.  inotify_add_watch() should return -EINVAL as it did
before commit 676a0675cf9200 ("inotify: remove broken mask checks causing
unmount to be EINVAL").  That commit removes the invalid mask check, but
that check is needed.

Check the mask's ALL_INOTIFY_BITS before the inotify_arg_to_mask() call. 
If none are set, just return -EINVAL.

Because IN_UNMOUNT is in ALL_INOTIFY_BITS, this change will not trigger
the problem that above commit fixed.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Acked-by: Jim Somerville <Jim.Somerville@windriver.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-invalid-mask-should-return-a-error-number-but-not-set-it fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-invalid-mask-should-return-a-error-number-but-not-set-it
+++ a/fs/notify/inotify/inotify_user.c
@@ -570,7 +570,6 @@ static int inotify_update_existing_watch
 	int add = (arg & IN_MASK_ADD);
 	int ret;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
@@ -621,7 +620,6 @@ static int inotify_new_watch(struct fsno
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
@@ -747,6 +745,10 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	int ret;
 	unsigned flags = 0;
 
+	/* don't allow invalid bits: we don't want flags set */
+	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
+		return -EINVAL;
+
 	f = fdget(fd);
 	if (unlikely(!f.file))
 		return -EBADF;
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

origin.patch
parisc-remove-the-second-argument-of-kmap_atomic.patch

