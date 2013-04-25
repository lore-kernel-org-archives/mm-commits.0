From: akpm@linux-foundation.org
Subject: + inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch added to -mm tree
Date: Thu, 25 Apr 2013 14:13:11 -0700
Message-ID: <20130425211311.7EF5D5A4250@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:48424 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3DYVNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 17:13:12 -0400
Received: by mail-qe0-f74.google.com with SMTP id 6so139319qeb.3
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 14:13:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaohongjiang@huawei.com, Jim.Somerville@windriver.com, eparis@parisplace.org, jmarchan@redhat.com, paul.gortmaker@windriver.com, stable@vger.kernel.org


The patch titled
     Subject: inotify: invalid mask should return a error number but not set it
has been added to the -mm tree.  Its filename is
     inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -572,7 +572,6 @@ static int inotify_update_existing_watch
 	int add = (arg & IN_MASK_ADD);
 	int ret;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
@@ -623,7 +622,6 @@ static int inotify_new_watch(struct fsno
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
@@ -751,6 +749,10 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	int ret;
 	unsigned flags = 0;
 
+	/* don't allow invalid bits: we don't want flags set */
+	if (unlikely(!(arg & ALL_INOTIFY_BITS)))
+		return -EINVAL;
+
 	f = fdget(fd);
 	if (unlikely(!f.file))
 		return -EBADF;
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch

