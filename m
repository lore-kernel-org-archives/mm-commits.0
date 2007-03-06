From: akpm@linux-foundation.org
Subject: + geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:29:53 -0800
Message-ID: <200703060429.l264Tri7011827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbXCFE34 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:29:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     geode-aes: use unsigned long for spin_lock_irqsave
has been added to the -mm tree.  Its filename is
     geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: geode-aes: use unsigned long for spin_lock_irqsave
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/geode-aes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/crypto/geode-aes.c~geode-aes-use-unsigned-long-for-spin_lock_irqsave drivers/crypto/geode-aes.c
--- a/drivers/crypto/geode-aes.c~geode-aes-use-unsigned-long-for-spin_lock_irqsave
+++ a/drivers/crypto/geode-aes.c
@@ -99,9 +99,8 @@ do_crypt(void *src, void *dst, int len, 
 static unsigned int
 geode_aes_crypt(struct geode_aes_op *op)
 {
-
 	u32 flags = 0;
-	int iflags;
+	unsigned long iflags;
 
 	if (op->len == 0 || op->src == op->dst)
 		return 0;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch
git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
x86_64-shut-up-vm862.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
