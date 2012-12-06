From: akpm@linux-foundation.org
Subject: + fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch added to -mm tree
Date: Thu, 06 Dec 2012 15:28:56 -0800
Message-ID: <20121206232856.920B6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35480 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2LFX26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2012 18:28:58 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so821770ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Dec 2012 15:28:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, eparis@redhat.com


The patch titled
     Subject: fs/notify/inode_mark.c: make fsnotify_find_inode_mark_locked() static
has been added to the -mm tree.  Its filename is
     fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -124,8 +124,9 @@ void fsnotify_clear_inode_marks_by_group
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

linux-next.patch
block-fix-sparse-warning.patch
drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch
drivers-rtc-rtc-s3cc-convert-to-use-devm_-api.patch
fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch

