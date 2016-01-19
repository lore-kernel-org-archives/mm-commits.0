From: akpm@linux-foundation.org
Subject: [merged]
 tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:23 -0800
Message-ID: <569e964f.bBgSkD3RQ+r2xZzO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: tile, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: tile, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/pgtable.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN arch/tile/include/asm/pgtable.h~tile-thp-remove-infrastructure-for-handling-splitting-pmds arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~tile-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/tile/include/asm/pgtable.h
@@ -489,16 +489,6 @@ static inline pmd_t pmd_modify(pmd_t pmd
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define has_transparent_hugepage() 1
 #define pmd_trans_huge pmd_huge_page
-
-static inline pmd_t pmd_mksplitting(pmd_t pmd)
-{
-	return pte_pmd(hv_pte_set_client2(pmd_pte(pmd)));
-}
