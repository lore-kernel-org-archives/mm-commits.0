From: akpm@linux-foundation.org
Subject: [merged] sendfile-allows-bypassing-of-notifier-events.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:28 -0800
Message-ID: <20121221204029.1E59420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:47772 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2LUUkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:31 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so272438bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swolchok@umich.edu, alan@linux.intel.com, axboe@kernel.dk, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sendfile: allows bypassing of notifier events
has been removed from the -mm tree.  Its filename was
     sendfile-allows-bypassing-of-notifier-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Scott Wolchok <swolchok@umich.edu>
Subject: sendfile: allows bypassing of notifier events

do_sendfile() in fs/read_write.c does not call the fsnotify functions,
unlike its neighbors.  This manifests as a lack of inotify ACCESS events
when a file is sent using sendfile(2).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=12812

[akpm@linux-foundation.org: use fsnotify_modify(out.file), not fsnotify_access(), per Dave]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Scott Wolchok <swolchok@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/read_write.c~sendfile-allows-bypassing-of-notifier-events fs/read_write.c
--- a/fs/read_write.c~sendfile-allows-bypassing-of-notifier-events
+++ a/fs/read_write.c
@@ -935,6 +935,8 @@ ssize_t do_sendfile(int out_fd, int in_f
 	if (retval > 0) {
 		add_rchar(current, retval);
 		add_wchar(current, retval);
+		fsnotify_access(in.file);
+		fsnotify_modify(out.file);
 	}
 
 	inc_syscr(current);
_

Patches currently in -mm which might be from swolchok@umich.edu are

origin.patch

