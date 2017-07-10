From: akpm@linux-foundation.org
Subject: [patch 090/115] lib/interval_tree_test.c: allow the module
 to be compiled-in
Date: Mon, 10 Jul 2017 15:51:43 -0700
Message-ID: <20170710225143.Chuok7ugo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754641AbdGJWvp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/interval_tree_test.c: allow the module to be compiled-in

Patch series "lib/interval_tree_test: some debugging improvements".

Here are some patches that update the interval_tree_test module allowing
users to pass finer grained options to run the actual test.


This patch (of 4):

It is a tristate after all, and also serves well for quick debugging.

Link: http://lkml.kernel.org/r/20170518174936.20265-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~lib-interval_tree_test-allow-the-module-to-be-compiled-in lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-interval_tree_test-allow-the-module-to-be-compiled-in
+++ a/lib/Kconfig.debug
@@ -1594,7 +1594,7 @@ config RBTREE_TEST
 
 config INTERVAL_TREE_TEST
 	tristate "Interval tree test"
-	depends on m && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	select INTERVAL_TREE
 	help
 	  A benchmark measuring the performance of the interval tree library
_
