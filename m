From: akpm@linux-foundation.org
Subject: [patch 085/119] fs/sync.c: remove unnecessary NULL
 f_mapping check in sync_file_range
Date: Wed, 06 Sep 2017 16:23:19 -0700
Message-ID: <20170906232319.WCPAcNxvc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbdIFXXU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlayton@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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
