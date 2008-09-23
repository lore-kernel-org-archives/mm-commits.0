From: akpm@linux-foundation.org
Subject: - net-fix-compilation-ng-when-config_module.patch removed from -mm tree
Date: Mon, 22 Sep 2008 21:12:22 -0700
Message-ID: <200809230412.m8N4CMn7014229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbYIWEM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 00:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     net: fix compilation NG when !CONFIG_MODULE
has been removed from the -mm tree.  Its filename was
     net-fix-compilation-ng-when-config_module.patch

This patch was dropped because it is obsolete

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
@@ -997,7 +997,7 @@ EXPORT_SYMBOL(netdev_bonding_change);
  *	privileges this function loads the module. If module loading is not
  *	available in this kernel then it becomes a nop.
  */
