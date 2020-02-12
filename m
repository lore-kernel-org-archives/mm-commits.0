From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 init-cleanup-anon_inodes-and-old-io-schedulers-options.patch added to -mm
 tree
Date: Wed, 12 Feb 2020 15:05:24 -0800
Message-ID: <20200212230524.WsEOdRNcd%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgBLXF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 18:05:26 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, krzk@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de, yamada.masahiro@socionext.com


The patch titled
     Subject: init/Kconfig: clean up ANON_INODES and old IO schedulers options
has been added to the -mm tree.  Its filename is
     init-cleanup-anon_inodes-and-old-io-schedulers-options.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-cleanup-anon_inodes-and-old-io-schedulers-options.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-cleanup-anon_inodes-and-old-io-schedulers-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: init/Kconfig: clean up ANON_INODES and old IO schedulers options

CONFIG_ANON_INODES is gone since commit 5dd50aaeb185 ("Make anon_inodes
unconditional").

CONFIG_CFQ_GROUP_IOSCHED was replaced with CONFIG_BFQ_GROUP_IOSCHED in
commit f382fb0bcef4 ("block: remove legacy IO schedulers").

Link: http://lkml.kernel.org/r/20200130192419.3026-1-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/init/Kconfig~init-cleanup-anon_inodes-and-old-io-schedulers-options
+++ a/init/Kconfig
@@ -870,7 +870,7 @@ config BLK_CGROUP
 	This option only enables generic Block IO controller infrastructure.
 	One needs to also enable actual IO controlling logic/policy. For
 	enabling proportional weight division of disk bandwidth in CFQ, set
-	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
+	CONFIG_BFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
 	CONFIG_BLK_DEV_THROTTLING=y.
 
 	See Documentation/admin-guide/cgroup-v1/blkio-controller.rst for more information.
@@ -1536,7 +1536,6 @@ config AIO
 
 config IO_URING
 	bool "Enable IO uring support" if EXPERT
-	select ANON_INODES
 	select IO_WQ
 	default y
 	help
_

Patches currently in -mm which might be from krzk@kernel.org are

init-cleanup-anon_inodes-and-old-io-schedulers-options.patch
