From: akpm@linux-foundation.org
Subject: [merged] mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:57 -0700
Message-ID: <201105252028.p4PKSKsa014733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932670Ab1EYUsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: pfn_to_section_nr()/section_nr_to_pfn() is valid only in CONFIG_SPARSEMEM context
has been removed from the -mm tree.  Its filename was
     mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pfn_to_section_nr()/section_nr_to_pfn() is valid only in CONFIG_SPARSEMEM context
From: Daniel Kiper <dkiper@net-space.pl>

pfn_to_section_nr()/section_nr_to_pfn() is valid only in CONFIG_SPARSEMEM
context.  Move it to proper place.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context
+++ a/include/linux/mmzone.h
@@ -928,9 +928,6 @@ static inline unsigned long early_pfn_to
 #define pfn_to_nid(pfn)		(0)
 #endif
 
-#define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
-#define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
