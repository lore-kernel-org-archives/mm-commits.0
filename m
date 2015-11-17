From: akpm@linux-foundation.org
Subject: + fat-fix-fake_offset-handling-on-error-path.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 15:45:02 -0800
Message-ID: <564bbbfe.vo9lEZ5BxVfMDs1N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbbKQXpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, richard.weinberger@gmail.com, stable@vger.kernel.org, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix fake_offset handling on error path
has been added to the -mm tree.  Its filename is
     fat-fix-fake_offset-handling-on-error-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-fake_offset-handling-on-error-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-fake_offset-handling-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix fake_offset handling on error path

For the root directory, .  and ..  are faked (using dir_emit_dots()) and
ctx->pos is reset from 2 to 0.

A corrupted root directory could cause fat_get_entry() to fail, but
->iterate() (fat_readdir()) reports progress to the VFS (with ctx->pos
rewound to 0), so any following calls to ->iterate() continue to return
the same entries again and again.

The result is that userspace will never see the end of the directory,
causing e.g.  'ls' to hang in a getdents() loop.

[hirofumi@mail.parknet.co.jp: cleanup and make sure to correct fake_offset]
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Richard Weinberger <richard.weinberger@gmail.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/fat/dir.c~fat-fix-fake_offset-handling-on-error-path fs/fat/dir.c
--- a/fs/fat/dir.c~fat-fix-fake_offset-handling-on-error-path
+++ a/fs/fat/dir.c
@@ -610,9 +610,9 @@ parse_record:
 		int status = fat_parse_long(inode, &cpos, &bh, &de,
 					    &unicode, &nr_slots);
 		if (status < 0) {
-			ctx->pos = cpos;
+			bh = NULL;
 			ret = status;
-			goto out;
+			goto end_of_dir;
 		} else if (status == PARSE_INVALID)
 			goto record_end;
 		else if (status == PARSE_NOT_LONGNAME)
@@ -654,8 +654,9 @@ parse_record:
 	fill_len = short_len;
 
 start_filldir:
-	if (!fake_offset)
-		ctx->pos = cpos - (nr_slots + 1) * sizeof(struct msdos_dir_entry);
+	ctx->pos = cpos - (nr_slots + 1) * sizeof(struct msdos_dir_entry);
+	if (fake_offset && ctx->pos < 2)
+		ctx->pos = 2;
 
 	if (!memcmp(de->name, MSDOS_DOT, MSDOS_NAME)) {
 		if (!dir_emit_dot(file, ctx))
@@ -681,14 +682,19 @@ record_end:
 	fake_offset = 0;
 	ctx->pos = cpos;
 	goto get_new;
+
 end_of_dir:
-	ctx->pos = cpos;
+	if (fake_offset && cpos < 2)
+		ctx->pos = 2;
+	else
+		ctx->pos = cpos;
 fill_failed:
 	brelse(bh);
 	if (unicode)
 		__putname(unicode);
 out:
 	mutex_unlock(&sbi->s_lock);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-fake_offset-handling-on-error-path.patch

