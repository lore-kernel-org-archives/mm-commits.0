From: akpm@linux-foundation.org
Subject: + inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:22:19 -0700
Message-ID: <20130327202219.D501631C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:46758 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3C0UWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:22:21 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so576949qeb.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:22:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, tj@kernel.org


The patch titled
     Subject: inotify: convert inotify_add_to_idr() to use idr_alloc_cyclic()
has been added to the -mm tree.  Its filename is
     inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: inotify: convert inotify_add_to_idr() to use idr_alloc_cyclic()

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    8 ++------
 include/linux/fsnotify_backend.h |    1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic
+++ a/fs/notify/inotify/inotify_user.c
@@ -359,7 +359,6 @@ static int inotify_find_inode(const char
 }
 
 static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
-			      int *last_wd,
 			      struct inotify_inode_mark *i_mark)
 {
 	int ret;
@@ -367,11 +366,10 @@ static int inotify_add_to_idr(struct idr
 	idr_preload(GFP_KERNEL);
 	spin_lock(idr_lock);
 
-	ret = idr_alloc(idr, i_mark, *last_wd + 1, 0, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(idr, i_mark, 1, 0, GFP_NOWAIT);
 	if (ret >= 0) {
 		/* we added the mark to the idr, take a reference */
 		i_mark->wd = ret;
-		*last_wd = i_mark->wd;
 		fsnotify_get_mark(&i_mark->fsn_mark);
 	}
 
@@ -638,8 +636,7 @@ static int inotify_new_watch(struct fsno
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
-	ret = inotify_add_to_idr(idr, idr_lock, &group->inotify_data.last_wd,
-				 tmp_i_mark);
+	ret = inotify_add_to_idr(idr, idr_lock, tmp_i_mark);
 	if (ret)
 		goto out_err;
 
@@ -697,7 +694,6 @@ static struct fsnotify_group *inotify_ne
 
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
-	group->inotify_data.last_wd = 0;
 	group->inotify_data.user = get_current_user();
 
 	if (atomic_inc_return(&group->inotify_data.user->inotify_devs) >
diff -puN include/linux/fsnotify_backend.h~inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic
+++ a/include/linux/fsnotify_backend.h
@@ -157,7 +157,6 @@ struct fsnotify_group {
 		struct inotify_group_private_data {
 			spinlock_t	idr_lock;
 			struct idr      idr;
-			u32             last_wd;
 			struct user_struct      *user;
 		} inotify_data;
 #endif
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch

