From: akpm@linux-foundation.org
Subject: + kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:48:45 -0700
Message-ID: <201106292248.p5TMmjKZ017002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340Ab1F2Wsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bebarino@gmail.com, rdunlap@xenotime.net, xiyou.wangcong@gmail.com


The patch titled
     kernel/configs.c: include MODULE_*() when CONFIG_IKCONFIG_PROC=n
has been added to the -mm tree.  Its filename is
     kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch

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
