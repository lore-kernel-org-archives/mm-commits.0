From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 150/166] init/Kconfig: clean up ANON_INODES and
 old IO schedulers options
Date: Mon, 06 Apr 2020 20:12:02 -0700
Message-ID: <20200407031202.TLn7gHfM5%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDMG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:06 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, krzk@kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

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
