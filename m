From: akpm@linux-foundation.org
Subject: [merged]
 init-cleanup-anon_inodes-and-old-io-schedulers-options.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 19:02:19 -0700
Message-ID: <20200408020219.XehE2lxNI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCCV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, krzk@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de, yamada.masahiro@socionext.com


The patch titled
     Subject: init/Kconfig: clean up ANON_INODES and old IO schedulers options
has been removed from the -mm tree.  Its filename was
     init-cleanup-anon_inodes-and-old-io-schedulers-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -872,7 +872,7 @@ config BLK_CGROUP
 	This option only enables generic Block IO controller infrastructure.
 	One needs to also enable actual IO controlling logic/policy. For
 	enabling proportional weight division of disk bandwidth in CFQ, set
-	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
+	CONFIG_BFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
 	CONFIG_BLK_DEV_THROTTLING=y.
 
 	See Documentation/admin-guide/cgroup-v1/blkio-controller.rst for more information.
@@ -1538,7 +1538,6 @@ config AIO
 
 config IO_URING
 	bool "Enable IO uring support" if EXPERT
-	select ANON_INODES
 	select IO_WQ
 	default y
 	help
_

Patches currently in -mm which might be from krzk@kernel.org are
