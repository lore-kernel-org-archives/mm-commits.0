From: akpm@linux-foundation.org
Subject: + jffs2-add-write-verify-on-dataflash.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:56 -0800
Message-ID: <200802230730.m1N7UjMw017957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbYBWHy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trimarchi@gandalf.sssup.it, dwmw2@infradead.org, trimarchimichael@yahoo.it


The patch titled
     jffs2: add write verify on dataflash.
has been added to the -mm tree.  Its filename is
     jffs2-add-write-verify-on-dataflash.patch

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

atmel_serial-fix-interrupt-handler-return-value.patch
jffs2-add-write-verify-on-dataflash.patch
