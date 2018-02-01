From: akpm@linux-foundation.org
Subject: [patch 064/119] mips: use generic_pmdp_establish as
 pmdp_establish
Date: Wed, 31 Jan 2018 16:17:58 -0800
Message-ID: <20180201001758.vOVt82lIs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeBAASA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, david.daney@cavium.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, ralf@linux-mips.org, torvalds@linux-foundation.org, vbabka@suse.cz

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
