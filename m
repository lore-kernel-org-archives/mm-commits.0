From: akpm@linux-foundation.org
Subject: [merged] mm-trivial-simplify-flag-check.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:52:46 -0700
Message-ID: <552fe8de.mv9uVl/lBEbH/OUW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbbDPQrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: simplify flag check
has been removed from the -mm tree.  Its filename was
     mm-trivial-simplify-flag-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: include/linux/mm.h: simplify flag check

Flip the flag test so that it is the simplest.  No functional change, just
a small readability improvement:

No code changed:

  # arch/x86/kernel/sys_x86_64.o:

   text    data     bss     dec     hex filename
   1551      24       0    1575     627 sys_x86_64.o.before
   1551      24       0    1575     627 sys_x86_64.o.after

md5:
   70708d1b1ad35cc891118a69dc1a63f9  sys_x86_64.o.before.asm
   70708d1b1ad35cc891118a69dc1a63f9  sys_x86_64.o.after.asm

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-trivial-simplify-flag-check include/linux/mm.h
--- a/include/linux/mm.h~mm-trivial-simplify-flag-check
+++ a/include/linux/mm.h
@@ -1894,10 +1894,10 @@ extern unsigned long unmapped_area_topdo
 static inline unsigned long
 vm_unmapped_area(struct vm_unmapped_area_info *info)
 {
-	if (!(info->flags & VM_UNMAPPED_AREA_TOPDOWN))
-		return unmapped_area(info);
-	else
+	if (info->flags & VM_UNMAPPED_AREA_TOPDOWN)
 		return unmapped_area_topdown(info);
+	else
+		return unmapped_area(info);
 }
 
 /* truncate.c */
_

Patches currently in -mm which might be from bp@suse.de are

origin.patch
linux-next.patch

