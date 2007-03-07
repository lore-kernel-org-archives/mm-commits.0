From: akpm@linux-foundation.org
Subject: - geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:29 -0800
Message-ID: <200703070421.l274LTR2018903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161310AbXCGEVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     geode-aes: use unsigned long for spin_lock_irqsave
has been removed from the -mm tree.  Its filename was
     geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
x86_64-shut-up-vm862.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
