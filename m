From: akpm@linux-foundation.org
Subject: + mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch added to -mm tree
Date: Tue, 03 May 2011 16:35:56 -0700
Message-ID: <201105032335.p43NZuCo017526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab1ECXgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 19:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, dave@linux.vnet.ibm.com


The patch titled
     mm: pfn_to_section_nr()/section_nr_to_pfn() is valid only in CONFIG_SPARSEMEM context
has been added to the -mm tree.  Its filename is
     mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
