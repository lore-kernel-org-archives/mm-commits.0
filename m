From: akpm@linux-foundation.org
Subject: + inotify-fix-check-for-one-shot-watches-before-destroying-them.patch added to -mm tree
Date: Thu, 07 Feb 2008 13:44:12 -0800
Message-ID: <200802072144.m17LiCxj024093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327AbYBGVon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 16:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ulissesf@gmail.com, amy.griffis@hp.com, clem.taylor@gmail.com, rlove@google.com, stable@kernel.org, ttb@tentacle.dhs.org


The patch titled
     inotify: fix check for one-shot watches before destroying them
has been added to the -mm tree.  Its filename is
     inotify-fix-check-for-one-shot-watches-before-destroying-them.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

inotify-fix-check-for-one-shot-watches-before-destroying-them.patch
