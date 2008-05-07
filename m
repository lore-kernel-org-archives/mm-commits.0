From: akpm@linux-foundation.org
Subject: + m68knommu-missing-sections-for-linker-script.patch added to -mm tree
Date: Wed, 07 May 2008 14:48:19 -0700
Message-ID: <200805072148.m47LmJg6018169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438AbYEGVtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: missing sections for linker script
has been added to the -mm tree.  Its filename is
     m68knommu-missing-sections-for-linker-script.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-missing-sections-for-linker-script.patch

