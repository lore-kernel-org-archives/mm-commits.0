From: akpm@linux-foundation.org
Subject: +
 fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch added to
 -mm tree
Date: Fri, 29 Jul 2016 16:12:53 -0700
Message-ID: <579be2f5.NIiP1I7hemKoJUFM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbcG2XMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 19:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Valdis.Kletnieks@vt.edu, valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/radix-tree/linux/gfp.h: fix bitrotted value
has been added to the -mm tree.  Its filename is
     fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: tools/testing/radix-tree/linux/gfp.h: fix bitrotted value

Apparently, the tools/testing version dates to a few flags ago, and we've
sprouted 4 new ones since.  Keep in sync with the value in the main
tree...

Link: http://lkml.kernel.org/r/23400.1469702675@turing-police.cc.vt.edu
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/linux/gfp.h~fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph tools/testing/radix-tree/linux/gfp.h
--- a/tools/testing/radix-tree/linux/gfp.h~fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph
+++ a/tools/testing/radix-tree/linux/gfp.h
@@ -1,7 +1,7 @@
 #ifndef _GFP_H
 #define _GFP_H
 
-#define __GFP_BITS_SHIFT 22
+#define __GFP_BITS_SHIFT 26
 #define __GFP_BITS_MASK ((gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 #define __GFP_WAIT 1
 #define __GFP_ACCOUNT 0
_

Patches currently in -mm which might be from Valdis.Kletnieks@vt.edu are

fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch
init-kconfig-add-clarification-for-out-of-tree-modules.patch

