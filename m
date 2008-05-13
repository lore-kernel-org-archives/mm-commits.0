From: akpm@linux-foundation.org
Subject: - m68knommu-missing-sections-for-linker-script.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:52 -0700
Message-ID: <200805132133.m4DLXqKt000860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758946AbYEMVeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: missing sections for linker script
has been removed from the -mm tree.  Its filename was
     m68knommu-missing-sections-for-linker-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: missing sections for linker script
From: Greg Ungerer <gerg@snapgear.com>

Include the missing kcrctab and kcrctab_unused sections into the m68knommu
linker script.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/vmlinux.lds.S |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/m68knommu/kernel/vmlinux.lds.S~m68knommu-missing-sections-for-linker-script arch/m68knommu/kernel/vmlinux.lds.S
--- a/arch/m68knommu/kernel/vmlinux.lds.S~m68knommu-missing-sections-for-linker-script
+++ a/arch/m68knommu/kernel/vmlinux.lds.S
@@ -114,6 +114,16 @@ SECTIONS {
 		*(__kcrctab_gpl)
 		__stop___kcrctab_gpl = .;
 
+		/* Kernel symbol table: Normal unused symbols */
+		__start___kcrctab_unused = .;
+		*(__kcrctab_unused)
+		__stop___kcrctab_unused = .;
+
+		/* Kernel symbol table: GPL-only unused symbols */
+		__start___kcrctab_unused_gpl = .;
+		*(__kcrctab_unused_gpl)
+		__stop___kcrctab_unused_gpl = .;
+
 		/* Kernel symbol table: GPL-future symbols */
 		__start___kcrctab_gpl_future = .;
 		*(__kcrctab_gpl_future)
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch

