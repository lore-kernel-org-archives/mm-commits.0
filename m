From: akpm@linux-foundation.org
Subject: [merged] asiliantfb-add-missing-return-statement.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:21 -0700
Message-ID: <200904221829.n3MITL30005514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbZDVSbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlada.peric@gmail.com, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     asiliantfb: add missing return statement
has been removed from the -mm tree.  Its filename was
     asiliantfb-add-missing-return-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asiliantfb: add missing return statement
From: Vlada Peric <vlada.peric@gmail.com>

Commit 032220ba (asiliantfb: fix cmap memory leaks) changed the function
init_asiliant from void to int, resulting in the following compile warning:

drivers/video/asiliantfb.c: In function `init_asiliant':
drivers/video/asiliantfb.c:536: warning: control reaches end of
non-void function

Fix the warning by returning 0.

Signed-off-by: Vlada Peric <vlada.peric@gmail.com>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/asiliantfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/asiliantfb.c~asiliantfb-add-missing-return-statement drivers/video/asiliantfb.c
--- a/drivers/video/asiliantfb.c~asiliantfb-add-missing-return-statement
+++ a/drivers/video/asiliantfb.c
@@ -533,6 +533,7 @@ static int __devinit init_asiliant(struc
 
 	writeb(0xff, mmio_base + 0x78c);
 	chips_hw_init(p);
+	return 0;
 }
 
 static int __devinit
_

Patches currently in -mm which might be from vlada.peric@gmail.com are


