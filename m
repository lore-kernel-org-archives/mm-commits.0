From: akpm@linux-foundation.org
Subject: + alpha-fix-macros.patch added to -mm tree
Date: Fri, 30 Jan 2009 11:28:03 -0800
Message-ID: <200901301928.n0UJS3Ex011856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZA3T2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:28:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: fix macros
has been added to the -mm tree.  Its filename is
     alpha-fix-macros.patch

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
Subject: alpha: fix macros
From: Roel Kluin <roel.kluin@gmail.com>

When this macros isn't called with 'fixup', e.g.  with foo this will
incorectly expand to foo->foo.bits.errreg

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/uaccess.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/alpha/include/asm/uaccess.h~alpha-fix-macros arch/alpha/include/asm/uaccess.h
--- a/arch/alpha/include/asm/uaccess.h~alpha-fix-macros
+++ a/arch/alpha/include/asm/uaccess.h
@@ -498,13 +498,13 @@ struct exception_table_entry
 };
 
 /* Returns the new pc */
-#define fixup_exception(map_reg, fixup, pc)			\
+#define fixup_exception(map_reg, _fixup, pc)			\
 ({								\
-	if ((fixup)->fixup.bits.valreg != 31)			\
-		map_reg((fixup)->fixup.bits.valreg) = 0;	\
-	if ((fixup)->fixup.bits.errreg != 31)			\
-		map_reg((fixup)->fixup.bits.errreg) = -EFAULT;	\
-	(pc) + (fixup)->fixup.bits.nextinsn;			\
+	if ((_fixup)->fixup.bits.valreg != 31)			\
+		map_reg((_fixup)->fixup.bits.valreg) = 0;	\
+	if ((_fixup)->fixup.bits.errreg != 31)			\
+		map_reg((_fixup)->fixup.bits.errreg) = -EFAULT;	\
+	(pc) + (_fixup)->fixup.bits.nextinsn;			\
 })
 
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
ufs-sector_t-cannot-be-negative.patch

