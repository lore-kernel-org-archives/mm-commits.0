From: akpm@linux-foundation.org
Subject: + alpha-io-define-ioremap_uc.patch added to -mm tree
Date: Mon, 14 Sep 2015 13:20:07 -0700
Message-ID: <55f72bf7.Zg7im7rtx0QBBuZn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbINUUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 16:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: io: define ioremap_uc
has been added to the -mm tree.  Its filename is
     alpha-io-define-ioremap_uc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alpha-io-define-ioremap_uc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alpha-io-define-ioremap_uc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: alpha: io: define ioremap_uc

ioremap_uc was not defined and as a result while building with
allmodconfig were getting build error of: implicit declaration of function
'ioremap_uc'.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/io.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/io.h~alpha-io-define-ioremap_uc arch/alpha/include/asm/io.h
--- a/arch/alpha/include/asm/io.h~alpha-io-define-ioremap_uc
+++ a/arch/alpha/include/asm/io.h
@@ -297,7 +297,9 @@ static inline void __iomem * ioremap_noc
 					     unsigned long size)
 {
 	return ioremap(offset, size);
-} 
+}
+
+#define ioremap_uc ioremap_nocache
 
 static inline void iounmap(volatile void __iomem *addr)
 {
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

alpha-io-define-ioremap_uc.patch
alpha-lib-export-__delay.patch

