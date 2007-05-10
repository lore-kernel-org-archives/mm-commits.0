From: akpm@linux-foundation.org
Subject: + net-trivial-mlx4_debug-dependency-fix.patch added to -mm tree
Date: Wed, 09 May 2007 22:19:58 -0700
Message-ID: <200705100519.l4A5JwEj012873@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbXEJFUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, jeff@garzik.org, rolandd@cisco.com


The patch titled
     net: trivial MLX4_DEBUG dependency fix
has been added to the -mm tree.  Its filename is
     net-trivial-mlx4_debug-dependency-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: trivial MLX4_DEBUG dependency fix
From: Paul Mundt <lethal@linux-sh.org>

CONFIG_MLX4_DEBUG works out to a def_bool y for those that
have CONFIG_EMBEDDED set. Make it depend on MLX4_CORE..

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~net-trivial-mlx4_debug-dependency-fix drivers/net/Kconfig
--- a/drivers/net/Kconfig~net-trivial-mlx4_debug-dependency-fix
+++ a/drivers/net/Kconfig
@@ -2544,6 +2544,7 @@ config MLX4_CORE
 
 config MLX4_DEBUG
 	bool "Verbose debugging output" if (MLX4_CORE && EMBEDDED)
+	depends on MLX4_CORE
 	default y
 	---help---
 	  This option causes debugging code to be compiled into the
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
net-trivial-mlx4_debug-dependency-fix.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
introduce-freezer-flags-rev-2.patch
