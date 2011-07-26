From: akpm@linux-foundation.org
Subject: [merged] kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:35 -0700
Message-ID: <201107260754.p6Q7scSg003370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832Ab1GZHzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bebarino@gmail.com, rdunlap@xenotime.net, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/configs.c: include MODULE_*() when CONFIG_IKCONFIG_PROC=n
has been removed from the -mm tree.  Its filename was
     kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/configs.c: include MODULE_*() when CONFIG_IKCONFIG_PROC=n
From: Stephen Boyd <bebarino@gmail.com>

If CONFIG_IKCONFIG=m but CONFIG_IKCONFIG_PROC=n we get a module that has
no MODULE_LICENSE definition.  Move the MODULE_*() definitions outside the
CONFIG_IKCONFIG_PROC #ifdef to prevent this configuration from tainting
the kernel.

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/configs.c~kernel-configsc-include-module_-when-config_ikconfig_proc=n kernel/configs.c
--- a/kernel/configs.c~kernel-configsc-include-module_-when-config_ikconfig_proc=n
+++ a/kernel/configs.c
@@ -92,8 +92,8 @@ static void __exit ikconfig_cleanup(void
 module_init(ikconfig_init);
 module_exit(ikconfig_cleanup);
 
+#endif /* CONFIG_IKCONFIG_PROC */
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Randy Dunlap");
 MODULE_DESCRIPTION("Echo the kernel .config file used to build the kernel");
