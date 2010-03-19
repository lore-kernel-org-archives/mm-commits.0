From: akpm@linux-foundation.org
Subject: + inotify-dont-leak-user-struct-on-inotify-release.patch added to -mm tree
Date: Fri, 19 Mar 2010 13:56:16 -0700
Message-ID: <201003192056.o2JKuGT8012007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905Ab0CSU40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 16:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, eparis@parisplace.org, stable@kernel.org


The patch titled
     inotify: don't leak user struct on inotify release
has been added to the -mm tree.  Its filename is
     inotify-dont-leak-user-struct-on-inotify-release.patch

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
Subject: inotify: don't leak user struct on inotify release
From: Pavel Emelyanov <xemul@openvz.org>

inotify_new_group() receives a get_uid-ed user_struct and saves the
reference on group->inotify_data.user.  The problem is that free_uid() is
never called on it.

Issue seem to be introduced by 63c882a0 (inotify: reimplement inotify
using fsnotify) after 2.6.30.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Eric Paris <eparis@parisplace.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_fsnotify.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/notify/inotify/inotify_fsnotify.c~inotify-dont-leak-user-struct-on-inotify-release fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~inotify-dont-leak-user-struct-on-inotify-release
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -28,6 +28,7 @@
 #include <linux/path.h> /* struct path */
 #include <linux/slab.h> /* kmem_* */
 #include <linux/types.h>
+#include <linux/sched.h>
 
 #include "inotify.h"
 
@@ -200,6 +201,7 @@ static void inotify_free_group_priv(stru
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
+	free_uid(group->inotify_data.user);
 }
 
 void inotify_free_event_priv(struct fsnotify_event_private_data *fsn_event_priv)
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
inotify-dont-leak-user-struct-on-inotify-release.patch
reiser4.patch

