From: akpm@linux-foundation.org
Subject: [merged] fsnotify-handle-subfiles-perm-events.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:41:49 -0700
Message-ID: <20120601194149.774ECA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:32939 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2FATlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:41:51 -0400
Received: by bkty5 with SMTP id y5so138900bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:41:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: naota@elisp.net, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: handle subfiles' perm events
has been removed from the -mm tree.  Its filename was
     fsnotify-handle-subfiles-perm-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from naota@elisp.net are

origin.patch
linux-next.patch

