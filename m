From: akpm@linux-foundation.org
Subject: + mm-update-the-description-for-vm_total_pages.patch added to -mm tree
Date: Tue, 08 Jul 2014 13:41:49 -0700
Message-ID: <53bc578d.Dhs05nr1b6Y3Tyvz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:40365 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaGHUlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 16:41:50 -0400
Received: by mail-ig0-f201.google.com with SMTP id h15so104870igd.2
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 13:41:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the description for vm_total_pages
has been added to the -mm tree.  Its filename is
     mm-update-the-description-for-vm_total_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-description-for-vm_total_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-description-for-vm_total_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm: update the description for vm_total_pages

vm_total_pages is calculated by nr_free_pagecache_pages(), which counts
the number of pages which are beyond the high watermark within all zones. 
So vm_total_pages is not equal to total number of pages which the VM
controls.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-update-the-description-for-vm_total_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-update-the-description-for-vm_total_pages
+++ a/mm/vmscan.c
@@ -136,7 +136,11 @@ struct scan_control {
  * From 0 .. 100.  Higher means more swappy.
  */
 int vm_swappiness = 60;
-unsigned long vm_total_pages;	/* The total number of pages which the VM controls */
+/*
+ * The total number of pages which are beyond the high watermark within all
+ * zones.
+ */
+unsigned long vm_total_pages;
 
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
_

Patches currently in -mm which might be from shhuiw@gmail.com are

mm-update-the-description-for-madvise_remove.patch
mm-update-the-description-for-vm_total_pages.patch

