From: akpm@linux-foundation.org
Subject: + fsnotify-dont-bug-in-fsnotify_destroy_mark.patch added to -mm tree
Date: Fri, 13 Jan 2012 13:48:25 -0800
Message-ID: <20120113214825.A3FD710016D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38787 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2AMVs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 16:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fsnotify: don't BUG in fsnotify_destroy_mark()
has been added to the -mm tree.  Its filename is
     fsnotify-dont-bug-in-fsnotify_destroy_mark.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miklos Szeredi <mszeredi@suse.cz>
Subject: fsnotify: don't BUG in fsnotify_destroy_mark()

Removing the parent of a watched file results in "kernel BUG at
fs/notify/mark.c:139".

To reproduce

  add "-w /tmp/audit/dir/watched_file" to audit.rules
  rm -rf /tmp/audit/dir

This is caused by fsnotify_destroy_mark() being called without an
extra reference taken by the caller.

Reported by Francesco Cosoleto here:

  https://bugzilla.novell.com/show_bug.cgi?id=689860

Fix by removing the BUG_ON and adding a comment about not accessing mark after
the iput.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-dont-bug-in-fsnotify_destroy_mark fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-dont-bug-in-fsnotify_destroy_mark
+++ a/fs/notify/mark.c
@@ -124,9 +124,6 @@ void fsnotify_destroy_mark(struct fsnoti
 
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 
-	/* 1 from caller and 1 for being on i_list/g_list */
-	BUG_ON(atomic_read(&mark->refcnt) < 2);
