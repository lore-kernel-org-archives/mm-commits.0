From: akpm@linux-foundation.org
Subject: [merged] fsnotify-fix-check-in-inotify-fdinfo-printing.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:34 -0700
Message-ID: <55ef227e.68/zQgl9cmEj1kvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: fix check in inotify fdinfo printing
has been removed from the -mm tree.  Its filename was
     fsnotify-fix-check-in-inotify-fdinfo-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: fix check in inotify fdinfo printing

A check in inotify_fdinfo() checking whether mark is valid was always true
due to a bug.  Luckily we can never get to invalidated marks since we hold
mark_mutex and invalidated marks get removed from the group list when they
are invalidated under that mutex.

Anyway fix the check to make code more future proof.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/notify/fdinfo.c~fsnotify-fix-check-in-inotify-fdinfo-printing fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fsnotify-fix-check-in-inotify-fdinfo-printing
+++ a/fs/notify/fdinfo.c
@@ -76,7 +76,8 @@ static void inotify_fdinfo(struct seq_fi
 	struct inotify_inode_mark *inode_mark;
 	struct inode *inode;
 
-	if (!(mark->flags & (FSNOTIFY_MARK_FLAG_ALIVE | FSNOTIFY_MARK_FLAG_INODE)))
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE) ||
+	    !(mark->flags & FSNOTIFY_MARK_FLAG_INODE))
 		return;
 
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
_

Patches currently in -mm which might be from jack@suse.cz are


