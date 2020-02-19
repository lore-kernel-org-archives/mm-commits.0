From: akpm@linux-foundation.org
Subject: + init-mainc-mark-boot_config_checksum-static.patch added
 to -mm tree
Date: Wed, 19 Feb 2020 14:56:30 -0800
Message-ID: <20200219225630.HI0kQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgBSW4c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 17:56:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhiramat@kernel.org, hqjagain@gmail.com


The patch titled
     Subject: init/main.c: mark boot_config_checksum static
has been added to the -mm tree.  Its filename is
     init-mainc-mark-boot_config_checksum-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-mark-boot_config_checksum-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-mark-boot_config_checksum-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: init/main.c: mark boot_config_checksum static

In fact, this function is only used in this file, so mark it with 'static'.

Link: http://lkml.kernel.org/r/1581852511-14163-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-mark-boot_config_checksum-static
+++ a/init/main.c
@@ -335,7 +335,7 @@ static char * __init xbc_make_cmdline(co
 	return new_cmdline;
 }
 
-u32 boot_config_checksum(unsigned char *p, u32 size)
+static u32 boot_config_checksum(unsigned char *p, u32 size)
 {
 	u32 ret = 0;
 
_

Patches currently in -mm which might be from hqjagain@gmail.com are

init-mainc-mark-boot_config_checksum-static.patch
