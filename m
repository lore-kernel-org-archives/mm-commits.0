From: akpm@linux-foundation.org
Subject: [merged] fsnotify-dont-bug-in-fsnotify_destroy_mark.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:22 -0800
Message-ID: <20120117210123.13E7020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37788 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2AQVIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:08:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: don't BUG in fsnotify_destroy_mark()
has been removed from the -mm tree.  Its filename was
     fsnotify-dont-bug-in-fsnotify_destroy_mark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
