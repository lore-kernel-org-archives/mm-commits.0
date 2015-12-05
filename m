From: akpm@linux-foundation.org
Subject: +
 drivers-memory-check-for-missing-sections-when-testing-zones.patch added to -mm tree
Date: Fri, 04 Dec 2015 16:03:28 -0800
Message-ID: <566229d0.gO+AqmlzHpiLEEhI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbbLEAD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abanman@sgi.com, gregkh@linuxfoundation.org, rja@sgi.com, sjennings@variantweb.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: check for missing sections when testing zones
has been added to the -mm tree.  Its filename is
     drivers-memory-check-for-missing-sections-when-testing-zones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memory-check-for-missing-sections-when-testing-zones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memory-check-for-missing-sections-when-testing-zones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Banman <abanman@sgi.com>
Subject: mm/memory_hotplug.c: check for missing sections when testing zones

test_pages_in_a_zone() does not account for the possibility of missing
sections in the given pfn range.  Since pfn_valid_within always returns 1
when CONFIG_HOLES_IN_ZONE is not set, invalid pfns from missing sections
will pass the test, resulting in a kernel oops.  This is remedied by
simply checking for the presence of the pfn's section.  We don't have to
remove the pfn_valid_within optimization.

The patch also prevents a crash from offlining memory devices with missing
sections.

Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russ Anderson <rja@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memory_hotplug.c~drivers-memory-check-for-missing-sections-when-testing-zones mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~drivers-memory-check-for-missing-sections-when-testing-zones
+++ a/mm/memory_hotplug.c
@@ -1383,6 +1383,9 @@ int test_pages_in_a_zone(unsigned long s
 	     pfn < end_pfn;
 	     pfn += MAX_ORDER_NR_PAGES) {
 		i = 0;
+		/* Make sure the memory section is present */
+		if (!present_section_nr(pfn_to_section_nr(pfn)))
+			continue;
 		/* This is just a CONFIG_HOLES_IN_ZONE check.*/
 		while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
 			i++;
_

Patches currently in -mm which might be from abanman@sgi.com are

drivers-memory-check-for-missing-sections-when-testing-zones.patch

