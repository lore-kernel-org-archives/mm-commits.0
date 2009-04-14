From: akpm@linux-foundation.org
Subject: + asiliantfb-add-missing-return-statement.patch added to -mm tree
Date: Tue, 14 Apr 2009 15:57:06 -0700
Message-ID: <200904142257.n3EMv6bl010283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbZDNW7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 18:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vlada.peric@gmail.com, dilinger@debian.org


The patch titled
     asiliantfb: add missing return statement
has been added to the -mm tree.  Its filename is
     asiliantfb-add-missing-return-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

asiliantfb-add-missing-return-statement.patch

