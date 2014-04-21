From: akpm@linux-foundation.org
Subject: + mm-debug-make-bad_range-output-more-usable-and-readable.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 13:26:53 -0700
Message-ID: <53557f0d.iyig7XI1NugzAclj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaDUU0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com

Subject: + mm-debug-make-bad_range-output-more-usable-and-readable.patch added to -mm tree
To: dave.hansen@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:26:53 -0700


The patch titled
     Subject: mm: debug: make bad_range() output more usable and readable
has been added to the -mm tree.  Its filename is
     mm-debug-make-bad_range-output-more-usable-and-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-make-bad_range-output-more-usable-and-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-make-bad_range-output-more-usable-and-readable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: debug: make bad_range() output more usable and readable

Nobody outputs memory addresses in decimal.  PFNs are essentially
addresses, and they're gibberish in decimal.  Output them in hex.

Also, add the nid and zone name to give a little more context to the
message.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-debug-make-bad_range-output-more-usable-and-readable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-make-bad_range-output-more-usable-and-readable
+++ a/mm/page_alloc.c
@@ -261,8 +261,9 @@ static int page_outside_zone_boundaries(
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
-		pr_err("page %lu outside zone [ %lu - %lu ]\n",
-			pfn, start_pfn, start_pfn + sp);
+		pr_err("page 0x%lx outside node %d zone %s [ 0x%lx - 0x%lx ]\n",
+			pfn, zone_to_nid(zone), zone->name,
+			start_pfn, start_pfn + sp);
 
 	return ret;
 }
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

