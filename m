From: akpm@linux-foundation.org
Subject: - git-block-unregister_chrdev-ignore-the-return-value.patch removed from -mm tree
Date: Tue, 17 Jul 2007 15:43:06 -0700
Message-ID: <200707172243.l6HMh6x7010683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418AbXGQWnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 18:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     unregister_chrdev(): ignore the return value
has been removed from the -mm tree.  Its filename was
     git-block-unregister_chrdev-ignore-the-return-value.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: unregister_chrdev(): ignore the return value

diff -puN drivers/block/acsi_slm.c~unregister_chrdev-ignore-the-return-value drivers/block/acsi_slm.c
--- a/drivers/block/acsi_slm.c~unregister_chrdev-ignore-the-return-value
+++ a/drivers/block/acsi_slm.c
@@ -1025,8 +1025,7 @@ int init_module(void)
 
 void cleanup_module(void)
 {
-	if (unregister_chrdev( ACSI_MAJOR, "slm" ) != 0)
-		printk( KERN_ERR "acsi_slm: cleanup_module failed\n");
+	unregister_chrdev(ACSI_MAJOR, "slm");
 	atari_stram_free( SLMBuffer );
 }
 #endif


Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
unregister_chrdev-ignore-the-return-value.patch
git-block-unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
