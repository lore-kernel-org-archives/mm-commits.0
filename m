From: akpm@linux-foundation.org
Subject: + net-fix-compilation-ng-when-config_module.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:41:13 -0700
Message-ID: <200808280341.m7S3fDIY005542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbYH1Dlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com


The patch titled
     net: fix compilation NG when !CONFIG_MODULE
has been added to the -mm tree.  Its filename is
     net-fix-compilation-ng-when-config_module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: fix compilation NG when !CONFIG_MODULE
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

  CC      net/core/dev.o
net/core/dev.c:1001: error: redefinition of 'dev_load'
include/linux/netdevice.h:1645: error: previous definition of 'dev_load' was here
make[2]: *** [net/core/dev.o] Error 1

dev_load() is not used when CONFIG_MODULE disabled.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/core/dev.c~net-fix-compilation-ng-when-config_module net/core/dev.c
--- a/net/core/dev.c~net-fix-compilation-ng-when-config_module
+++ a/net/core/dev.c
@@ -996,7 +996,7 @@ EXPORT_SYMBOL(netdev_bonding_change);
  *	privileges this function loads the module. If module loading is not
  *	available in this kernel then it becomes a nop.
  */
