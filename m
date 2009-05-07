From: akpm@linux-foundation.org
Subject: + nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region.patch added to -mm tree
Date: Thu, 07 May 2009 13:22:54 -0700
Message-ID: <200905072022.n47KMs0j030140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbZEGUZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 16:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@uclinux.org


The patch titled
     nommu: don't check vm_region::vm_start is page aligned in add_nommu_region()
has been added to the -mm tree.  Its filename is
     nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region.patch

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
Subject: nommu: don't check vm_region::vm_start is page aligned in add_nommu_region()
From: David Howells <dhowells@redhat.com>

Don't check vm_region::vm_start is page aligned in add_nommu_region()
because the region may reflect some non-page-aligned mapped file, such as
could be obtained from RomFS XIP.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/nommu.c~nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region mm/nommu.c
--- a/mm/nommu.c~nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region
+++ a/mm/nommu.c
@@ -515,8 +515,6 @@ static void add_nommu_region(struct vm_r
 
 	validate_nommu_regions();
 
-	BUG_ON(region->vm_start & ~PAGE_MASK);
