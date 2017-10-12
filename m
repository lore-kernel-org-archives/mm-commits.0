From: akpm@linux-foundation.org
Subject: + mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch
 added to -mm tree
Date: Thu, 12 Oct 2017 15:46:12 -0700
Message-ID: <59dff0b4.+z6N+s9LXocRZxi4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756330AbdJLWqO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Oct 2017 18:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_state.c: declare a few variables as __read_mostly
has been added to the -mm tree.  Its filename is
     mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -35,9 +35,9 @@ static const struct address_space_operat
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

mm-update-comments-for-struct-pagemapping.patch
mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch

