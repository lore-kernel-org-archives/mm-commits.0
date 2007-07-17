From: akpm@linux-foundation.org
Subject: - use-data_data-in-xtensa.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:33 -0700
Message-ID: <200707172309.l6HN9XAO012377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935715AbXGQXPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: use DATA_DATA
has been removed from the -mm tree.  Its filename was
     use-data_data-in-xtensa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xtensa: use DATA_DATA
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/vmlinux.lds.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/xtensa/kernel/vmlinux.lds.S~use-data_data-in-xtensa arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~use-data_data-in-xtensa
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -118,7 +118,8 @@ SECTIONS
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    DATA_DATA
+    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-kbuild.patch
