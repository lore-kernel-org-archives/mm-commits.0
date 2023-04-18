Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07B4C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDRXdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDRXdY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90211E7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E9FD62BAD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC7EC433D2;
        Tue, 18 Apr 2023 23:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860802;
        bh=Z4kiETUHPihuMkPMPI0yH6GApjQyxdRlstZGcOK81f8=;
        h=Date:To:From:Subject:From;
        b=PWx2hILhGnto3Y1gNstHRGZaVvJ+6FrGlG6LY+SMmQycoW5prFzcS4x/omQPMd0jN
         I+wH+eZ24QpYNhP8E0pzjbwi3fR1BUcr/GzEAk8F9oMMJyJNikWf3OUKl2Rgh3oZJY
         ukY87i4Y7HuDOM+EaeDDib32AM+6Y+EonXsFdtjo=
Date:   Tue, 18 Apr 2023 16:33:21 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linux@roeck-us.net,
        kirill@shutemov.name, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-treewide-redefine-max_order-sanely-fix-fix.patch removed from -mm tree
Message-Id: <20230418233322.7AC7EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: avoid passing 0 to __ffs()
has been removed from the -mm tree.  Its filename was
     mm-treewide-redefine-max_order-sanely-fix-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm: avoid passing 0 to __ffs()
Date: Thu, 6 Apr 2023 10:25:29 +0300

23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely") results in
various boot failures (hang) on arm targets Debug messages reveal the
reason.

########### MAX_ORDER=10 start=0 __ffs(start)=-1 min()=10 min_t=-1
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If start==0, __ffs(start) returns 0xfffffff or (as int) -1, which min_t()
interprets as such, while min() apparently uses the returned unsigned long
value. Obviously a negative order isn't received well by the rest of the
code.

[akpm@linux-foundation.org: fix comment, per Mike]
  Link: https://lkml.kernel.org/r/ZDBa7HWZK69dKKzH@kernel.org
Link: https://lkml.kernel.org/r/20230406072529.vupqyrzqnhyozeyh@box.shutemov.name
Fixes: 23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely")
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Reported-by: Guenter Roeck <linux@roeck-us.net>
  Link: https://lkml.kernel.org/r/9460377a-38aa-4f39-ad57-fb73725f92db@roeck-us.net
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c       |   11 ++++++++++-
 mm/memory_hotplug.c |   13 ++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/mm/memblock.c~mm-treewide-redefine-max_order-sanely-fix-fix
+++ a/mm/memblock.c
@@ -2043,7 +2043,16 @@ static void __init __free_pages_memory(u
 	int order;
 
 	while (start < end) {
-		order = min_t(int, MAX_ORDER, __ffs(start));
+		/*
+		 * Free the pages in the largest chunks alignment allows.
+		 *
+		 * __ffs() behaviour is undefined for 0. start == 0 is
+		 * MAX_ORDER-aligned, set order to MAX_ORDER for the case.
+		 */
+		if (start)
+			order = min_t(int, MAX_ORDER, __ffs(start));
+		else
+			order = MAX_ORDER;
 
 		while (start + (1UL << order) > end)
 			order--;
--- a/mm/memory_hotplug.c~mm-treewide-redefine-max_order-sanely-fix-fix
+++ a/mm/memory_hotplug.c
@@ -605,7 +605,18 @@ static void online_pages_range(unsigned
 	 * this and the first chunk to online will be pageblock_nr_pages.
 	 */
 	for (pfn = start_pfn; pfn < end_pfn;) {
-		int order = min_t(int, MAX_ORDER, __ffs(pfn));
+		int order;
+
+		/*
+		 * Free to online pages in the largest chunks alignment allows.
+		 *
+		 * __ffs() behaviour is undefined for 0. start == 0 is
+		 * MAX_ORDER-aligned, Set order to MAX_ORDER for the case.
+		 */
+		if (pfn)
+			order = min_t(int, MAX_ORDER, __ffs(pfn));
+		else
+			order = MAX_ORDER;
 
 		(*online_page_callback)(pfn_to_page(pfn), order);
 		pfn += (1UL << order);
_

Patches currently in -mm which might be from kirill@shutemov.name are


