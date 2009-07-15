From: akpm@linux-foundation.org
Subject: + edac-x83-fix-mchbar-high-register-addr.patch added to -mm tree
Date: Wed, 15 Jul 2009 12:53:10 -0700
Message-ID: <200907151953.n6FJrAFM021193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731AbZGOTxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 15:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tombowfly@gmail.com, dougthompson@xmission.com


The patch titled
     edac: x83 fix mchbar high register addr
has been added to the -mm tree.  Its filename is
     edac-x83-fix-mchbar-high-register-addr.patch

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
Subject: edac: x83 fix mchbar high register addr
From: Lu Zhihe <tombowfly@gmail.com>

Intel X38 MCHBAR is a 64bits register, base from 0x48, so its higher base
is 0x4C.

Signed-off-by: Lu Zhihe <tombowfly@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/x38_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/x38_edac.c~edac-x83-fix-mchbar-high-register-addr drivers/edac/x38_edac.c
--- a/drivers/edac/x38_edac.c~edac-x83-fix-mchbar-high-register-addr
+++ a/drivers/edac/x38_edac.c
@@ -30,7 +30,7 @@
 /* Intel X38 register addresses - device 0 function 0 - DRAM Controller */
 
 #define X38_MCHBAR_LOW	0x48	/* MCH Memory Mapped Register BAR */
-#define X38_MCHBAR_HIGH	0x4b
+#define X38_MCHBAR_HIGH	0x4c
 #define X38_MCHBAR_MASK	0xfffffc000ULL	/* bits 35:14 */
 #define X38_MMR_WINDOW_SIZE	16384
 
_

Patches currently in -mm which might be from tombowfly@gmail.com are

edac-x83-fix-mchbar-high-register-addr.patch

