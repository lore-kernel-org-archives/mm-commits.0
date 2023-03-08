Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520B8C678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 21:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCHV7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 16:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCHV7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 16:59:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A6E64278
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 13:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84B436198C
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 21:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6433C433D2;
        Wed,  8 Mar 2023 21:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678312745;
        bh=PE+om2vZrNvjcDg2VNHcQh7ZTxfeme92VXf2+jmM098=;
        h=Date:To:From:Subject:From;
        b=roKF6JxXmDQnsgVourt3Uy07eHVonB9jyLhB5nLwwL4VJdqVrfSmzB5yLaCE1XnLG
         WrVyYuZnP0KYNN7xVa2tWt52yoJGvFb6ij9cgdg8Is5oU1fB47xC/bApTGs65ekSIy
         354UippxtJ2OX0Z6iIphPhxvZS9hQtyb4TGSkewE=
Date:   Wed, 08 Mar 2023 13:59:04 -0800
To:     mm-commits@vger.kernel.org, xmu@redhiat.com,
        viro@zeniv.linux.org.uk, soheil@google.com,
        jacob.e.keller@intel.com, ebiggers@kernel.org,
        cmaiolino@redhat.com, brauner@kernel.org, axboe@kernel.dk,
        pabeni@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + epoll-use-refcount-to-reduce-ep_mutex-contention-v5.patch added to mm-nonmm-unstable branch
Message-Id: <20230308215904.D6433C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll-use-refcount-to-reduce-ep_mutex-contention-v5
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     epoll-use-refcount-to-reduce-ep_mutex-contention-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/epoll-use-refcount-to-reduce-ep_mutex-contention-v5.patch

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
From: Paolo Abeni <pabeni@redhat.com>
Subject: epoll-use-refcount-to-reduce-ep_mutex-contention-v5
Date: Wed, 8 Mar 2023 22:51:31 +0100

update some comments

Link: https://lkml.kernel.org/r/323de732635cc3513c1837c6cbb98f012174f994.1678312201.git.pabeni@redhat.com
Tested-by: Xiumei Mu <xmu@redhiat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/eventpoll.c~epoll-use-refcount-to-reduce-ep_mutex-contention-v5
+++ a/fs/eventpoll.c
@@ -714,6 +714,8 @@ static void ep_free(struct eventpoll *ep
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
  * If the dying flag is set, do the removal only if force is true.
+ * This prevents ep_clear_and_put() from dropping all the ep references
+ * while running concurrently with eventpoll_release_file().
  * Returns true if the eventpoll can be disposed.
  */
 static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
@@ -941,14 +943,13 @@ void eventpoll_release_file(struct file
 	bool dispose;
 
 	/*
-	 * Use the 'dying' flag to prevent a concurrent ep_cleat_and_put() from
+	 * Use the 'dying' flag to prevent a concurrent ep_clear_and_put() from
 	 * touching the epitems list before eventpoll_release_file() can access
 	 * the ep->mtx.
 	 */
 again:
 	spin_lock(&file->f_lock);
 	if (file->f_ep && file->f_ep->first) {
-		/* detach from ep tree */
 		epi = hlist_entry(file->f_ep->first, struct epitem, fllink);
 		epi->dying = true;
 		spin_unlock(&file->f_lock);
_

Patches currently in -mm which might be from pabeni@redhat.com are

epoll-use-refcount-to-reduce-ep_mutex-contention.patch
epoll-use-refcount-to-reduce-ep_mutex-contention-v5.patch

