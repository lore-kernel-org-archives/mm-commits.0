From: akpm@linux-foundation.org
Subject: +
 fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range.patch added
 to -mm tree
Date: Thu, 27 Jul 2017 16:45:10 -0700
Message-ID: <597a7b06.ExI24j38du1SWWZs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdG0XpL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/sync.c: remove unnecessary NULL f_mapping check in sync_file_range
has been added to the -mm tree.  Its filename is
     fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: fs/sync.c: remove unnecessary NULL f_mapping check in sync_file_range

fsync codepath assumes that f_mapping can never be NULL, but
sync_file_range has a check for that.  Remove the one from sync_file_range
as I don't see how you'd ever get a NULL pointer in here.

Link: http://lkml.kernel.org/r/20170525110509.9434-1-jlayton@redhat.com
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/sync.c~fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range fs/sync.c
--- a/fs/sync.c~fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range
+++ a/fs/sync.c
@@ -335,11 +335,6 @@ SYSCALL_DEFINE4(sync_file_range, int, fd
 		goto out_put;
 
 	mapping = f.file->f_mapping;
-	if (!mapping) {
-		ret = -EINVAL;
-		goto out_put;
-	}
