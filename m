From: akpm@linux-foundation.org
Subject: + mm-skip-hwpoisoned-pages-when-onlining-pages.patch added to -mm tree
Date: Tue, 25 Apr 2017 13:47:32 -0700
Message-ID: <58ffb5e4.8B+IEvcdvNJZjy9w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1950062AbdDYUrd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 16:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, avagin@openvz.org, glommer@openvz.org, n-horiguchi@ah.jp.nec.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: skip HWPoisoned pages when onlining pages
has been added to the -mm tree.  Its filename is
     mm-skip-hwpoisoned-pages-when-onlining-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-skip-hwpoisoned-pages-when-onlining-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-skip-hwpoisoned-pages-when-onlining-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: skip HWPoisoned pages when onlining pages

b023f46813cd ("memory-hotplug: skip HWPoisoned page when offlining pages")
skipped the HWPoisoned pages when offlining pages, but this should be
skipped when onlining the pages too.

Link: http://lkml.kernel.org/r/1493130472-22843-3-git-send-email-ldufour@linux.vnet.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memory_hotplug.c~mm-skip-hwpoisoned-pages-when-onlining-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-skip-hwpoisoned-pages-when-onlining-pages
+++ a/mm/memory_hotplug.c
@@ -942,6 +942,10 @@ static int online_pages_range(unsigned l
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
+			if (PageHWPoison(page)) {
+				ClearPageReserved(page);
+				continue;
+			}
 			(*online_page_callback)(page);
 			onlined_pages++;
 		}
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-uncharge-poisoned-pages.patch
mm-skip-hwpoisoned-pages-when-onlining-pages.patch

