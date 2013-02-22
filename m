From: akpm@linux-foundation.org
Subject: [merged] inotify-remove-broken-mask-checks-causing-unmount-to-be-einval.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:35 -0800
Message-ID: <20130222203736.427055A41B6__37437.1216785677$1361565493$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:34336 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3BVUhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:37 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so103758vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jim.Somerville@windriver.com, eparis@parisplace.org, jmarchan@redhat.com, john@johnmccutchan.com, paul.gortmaker@windriver.com, rlove@rlove.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: remove broken mask checks causing unmount to be EINVAL
has been removed from the -mm tree.  Its filename was
     inotify-remove-broken-mask-checks-causing-unmount-to-be-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jim Somerville <Jim.Somerville@windriver.com>
Subject: inotify: remove broken mask checks causing unmount to be EINVAL

Running the command:

	inotifywait -e unmount /mnt/disk

immediately aborts with a -EINVAL return code.  This is however a valid
parameter.  This abort occurs only if unmount is the sole event parameter.
 If other event parameters are supplied, then the unmount event wait will
work.

The problem was introduced by commit 44b350fc23e ("inotify: Fix mask
checks").  In that commit, it states:

	The mask checks in inotify_update_existing_watch() and
	inotify_new_watch() are useless because inotify_arg_to_mask()
	sets FS_IN_IGNORED and FS_EVENT_ON_CHILD bits anyway.

But instead of removing the useless checks, it did this:

	        mask = inotify_arg_to_mask(arg);
	-       if (unlikely(!mask))
	+       if (unlikely(!(mask & IN_ALL_EVENTS)))
	                return -EINVAL;

The problem is that IN_ALL_EVENTS doesn't include IN_UNMOUNT, and other
parts of the code keep IN_UNMOUNT separate from IN_ALL_EVENTS.  So the
check should be:

	if (unlikely(!(mask & (IN_ALL_EVENTS | IN_UNMOUNT))))

But inotify_arg_to_mask(arg) always sets the IN_UNMOUNT bit in the mask
anyway, so the check is always going to pass and thus should simply be
removed.  Also note that inotify_arg_to_mask completely controls what mask
bits get set from arg, there's no way for invalid bits to get enabled
there.

Lets fix it by simply removing the useless broken checks.

Signed-off-by: Jim Somerville <Jim.Somerville@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: <stable@vger.kernel.org>		[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-remove-broken-mask-checks-causing-unmount-to-be-einval fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-remove-broken-mask-checks-causing-unmount-to-be-einval
+++ a/fs/notify/inotify/inotify_user.c
@@ -576,8 +576,6 @@ static int inotify_update_existing_watch
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!(mask & IN_ALL_EVENTS)))
-		return -EINVAL;
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
@@ -629,8 +627,6 @@ static int inotify_new_watch(struct fsno
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!(mask & IN_ALL_EVENTS)))
-		return -EINVAL;
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
 	if (unlikely(!tmp_i_mark))
_

Patches currently in -mm which might be from Jim.Somerville@windriver.com are

origin.patch

