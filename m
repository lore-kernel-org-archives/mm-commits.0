From: akpm@linux-foundation.org
Subject: - m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:53 -0700
Message-ID: <200804261640.m3QGer8J031069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbYDZQll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, sam@ravnborg.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: cleanup: drop .data.idt section in vmlinux.lds script
has been removed from the -mm tree.  Its filename was
     m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: cleanup: drop .data.idt section in vmlinux.lds script
From: Cyrill Gorcunov <gorcunov@gmail.com>

The section .data.idt is not used at all - so drop it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/vmlinux.lds.S |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/m32r/kernel/vmlinux.lds.S~m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -60,9 +60,6 @@ SECTIONS
   . = ALIGN(4096);
   __nosave_end = .;
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
