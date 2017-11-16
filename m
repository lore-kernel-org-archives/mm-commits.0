From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:02:46 -0800
Message-ID: <20171116200246.qlIjNZvKZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUCr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_state.c: declare a few variables as __read_mostly
has been removed from the -mm tree.  Its filename was
     mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changbin Du <changbin.du@intel.com>
Subject: mm/swap_state.c: declare a few variables as __read_mostly

These global variables are only set during initialization or rarely
change, so declare them as __read_mostly.

Link: http://lkml.kernel.org/r/1507802349-5554-1-git-send-email-changbin.du@intel.com
Signed-off-by: Changbin Du <changbin.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/swap_state.c~mm-swap_statec-declare-a-few-variables-as-__read_mostly mm/swap_state.c
--- a/mm/swap_state.c~mm-swap_statec-declare-a-few-variables-as-__read_mostly
+++ a/mm/swap_state.c
@@ -36,9 +36,9 @@ static const struct address_space_operat
 #endif
 };
 
-struct address_space *swapper_spaces[MAX_SWAPFILES];
-static unsigned int nr_swapper_spaces[MAX_SWAPFILES];
-bool swap_vma_readahead = true;
+struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
+static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
+bool swap_vma_readahead __read_mostly = true;
 
 #define SWAP_RA_WIN_SHIFT	(PAGE_SHIFT / 2)
 #define SWAP_RA_HITS_MASK	((1UL << SWAP_RA_WIN_SHIFT) - 1)
_

Patches currently in -mm which might be from changbin.du@intel.com are


