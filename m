From: akpm@linux-foundation.org
Subject: + sendfile-allows-bypassing-of-notifier-events.patch added to -mm tree
Date: Mon, 03 Dec 2012 16:01:45 -0800
Message-ID: <20121204000146.0762D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:33859 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2LDABt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 19:01:49 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so241945lag.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 16:01:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swolchok@umich.edu, alan@linux.intel.com, axboe@kernel.dk, david@fromorbit.com


The patch titled
     Subject: sendfile: allows bypassing of notifier events
has been added to the -mm tree.  Its filename is
     sendfile-allows-bypassing-of-notifier-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Scott Wolchok <swolchok@umich.edu>
Subject: sendfile: allows bypassing of notifier events

do_sendfile() in fs/read_write.c does not call the fsnotify functions,
unlike its neighbors.  This manifests as a lack of inotify ACCESS events
when a file is sent using sendfile(2).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=12812

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
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
+		fsnotify_access(out.file);
 	}
 
 	inc_syscr(current);
_

Patches currently in -mm which might be from swolchok@umich.edu are

sendfile-allows-bypassing-of-notifier-events.patch

