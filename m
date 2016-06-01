From: akpm@linux-foundation.org
Subject: + fs-befs-remove-useless-befs_error.patch added to -mm tree
Date: Wed, 01 Jun 2016 16:42:39 -0700
Message-ID: <574f72ef.BGuDHPek1KpP343w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbcFAXmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 19:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: remove useless befs_error
has been added to the -mm tree.  Its filename is
     fs-befs-remove-useless-befs_error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-remove-useless-befs_error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-remove-useless-befs_error.patch

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
Subject: fs/befs/linuxvfs.c: remove useless befs_error

Remove befs_error since when kmalloc fails there is a generic out of
memory and stack dump.

Link: http://lkml.kernel.org/r/3de4d388d98bbb570462a5eb8e64623e17fb5d74.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-remove-useless-befs_error fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-remove-useless-befs_error
+++ a/fs/befs/linuxvfs.c
@@ -524,7 +524,6 @@ befs_utf2nls(struct super_block *sb, con
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		befs_error(sb, "%s cannot allocate memory", __func__);
 		*out_len = 0;
 		return -ENOMEM;
 	}
@@ -604,7 +603,6 @@ befs_nls2utf(struct super_block *sb, con
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		befs_error(sb, "%s cannot allocate memory", __func__);
 		*out_len = 0;
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from salah.triki@acm.org are

fs-befs-move-useless-assignment.patch
fs-befs-check-silent-flag-before-logging-errors.patch
fs-befs-remove-useless-pr_err.patch
fs-befs-remove-useless-befs_error.patch
fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch

