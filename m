Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7586C77B6C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 21:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjDLVyb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDLVya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 17:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F9D7AAC
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 14:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9389B611DA
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 21:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F094AC433D2;
        Wed, 12 Apr 2023 21:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681336468;
        bh=XrpWUD2hlkEw9Mb/B4U8GNB6R7TiB6YzWBpmjBmq44U=;
        h=Date:To:From:Subject:From;
        b=aQ1FE4TguZjXbnDwECf52a4zXAmLy+7O0NrxiyFNv0zOtuRkRLbLBJ6oNB5EhlTzT
         rv1v6ygx2Q7mk/nKljG0vsityXteRJKRoix0IamXwBp5lpWnltFxFsxWvhyRavjvJ8
         A8ZnQ+g+3MZgP1v39Sbs4kGbcjhJKig1mxhmTOOE=
Date:   Wed, 12 Apr 2023 14:54:27 -0700
To:     mm-commits@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        dave@stgolabs.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + epoll-rename-global-epmutex.patch added to mm-nonmm-unstable branch
Message-Id: <20230412215427.F094AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: rename global epmutex
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     epoll-rename-global-epmutex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/epoll-rename-global-epmutex.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: epoll: rename global epmutex
Date: Tue, 11 Apr 2023 16:41:59 -0700

As of 4f04cbaf128 ("epoll: use refcount to reduce ep_mutex contention"),
this lock is now specific to nesting cases - inserting an epoll fd onto
another epoll fd.  Rename the lock to be less generic.

Link: https://lkml.kernel.org/r/20230411234159.20421-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/eventpoll.c~epoll-rename-global-epmutex
+++ a/fs/eventpoll.c
@@ -43,7 +43,7 @@
  * LOCKING:
  * There are three level of locking required by epoll :
  *
- * 1) epmutex (mutex)
+ * 1) epnested_mutex (mutex)
  * 2) ep->mtx (mutex)
  * 3) ep->lock (rwlock)
  *
@@ -57,8 +57,8 @@
  * we need a lock that will allow us to sleep. This lock is a
  * mutex (ep->mtx). It is acquired during the event transfer loop,
  * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
- * The epmutex is acquired when inserting an epoll fd onto another epoll
- * fd. We do this so that we walk the epoll tree and ensure that this
+ * The epnested_mutex is acquired when inserting an epoll fd onto another
+ * epoll fd. We do this so that we walk the epoll tree and ensure that this
  * insertion does not create a cycle of epoll file descriptors, which
  * could lead to deadlock. We need a global mutex to prevent two
  * simultaneous inserts (A into B and B into A) from racing and
@@ -74,9 +74,9 @@
  * of epoll file descriptors, we use the current recursion depth as
  * the lockdep subkey.
  * It is possible to drop the "ep->mtx" and to use the global
- * mutex "epmutex" (together with "ep->lock") to have it working,
+ * mutex "epnested_mutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
- * Events that require holding "epmutex" are very rare, while for
+ * Events that require holding "epnested_mutex" are very rare, while for
  * normal operations the epoll private "ep->mtx" will guarantee
  * a better scalability.
  */
@@ -248,7 +248,7 @@ struct ep_pqueue {
 static long max_user_watches __read_mostly;
 
 /* Used for cycles detection */
-static DEFINE_MUTEX(epmutex);
+static DEFINE_MUTEX(epnested_mutex);
 
 static u64 loop_check_gen = 0;
 
@@ -263,7 +263,7 @@ static struct kmem_cache *pwq_cache __re
 
 /*
  * List of files with newly added links, where we may need to limit the number
- * of emanating paths. Protected by the epmutex.
+ * of emanating paths. Protected by the epnested_mutex.
  */
 struct epitems_head {
 	struct hlist_head epitems;
@@ -1337,7 +1337,7 @@ static void ep_rbtree_insert(struct even
  * is connected to n file sources. In this case each file source has 1 path
  * of length 1. Thus, the numbers below should be more than sufficient. These
  * path limits are enforced during an EPOLL_CTL_ADD operation, since a modify
- * and delete can't add additional paths. Protected by the epmutex.
+ * and delete can't add additional paths. Protected by the epnested_mutex.
  */
 static const int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
 static int path_count[PATH_ARR_SIZE];
@@ -2167,7 +2167,7 @@ int do_epoll_ctl(int epfd, int op, int f
 	 * We do not need to take the global 'epumutex' on EPOLL_CTL_ADD when
 	 * the epoll file descriptor is attaching directly to a wakeup source,
 	 * unless the epoll file descriptor is nested. The purpose of taking the
-	 * 'epmutex' on add is to prevent complex toplogies such as loops and
+	 * 'epnested_mutex' on add is to prevent complex toplogies such as loops and
 	 * deep wakeup paths from forming in parallel through multiple
 	 * EPOLL_CTL_ADD operations.
 	 */
@@ -2178,7 +2178,7 @@ int do_epoll_ctl(int epfd, int op, int f
 		if (READ_ONCE(f.file->f_ep) || ep->gen == loop_check_gen ||
 		    is_file_epoll(tf.file)) {
 			mutex_unlock(&ep->mtx);
-			error = epoll_mutex_lock(&epmutex, 0, nonblock);
+			error = epoll_mutex_lock(&epnested_mutex, 0, nonblock);
 			if (error)
 				goto error_tgt_fput;
 			loop_check_gen++;
@@ -2239,7 +2239,7 @@ error_tgt_fput:
 	if (full_check) {
 		clear_tfile_check_list();
 		loop_check_gen++;
-		mutex_unlock(&epmutex);
+		mutex_unlock(&epnested_mutex);
 	}
 
 	fdput(tf);
_

Patches currently in -mm which might be from dave@stgolabs.net are

epoll-rename-global-epmutex.patch

