From: akpm@linux-foundation.org
Subject: - ia64-fix-panic-during-modprobe-r-xpc.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:13 -0700
Message-ID: <200809182056.m8IKuDVr019177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbYIRU4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix panic during `modprobe -r xpc'
has been removed from the -mm tree.  Its filename was
     ia64-fix-panic-during-modprobe-r-xpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix panic during `modprobe -r xpc'
From: Robin Holt <holt@sgi.com>

If you are on ia64 and you modprobe xpc then modprobe -r xpc, you
immediately get a panic.  xpc depends on xp which depends on gru for a
symbol.  That symbol is only used when we are running on UV hardware.

Currently, the GRU driver detects we are not on UV hardware and does no
initializing.  It does not do the same check when unloading.  As a result,
the gru driver attempts to tear down stuff that was not setup.

This is a simple two-line workaround to get us through this release.  Once
2.6.28 is opened, we need to rework the symbols that xp is depending on
from gru so the gru driver can properly fail to load when hardware is not
available.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/misc/sgi-gru/grufile.c~ia64-fix-panic-during-modprobe-r-xpc drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~ia64-fix-panic-during-modprobe-r-xpc
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -445,6 +445,9 @@ static void __exit gru_exit(void)
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
+	if (!IS_UV())
+		return;
+
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
 		free_irq(IRQ_GRU + i, NULL);
 
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

