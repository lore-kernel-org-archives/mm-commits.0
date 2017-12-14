From: akpm@linux-foundation.org
Subject: + mips-use-generic_pmdp_establish-as-pmdp_establish.patch added
 to -mm tree
Date: Wed, 13 Dec 2017 16:11:17 -0800
Message-ID: <5a31c1a5.udrcpTm9C9d9RG4b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdLNALT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, david.daney@cavium.com, mhocko@kernel.org, ralf@linux-mips.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: use generic_pmdp_establish as pmdp_establish
has been added to the -mm tree.  Its filename is
     mips-use-generic_pmdp_establish-as-pmdp_establish.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-use-generic_pmdp_establish-as-pmdp_establish.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-use-generic_pmdp_establish-as-pmdp_establish.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mips: use generic_pmdp_establish as pmdp_establish

MIPS doesn't support hardware dirty/accessed bits. 
generic_pmdp_establish() is suitable in this case.

Link: http://lkml.kernel.org/r/20171213105756.69879-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/mips/include/asm/pgtable.h~mips-use-generic_pmdp_establish-as-pmdp_establish arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mips-use-generic_pmdp_establish-as-pmdp_establish
+++ a/arch/mips/include/asm/pgtable.h
@@ -534,6 +534,9 @@ static inline int io_remap_pfn_range(str
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
+/* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
+#define pmdp_establish generic_pmdp_establish
+
 #define has_transparent_hugepage has_transparent_hugepage
 extern int has_transparent_hugepage(void);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

asm-generic-provide-generic_pmdp_establish.patch
arc-use-generic_pmdp_establish-as-pmdp_establish.patch
arm-mm-provide-pmdp_establish-helper.patch
mips-use-generic_pmdp_establish-as-pmdp_establish.patch
x86-mm-provide-pmdp_establish-helper.patch
mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch
mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits.patch

