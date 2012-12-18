From: akpm@linux-foundation.org
Subject: [merged] fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:56 -0800
Message-ID: <20121218200257.2AA3020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54913 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:59 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so69635lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tushar.behera@linaro.org, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify/inode_mark.c: make fsnotify_find_inode_mark_locked() static
has been removed from the -mm tree.  Its filename was
     fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: fs/notify/inode_mark.c: make fsnotify_find_inode_mark_locked() static

Fixes following sparse warning.
fs/notify/inode_mark.c:127:22: warning: symbol
'fsnotify_find_inode_mark_locked' was not declared. Should it be static?

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inode_mark.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/notify/inode_mark.c~fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static
+++ a/fs/notify/inode_mark.c
@@ -116,8 +116,9 @@ void fsnotify_clear_inode_marks_by_group
  * given a group and inode, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
  */
-struct fsnotify_mark *fsnotify_find_inode_mark_locked(struct fsnotify_group *group,
-						      struct inode *inode)
+static struct fsnotify_mark *fsnotify_find_inode_mark_locked(
+		struct fsnotify_group *group,
+		struct inode *inode)
 {
 	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
_

Patches currently in -mm which might be from tushar.behera@linaro.org are

origin.patch
linux-next.patch

