From: akpm@linux-foundation.org
Subject: + doc-add-information-about-max_ptes_swap.patch added to -mm tree
Date: Fri, 18 Sep 2015 13:39:49 -0700
Message-ID: <55fc7695.rzyd7+XJiU+lXTDH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbbIRUju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 16:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com, oleg@redhat.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/transhuge.txt: add information about max_ptes_swap
has been added to the -mm tree.  Its filename is
     doc-add-information-about-max_ptes_swap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-add-information-about-max_ptes_swap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-add-information-about-max_ptes_swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: Documentation/vm/transhuge.txt: add information about max_ptes_swap

max_ptes_swap specifies how many pages can be brought in from swap when
collapsing a group of pages into a transparent huge page.

/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_swap

A higher value can cause excessive swap IO and waste memory.  A lower
value can prevent THPs from being collapsed, resulting fewer pages being
collapsed into THPs, and lower memory access performance.

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN Documentation/vm/transhuge.txt~doc-add-information-about-max_ptes_swap Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~doc-add-information-about-max_ptes_swap
+++ a/Documentation/vm/transhuge.txt
@@ -170,6 +170,16 @@ A lower value leads to gain less thp per
 max_ptes_none can waste cpu time very little, you can
 ignore it.
 
+max_ptes_swap specifies how many pages can be brought in from
+swap when collapsing a group of pages into a transparent huge page.
+
+/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_swap
+
+A higher value can cause excessive swap IO and waste
+memory. A lower value can prevent THPs from being
+collapsed, resulting fewer pages being collapsed into
+THPs, and lower memory access performance.
+
 == Boot parameter ==
 
 You can change the sysfs boot time defaults of Transparent Hugepage
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-add-tracepoint-for-scanning-pages.patch
mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
doc-add-information-about-max_ptes_swap.patch

