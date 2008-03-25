From: akpm@linux-foundation.org
Subject: - drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:21 -0700
Message-ID: <200803250019.m2P0JL22032677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYCYAT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/arcnet/com20020.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/arcnet/com20020.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replaced init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arcnet/com20020.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/arcnet/com20020.c~drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/arcnet/com20020.c
--- a/drivers/net/arcnet/com20020.c~drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/arcnet/com20020.c
@@ -348,14 +348,15 @@ MODULE_LICENSE("GPL");
 
 #ifdef MODULE
 
-int init_module(void)
+static int __init com20020_module_init(void)
 {
 	BUGLVL(D_NORMAL) printk(VERSION);
 	return 0;
 }
 
-void cleanup_module(void)
+static void __exit com20020_module_exit(void)
 {
 }
