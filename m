From: akpm@linux-foundation.org
Subject: + mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch
 added to -mm tree
Date: Tue, 13 Feb 2018 15:50:49 -0800
Message-ID: <5a8379d9.Ptff8MDizS+AuJuZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966158AbeBMXuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 18:50:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, akpm@linux-foundation.org, corbet@lwn.net, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: move mirrored_kernelcore to __meminitdata
has been added to the -mm tree.  Its filename is
     mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: move mirrored_kernelcore to __meminitdata

mirrored_kernelcore can be in __meminitdata, so move it there.

At the same time, fixup section specifiers to be after the name of the
variable per checkpatch.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1802121623280.179479@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata
+++ a/mm/page_alloc.c
@@ -264,19 +264,19 @@ int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
 int watermark_scale_factor = 10;
 
-static unsigned long __meminitdata nr_kernel_pages;
-static unsigned long __meminitdata nr_all_pages;
-static unsigned long __meminitdata dma_reserve;
+static unsigned long nr_kernel_pages __meminitdata;
+static unsigned long nr_all_pages __meminitdata;
+static unsigned long dma_reserve __meminitdata;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
-static unsigned long __initdata required_kernelcore;
+static unsigned long arch_zone_lowest_possible_pfn[MAX_NR_ZONES] __meminitdata;
+static unsigned long arch_zone_highest_possible_pfn[MAX_NR_ZONES] __meminitdata;
+static unsigned long required_kernelcore __initdata;
 static unsigned long required_kernelcore_percent __initdata;
-static unsigned long __initdata required_movablecore;
+static unsigned long required_movablecore __initdata;
 static unsigned long required_movablecore_percent __initdata;
-static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
-static bool mirrored_kernelcore;
+static unsigned long zone_movable_pfn[MAX_NUMNODES] __meminitdata;
+static bool mirrored_kernelcore __meminitdata;
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
_

Patches currently in -mm which might be from rientjes@google.com are

kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch
mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch
mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch

