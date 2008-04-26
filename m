From: akpm@linux-foundation.org
Subject: - jffs2-check-if-partition-is-marked-ro-on-mount.patch removed from -mm tree
Date: Sat, 26 Apr 2008 07:14:54 -0700
Message-ID: <200804261414.m3QEEsPm025720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbYDZOPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 10:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@tglx.de, bigeasy@linutronix.de, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: check if partition is marked RO on mount
has been removed from the -mm tree.  Its filename was
     jffs2-check-if-partition-is-marked-ro-on-mount.patch

This patch was dropped because of plot-lossage

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: check if partition is marked RO on mount
From: Sebastian Siewior <bigeasy@tglx.de>

and if it is, don't tell userspace that write is possible.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/jffs2/super.c~jffs2-check-if-partition-is-marked-ro-on-mount fs/jffs2/super.c
--- a/fs/jffs2/super.c~jffs2-check-if-partition-is-marked-ro-on-mount
+++ a/fs/jffs2/super.c
@@ -108,6 +108,9 @@ static int jffs2_fill_super(struct super
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
+	if (!(c->mtd->flags & MTD_WRITEABLE))
+		sb->s_flags |= MS_RDONLY;
+
 	return jffs2_do_fill_super(sb, data, silent);
 }
 
_

Patches currently in -mm which might be from bigeasy@tglx.de are

origin.patch
jffs2-check-if-partition-is-marked-ro-on-mount.patch

