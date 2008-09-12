From: akpm@linux-foundation.org
Subject: + ia64-fix-panic-during-modprobe-r-xpc.patch added to -mm tree
Date: Fri, 12 Sep 2008 12:52:04 -0700
Message-ID: <200809121952.m8CJq4gd000963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbYILTwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 15:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, tony.luck@intel.com


The patch titled
     ia64: fix panic during `modprobe -r xpc'
has been added to the -mm tree.  Its filename is
     ia64-fix-panic-during-modprobe-r-xpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

ia64-fix-panic-during-modprobe-r-xpc.patch

