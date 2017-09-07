From: akpm@linux-foundation.org
Subject: [merged]
 fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:40:37 -0700
Message-ID: <20170907184037.-ipFFgGna%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752538AbdIGSki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/sync.c: remove unnecessary NULL f_mapping check in sync_file_range
has been removed from the -mm tree.  Its filename was
     fs-remove-unnecessary-null-f_mapping-check-in-sync_file_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
