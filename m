From: akpm@linux-foundation.org
Subject: + fsnotify-handle-subfiles-perm-events.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:17:15 -0700
Message-ID: <20120404221715.BF4EDA042C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58583 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab2DDWRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:17:18 -0400
Received: by wejx9 with SMTP id x9so38877wej.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:17:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: naota@elisp.net, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fsnotify: handle subfiles' perm events
has been added to the -mm tree.  Its filename is
     fsnotify-handle-subfiles-perm-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naohiro Aota <naota@elisp.net>
Subject: fsnotify: handle subfiles' perm events

Recently I'm working on fanotify and found the following strange
behaviors.

I wrote a program to set fanotify_mark on "/tmp/block" and FAN_DENY
all events notified.

fanotify_mask = FAN_ALL_EVENTS | FAN_ALL_PERM_EVENTS | FAN_EVENT_ON_CHILD:
$ cd /tmp/block; cat foo
cat: foo: Operation not permitted

Operation on the file is blocked as expected.

But,

fanotify_mask = FAN_ALL_PERM_EVENTS | FAN_EVENT_ON_CHILD:
$ cd /tmp/block; cat foo
aaa

It's not blocked anymore.  This is confusing behavior.  Also reading
commit "fsnotify: call fsnotify_parent in perm events", it seems like
fsnotify should handle subfiles' perm events as well as the other notify
events.

With this patch, regardless of FAN_ALL_EVENTS set or not:
$ cd /tmp/block; cat foo
cat: foo: Operation not permitted

Operation on the file is now blocked properly.


FS_OPEN_PERM and FS_ACCESS_PERM are not listed on FS_EVENTS_POSS_ON_CHILD.
 Due to fsnotify_inode_watches_children() check, if you only specify only
these events as fsnotify_mask, you don't get subfiles' perm events
notified.

This patch add the events to FS_EVENTS_POSS_ON_CHILD to get them notified
even if only these events are specified to fsnotify_mask.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify_backend.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fsnotify_backend.h~fsnotify-handle-subfiles-perm-events include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-handle-subfiles-perm-events
+++ a/include/linux/fsnotify_backend.h
@@ -60,7 +60,7 @@
 #define FS_EVENTS_POSS_ON_CHILD   (FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
 				   FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
 				   FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
-				   FS_DELETE)
+				   FS_DELETE | FS_OPEN_PERM | FS_ACCESS_PERM)
 
 #define FS_MOVE			(FS_MOVED_FROM | FS_MOVED_TO)
 
_
Subject: Subject: fsnotify: handle subfiles' perm events

Patches currently in -mm which might be from naota@elisp.net are

fsnotify-handle-subfiles-perm-events.patch

