From: akpm@linux-foundation.org
Subject: + defxx-fix-the-handling-of-ioremap-failures.patch added to -mm tree
Date: Wed, 30 May 2007 01:21:04 -0700
Message-ID: <200705300821.l4U8L3M5022430@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXE3IVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 04:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org


The patch titled
     defxx: fix the handling of ioremap() failures
has been added to the -mm tree.  Its filename is
     defxx-fix-the-handling-of-ioremap-failures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: defxx: fix the handling of ioremap() failures
From: "Maciej W. Rozycki" <macro@linux-mips.org>

If ioremap_nocache() is unfortunate enough to fail, the error code is not
set correctly leading to a false success from dfx_register().  This change
fixes the problem.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/defxx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/defxx.c~defxx-fix-the-handling-of-ioremap-failures drivers/net/defxx.c
--- a/drivers/net/defxx.c~defxx-fix-the-handling-of-ioremap-failures
+++ a/drivers/net/defxx.c
@@ -566,6 +566,7 @@ static int __devinit dfx_register(struct
 		bp->base.mem = ioremap_nocache(bar_start, bar_len);
 		if (!bp->base.mem) {
 			printk(KERN_ERR "%s: Cannot map MMIO\n", print_name);
+			err = -ENOMEM;
 			goto err_out_region;
 		}
 	} else {
_

Patches currently in -mm which might be from macro@linux-mips.org are

defxx-fix-the-handling-of-ioremap-failures.patch
zs-move-to-the-serial-subsystem.patch
