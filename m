From: akpm@linux-foundation.org
Subject: - gru-fix-for-debug-option.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:29 -0800
Message-ID: <200811202042.mAKKgT8H006950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771AbYKTUnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GRU: fix for debug option
has been removed from the -mm tree.  Its filename was
     gru-fix-for-debug-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU: fix for debug option
From: Jack Steiner <steiner@sgi.com>

Enable -D DEBUG in the GRU Makefile if CONFIG_SGI_GRU_DEBUG is selected.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/misc/sgi-gru/Makefile~gru-fix-for-debug-option drivers/misc/sgi-gru/Makefile
--- a/drivers/misc/sgi-gru/Makefile~gru-fix-for-debug-option
+++ a/drivers/misc/sgi-gru/Makefile
@@ -1,3 +1,7 @@
+ifdef CONFIG_SGI_GRU_DEBUG
+  EXTRA_CFLAGS	+= -DDEBUG
+endif
+
 obj-$(CONFIG_SGI_GRU) := gru.o
 gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
linux-next.patch

