From: akpm@linux-foundation.org
Subject: [wrecked] fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch removed from -mm tree
Date: Mon, 08 Apr 2013 11:55:11 -0700
Message-ID: <20130408185511.AA2A65A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:41664 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab3DHSzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 14:55:13 -0400
Received: by mail-oa0-f73.google.com with SMTP id o6so1544821oag.4
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 11:55:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dchinner@redhat.com, jlbec@evilplan.org, marco.stornelli@gmail.com, mfasheh@suse.com, nikola.ciprich@linuxbox.cz, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fix hang with BSD accounting on frozen filesystem
has been removed from the -mm tree.  Its filename was
     fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs: fix hang with BSD accounting on frozen filesystem

When BSD process accounting is enabled and logs information to a
filesystem which gets frozen, system easily becomes unusable because each
attempt to account process information blocks.  Thus e.g.  every task gets
blocked in exit.

It seems better to drop accounting information (which can already happen
when filesystem is running out of space) instead of locking system up.  So
we open the accounting file with O_NONBLOCK.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~fs-fix-hang-with-bsd-accounting-on-frozen-filesystem kernel/acct.c
--- a/kernel/acct.c~fs-fix-hang-with-bsd-accounting-on-frozen-filesystem
+++ a/kernel/acct.c
@@ -201,7 +201,8 @@ static int acct_on(struct filename *path
 	struct bsd_acct_struct *acct = NULL;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = file_open_name(pathname, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = file_open_name(pathname,
+			      O_WRONLY|O_APPEND|O_LARGEFILE|O_NONBLOCK, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
direct-io-fix-boundary-block-handling.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch

