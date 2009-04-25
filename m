From: akpm@linux-foundation.org
Subject: + 8390p-fix-build-breakage.patch added to -mm tree
Date: Fri, 24 Apr 2009 18:20:25 -0700
Message-ID: <200904250120.n3P1KPO7000316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbZDYBVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 21:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com


The patch titled
     8390p: fix build breakage
has been added to the -mm tree.  Its filename is
     8390p-fix-build-breakage.patch

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
Subject: 8390p: fix build breakage
From: Alexander Beregalov <a.beregalov@gmail.com>

Fix this build error caused by 362b76edb789
"8390p: Get rid of init_module/cleanup_module"

drivers/net/8390p.c:94:19: error: invalid suffix "p_init_module" on integer constant
drivers/net/8390p.c:94: error: expected identifier or '(' before numeric constant
drivers/net/8390p.c:99:20: error: invalid suffix "p_cleanup_module" on integer constant

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/8390p.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/8390p.c~8390p-fix-build-breakage drivers/net/8390p.c
--- a/drivers/net/8390p.c~8390p-fix-build-breakage
+++ a/drivers/net/8390p.c
@@ -91,15 +91,15 @@ void NS8390p_init(struct net_device *dev
 }
 EXPORT_SYMBOL(NS8390p_init);
 
-static int __init 8390p_init_module(void)
+static int __init NS8390p_init_module(void)
 {
 	return 0;
 }
 
-static void __exit 8390p_cleanup_module(void)
+static void __exit NS8390p_cleanup_module(void)
 {
 }
 
-module_init(8390p_init_module);
-module_exit(8390p_cleanup_module);
+module_init(NS8390p_init_module);
+module_exit(NS8390p_cleanup_module);
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch
8390p-fix-build-breakage.patch

