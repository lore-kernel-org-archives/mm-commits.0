From: akpm@linux-foundation.org
Subject: - inotify-fix-check-for-one-shot-watches-before-destroying-them.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:19 -0800
Message-ID: <200802082011.m18KB1IP010084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbYBHUMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:12:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ulissesf@gmail.com, amy.griffis@hp.com, clem.taylor@gmail.com, rlove@google.com, stable@kernel.org, ttb@tentacle.dhs.org, mm-commits@vger.kernel.org


The patch titled
     inotify: fix check for one-shot watches before destroying them
has been removed from the -mm tree.  Its filename was
     inotify-fix-check-for-one-shot-watches-before-destroying-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: fix check for one-shot watches before destroying them
From: Ulisses Furquim <ulissesf@gmail.com>

As the IN_ONESHOT bit is never set when an event is sent we must check it
in the watch's mask and not in the event's mask.

Signed-off-by: Ulisses Furquim <ulissesf@gmail.com>
Reported-by: "Clem Taylor" <clem.taylor@gmail.com>
Tested-by: "Clem Taylor" <clem.taylor@gmail.com>
Cc: Amy Griffis <amy.griffis@hp.com>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inotify_user.c~inotify-fix-check-for-one-shot-watches-before-destroying-them fs/inotify_user.c
--- a/fs/inotify_user.c~inotify-fix-check-for-one-shot-watches-before-destroying-them
+++ a/fs/inotify_user.c
@@ -283,7 +283,7 @@ static void inotify_dev_queue_event(stru
 	/* we can safely put the watch as we don't reference it while
 	 * generating the event
 	 */
-	if (mask & IN_IGNORED || mask & IN_ONESHOT)
+	if (mask & IN_IGNORED || w->mask & IN_ONESHOT)
 		put_inotify_watch(w); /* final put */
 
 	/* coalescing: drop this event if it is a dupe of the previous */
_

Patches currently in -mm which might be from ulissesf@gmail.com are

origin.patch
