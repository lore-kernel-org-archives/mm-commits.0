From: akpm@linux-foundation.org
Subject: - jffs2-add-write-verify-on-dataflash.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:16 -0700
Message-ID: <200804261641.m3QGfGP7031112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798AbYDZQl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trimarchi@gandalf.sssup.it, dwmw2@infradead.org, trimarchimichael@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     jffs2: add write verify on dataflash.
has been removed from the -mm tree.  Its filename was
     jffs2-add-write-verify-on-dataflash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: add write verify on dataflash.
From: michael <trimarchi@gandalf.sssup.it>

Add the write verification buffer to the dataflash.  The mtd_dataflash has
the CONFIG_DATAFLASH_WRITE_VERIFY so is better a change to Kconfig.

Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/wbuf.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/jffs2/wbuf.c~jffs2-add-write-verify-on-dataflash fs/jffs2/wbuf.c
--- a/fs/jffs2/wbuf.c~jffs2-add-write-verify-on-dataflash
+++ a/fs/jffs2/wbuf.c
@@ -1236,12 +1236,24 @@ int jffs2_dataflash_setup(struct jffs2_s
 	if (!c->wbuf)
 		return -ENOMEM;
 
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+	c->wbuf_verify = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
+	if (!c->wbuf_verify) {
+		kfree(c->oobbuf);
+		kfree(c->wbuf);
+		return -ENOMEM;
+	}
+#endif
+
 	printk(KERN_INFO "JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n", c->wbuf_pagesize, c->sector_size);
 
 	return 0;
 }
 
 void jffs2_dataflash_cleanup(struct jffs2_sb_info *c) {
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+	kfree(c->wbuf_verify);
+#endif
 	kfree(c->wbuf);
 }
 
_

Patches currently in -mm which might be from trimarchi@gandalf.sssup.it are

origin.patch

