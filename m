From: akpm@linux-foundation.org
Subject: - net-trivial-mlx4_debug-dependency-fix.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:06 -0700
Message-ID: <200705120516.l4C5G6sY001803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491AbXELFQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, jeff@garzik.org, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     net: trivial MLX4_DEBUG dependency fix
has been removed from the -mm tree.  Its filename was
     net-trivial-mlx4_debug-dependency-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-infiniband.patch
git-sh.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
slab-allocators-drop-support-for-destructors.patch
