From: akpm@linux-foundation.org
Subject: + pipe-remove-bogus-check-from-set-size-fcntl.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:00:46 -0700
Message-ID: <201006092100.o59L0kmP021306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758292Ab0FIVAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     pipe: remove bogus check from "set size" fcntl
has been added to the -mm tree.  Its filename is
     pipe-remove-bogus-check-from-set-size-fcntl.patch

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
Subject: pipe: remove bogus check from "set size" fcntl
From: Miklos Szeredi <mszeredi@suse.cz>

As it stands this check compares the number of pages to the page size.
This makes no sense and makes the fcntl fail in almost any sane case.

Fix it by checking if nr_pages is not zero (it can become zero only if
arg is too big and round_pipe_size() overflows).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/pipe.c~pipe-remove-bogus-check-from-set-size-fcntl fs/pipe.c
--- a/fs/pipe.c~pipe-remove-bogus-check-from-set-size-fcntl
+++ a/fs/pipe.c
@@ -1215,12 +1215,13 @@ long pipe_fcntl(struct file *file, unsig
 		size = round_pipe_size(arg);
 		nr_pages = size >> PAGE_SHIFT;
 
+		ret = -EINVAL;
+		if (!nr_pages)
+			goto out;
+
 		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
 			ret = -EPERM;
 			goto out;
-		} else if (nr_pages < PAGE_SIZE) {
-			ret = -EINVAL;
-			goto out;
 		}
 		ret = pipe_set_size(pipe, nr_pages);
 		break;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

pipe-fix-pipe-buffer-resizing.patch
pipe-remove-bogus-check-from-set-size-fcntl.patch

