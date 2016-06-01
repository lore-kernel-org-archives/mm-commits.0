From: akpm@linux-foundation.org
Subject: + fs-befs-move-useless-assignment.patch added to -mm tree
Date: Wed, 01 Jun 2016 16:42:33 -0700
Message-ID: <574f72e9.swO8Lg6+WVsBTHen%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbcFAXme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 19:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: move useless assignment
has been added to the -mm tree.  Its filename is
     fs-befs-move-useless-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-move-useless-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-move-useless-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c: move useless assignment

Control is transfered to unacquire_none when sb->s_fs_info is equal to
NULL, so the assignment to NULL is useless and it is moved above
unacquire_none.

Link: http://lkml.kernel.org/r/ed41da113fc693c7daa4e8813ca04cc766ddfc05.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-move-useless-assignment fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-move-useless-assignment
+++ a/fs/befs/linuxvfs.c
@@ -870,9 +870,9 @@ befs_fill_super(struct super_block *sb,
       unacquire_priv_sbp:
 	kfree(befs_sb->mount_opts.iocharset);
 	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
 
       unacquire_none:
-	sb->s_fs_info = NULL;
 	return ret;
 }
 
_

Patches currently in -mm which might be from salah.triki@acm.org are

fs-befs-move-useless-assignment.patch
fs-befs-check-silent-flag-before-logging-errors.patch
fs-befs-remove-useless-pr_err.patch
fs-befs-remove-useless-befs_error.patch
fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch

