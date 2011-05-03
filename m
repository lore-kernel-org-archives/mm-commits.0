From: akpm@linux-foundation.org
Subject: + mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch added to -mm tree
Date: Tue, 03 May 2011 16:35:58 -0700
Message-ID: <201105032335.p43NZwUB017529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab1ECXgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 19:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, dave@linux.vnet.ibm.com


The patch titled
     mm: do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM
has been added to the -mm tree.  Its filename is
     mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch

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
