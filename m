From: akpm@linux-foundation.org
Subject: - uml-fix-initrd-printk.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:43:58 -0800
Message-ID: <200802250043.m1P0hwNp006039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbYBYAoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johfel@users.sourceforge.net, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix initrd printk
has been removed from the -mm tree.  Its filename was
     uml-fix-initrd-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix initrd printk
From: Johann Felix Soden <johfel@users.sourceforge.net>

If the initrd file has zero-length, the error message should contain
the filepath.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/initrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/initrd.c~uml-fix-initrd-printk arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-fix-initrd-printk
+++ a/arch/um/kernel/initrd.c
@@ -32,7 +32,7 @@ static int __init read_initrd(void)
 	 * ask for no memory.
 	 */
 	if (size == 0) {
-		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		printk(KERN_ERR "\"%s\" is a zero-size initrd\n", initrd);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are
