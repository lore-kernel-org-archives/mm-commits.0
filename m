From: akpm@linux-foundation.org
Subject: + lustre-dont-set-f_version-in-ll_readdir.patch added to -mm tree
Date: Thu, 07 Dec 2017 15:40:01 -0800
Message-ID: <5a29d151./XKfW9nYXxzQVUXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdLGXkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:40:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, andreas.dilger@intel.com, anton@tuxera.com, jsimmons@infradead.org, mikulas@artax.karlin.mff.cuni.cz, oleg.drokin@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lustre: don't set f_version in ll_readdir
has been added to the -mm tree.  Its filename is
     lustre-dont-set-f_version-in-ll_readdir.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lustre-dont-set-f_version-in-ll_readdir.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lustre-dont-set-f_version-in-ll_readdir.patch

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
Subject: lustre: don't set f_version in ll_readdir

f_version is only ever used by filesystem-specific code.  Generic VFS code
never uses it.

Nothing in lustre ever looks at it, so just remove this.

Link: http://lkml.kernel.org/r/20171207113206.31544-2-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/dir.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/dir.c~lustre-dont-set-f_version-in-ll_readdir drivers/staging/lustre/lustre/llite/dir.c
--- a/drivers/staging/lustre/lustre/llite/dir.c~lustre-dont-set-f_version-in-ll_readdir
+++ a/drivers/staging/lustre/lustre/llite/dir.c
@@ -369,8 +369,6 @@ static int ll_readdir(struct file *filp,
 	}
 	ctx->pos = pos;
 	ll_finish_md_op_data(op_data);
-	filp->f_version = inode->i_version;
