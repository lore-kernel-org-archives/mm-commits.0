From: akpm@linux-foundation.org
Subject: +
 mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
 added to -mm tree
Date: Mon, 04 May 2020 15:35:56 -0700
Message-ID: <20200504223556.dXpyg4MOC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgEDWf6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 18:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, gerald.schaefer@de.ibm.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-add-tests-validating-architecture-page-table-helpers-v18
has been added to the -mm tree.  Its filename is
     mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-debug-add-tests-validating-architecture-page-table-helpers-v18

Link: http://lkml.kernel.org/r/1588564865-31160-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Qian Cai <cai@lca.pw>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/lib/Kconfig.debug~mm-debug-add-tests-validating-architecture-page-table-helpers-v18
+++ a/lib/Kconfig.debug
@@ -697,9 +697,8 @@ config DEBUG_VM_PGFLAGS
 config DEBUG_VM_PGTABLE
 	bool "Debug arch page table for semantics compliance"
 	depends on MMU
-	depends on !IA64 && !ARM
-	depends on ARCH_HAS_DEBUG_VM_PGTABLE || EXPERT
-	default y if ARCH_HAS_DEBUG_VM_PGTABLE && DEBUG_VM
+	depends on ARCH_HAS_DEBUG_VM_PGTABLE
+	default y if DEBUG_VM
 	help
 	  This option provides a debug method which can be used to test
 	  architecture page table helper functions on various platforms in
@@ -707,9 +706,7 @@ config DEBUG_VM_PGTABLE
 	  will help architecture code in making sure that any changes or
 	  new additions of these helpers still conform to expected
 	  semantics of the generic MM. Platforms will have to opt in for
-	  this through ARCH_HAS_DEBUG_VM_PGTABLE. Although it can also be
-	  enabled through EXPERT without requiring code change. This test
-	  is disabled on IA64 and ARM platforms where it fails to build.
+	  this through ARCH_HAS_DEBUG_VM_PGTABLE.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
