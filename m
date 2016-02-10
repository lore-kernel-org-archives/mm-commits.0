From: akpm@linux-foundation.org
Subject: + thp-vmstats-count-deferred-split-events-v2.patch added to -mm
 tree
Date: Wed, 10 Feb 2016 11:24:29 -0800
Message-ID: <56bb8e6d.dKU4ZcTScRIav9Vb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbcBJTYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-vmstats-count-deferred-split-events-v2
has been added to the -mm tree.  Its filename is
     thp-vmstats-count-deferred-split-events-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-vmstats-count-deferred-split-events-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-vmstats-count-deferred-split-events-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp-vmstats-count-deferred-split-events-v2

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/vm/transhuge.txt~thp-vmstats-count-deferred-split-events-v2 Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-vmstats-count-deferred-split-events-v2
+++ a/Documentation/vm/transhuge.txt
@@ -229,6 +229,11 @@ thp_split_page is incremented every time
 thp_split_page_failed is is incremented if kernel fails to split huge
 	page. This can happen if the page was pinned by somebody.
 
+thp_deferred_split_page is incremented when a huge page is put onto split
+	queue. This happens when a huge page is partially unmapped and
+	splitting it would free up some memory. Pages on split queue are
+	going to be split under memory pressure.
+
 thp_split_pmd is incremented every time a PMD split into table of PTEs.
 	This can happen, for instance, when application calls mprotect() or
 	munmap() on part of huge page. It doesn't split huge page, only
_

Patches currently in -mm which might be from kirill@shutemov.name are

thp-vmstats-count-deferred-split-events-v2.patch

