From: akpm@linux-foundation.org
Subject: [folded-merged] thp-vmstats-count-deferred-split-events-v2.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:55:03 -0700
Message-ID: <56eb19a7.ysfx83ZyCd+8lhDp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465AbcCQUzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-vmstats-count-deferred-split-events-v2
has been removed from the -mm tree.  Its filename was
     thp-vmstats-count-deferred-split-events-v2.patch

This patch was dropped because it was folded into thp-vmstats-count-deferred-split-events.patch

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

thp-vmstats-count-deferred-split-events.patch

