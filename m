From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:59 -0700
Message-ID: <201105252028.p4PKSMhn014736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347Ab1EYUrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM
has been removed from the -mm tree.  Its filename was
     mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM
From: Daniel Kiper <dkiper@net-space.pl>

Do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/mm.h~mm-do-not-define-pfn_section_shift-if-config_sparsemem include/linux/mm.h
--- a/include/linux/mm.h~mm-do-not-define-pfn_section_shift-if-config_sparsemem
+++ a/include/linux/mm.h
@@ -605,10 +605,6 @@ static inline pte_t maybe_mkwrite(pte_t 
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
-#ifndef PFN_SECTION_SHIFT
-#define PFN_SECTION_SHIFT 0
-#endif
