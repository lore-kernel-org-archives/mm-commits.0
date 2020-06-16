From: akpm@linux-foundation.org
Subject: + mm-remove-redundant-check-non_swap_entry.patch added to
 -mm tree
Date: Tue, 16 Jun 2020 12:06:34 -0700
Message-ID: <20200616190634.TVD1j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbgFPTGf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 15:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jgg@mellanox.com, rcampbell@nvidia.com


The patch titled
     Subject: mm: remove redundant check non_swap_entry()
has been added to the -mm tree.  Its filename is
     mm-remove-redundant-check-non_swap_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-redundant-check-non_swap_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-redundant-check-non_swap_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: remove redundant check non_swap_entry()

In zap_pte_range(), the check for non_swap_entry() and
is_device_private_entry() is unnecessary since the latter is sufficient to
determine if the page is a device private page.  Remove the test for
non_swap_entry() to simplify the code and for clarity.

Link: http://lkml.kernel.org/r/20200615175405.4613-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-remove-redundant-check-non_swap_entry
+++ a/mm/memory.c
@@ -1098,7 +1098,7 @@ again:
 		}
 
 		entry = pte_to_swp_entry(ptent);
-		if (non_swap_entry(entry) && is_device_private_entry(entry)) {
+		if (is_device_private_entry(entry)) {
 			struct page *page = device_private_entry_to_page(entry);
 
 			if (unlikely(details && details->check_mapping)) {
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-remove-redundant-check-non_swap_entry.patch
