From: akpm@linux-foundation.org
Subject: + jffs2-check-if-partition-is-marked-ro-on-remount.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:12:31 -0700
Message-ID: <200803212112.m2LLCVn3010699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761995AbYCUVNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@tglx.de, bigeasy@linutronix.de, dwmw2@infradead.org


The patch titled
     jffs2: check if partition is marked RO on remount
has been added to the -mm tree.  Its filename is
     jffs2-check-if-partition-is-marked-ro-on-remount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: check if partition is marked RO on remount
From: Sebastian Siewior <bigeasy@tglx.de>

and if it is, don't tell userspace that write is possible.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/fs.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/jffs2/fs.c~jffs2-check-if-partition-is-marked-ro-on-remount fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~jffs2-check-if-partition-is-marked-ro-on-remount
+++ a/fs/jffs2/fs.c
@@ -382,6 +382,9 @@ int jffs2_remount_fs (struct super_block
 	if (c->flags & JFFS2_SB_FLAG_RO && !(sb->s_flags & MS_RDONLY))
 		return -EROFS;
 
+	if (!(c->mtd->flags & MTD_WRITEABLE))
+		return -EROFS;
+
 	/* We stop if it was running, then restart if it needs to.
 	   This also catches the case where it was stopped and this
 	   is just a remount to restart it.
_

Patches currently in -mm which might be from bigeasy@tglx.de are

jffs2-check-if-partition-is-marked-ro-on-remount.patch
jffs2-check-if-partition-is-marked-ro-on-mount.patch

