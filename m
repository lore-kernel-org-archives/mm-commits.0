Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72E4C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbjDFWod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbjDFWob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:44:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F2AF0D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22E5564CEE
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E75C433EF;
        Thu,  6 Apr 2023 22:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680821069;
        bh=cnPTePHM9qwXdXDZeitMQ489BsRkFCDnKQFUknhIOCA=;
        h=Date:To:From:Subject:From;
        b=IrrayWpFS8X5R/WZKscP/tPinZ4Awesewe1+sBeBdpwTvNkdqxSemHad/c+piSVV6
         70J6pWZBSq/4yHQuTcwzf65V5t96mKnoPBBhubpH0wPDzUtQraYjlg5mBqbkeXT/Br
         Vrz92vsZM7c6ERm4khQQtzfL0lziqE/O7ELSSGsY=
Date:   Thu, 06 Apr 2023 15:44:28 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linux@roeck-us.net,
        kirill@shutemov.name, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-redefine-max_order-sanely-fix-fix.patch added to mm-unstable branch
Message-Id: <20230406224429.75E75C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-redefine-max_order-sanely-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-redefine-max_order-sanely-fix-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-treewide-redefine-max_order-sanely-fix-fix
Date: Thu, 6 Apr 2023 10:25:29 +0300

On Wed, Apr 05, 2023 at 10:20:26PM -0700, Guenter Roeck wrote:
>
> This patch results in various boot failures (hang) on arm targets
> in linux-next. Debug messages reveal the reason.
>
> ########### MAX_ORDER=10 start=0 __ffs(start)=-1 min()=10 min_t=-1
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> If start==0, __ffs(start) returns 0xfffffff or (as int) -1, which min_t()
> interprets as such, while min() apparently uses the returned unsigned long
> value. Obviously a negative order isn't received well by the rest of the
> code.

Actually, __ffs() is not defined for 0.

Maybe something like this?

Link: https://lkml.kernel.org/r/20230406072529.vupqyrzqnhyozeyh@box.shutemov.name
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mike Rapoport <rppt@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
  Link: https://lkml.kernel.org/r/9460377a-38aa-4f39-ad57-fb73725f92db@roeck-us.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c       |    6 +++++-
 mm/memory_hotplug.c |    8 +++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/mm/memblock.c~mm-treewide-redefine-max_order-sanely-fix-fix
+++ a/mm/memblock.c
@@ -2043,7 +2043,11 @@ static void __init __free_pages_memory(u
 	int order;
 
 	while (start < end) {
-		order = min_t(int, MAX_ORDER, __ffs(start));
+		/* __ffs() behaviour is undefined for 0 */
+		if (start)
+			order = min_t(int, MAX_ORDER, __ffs(start));
+		else
+			order = MAX_ORDER;
 
 		while (start + (1UL << order) > end)
 			order--;
--- a/mm/memory_hotplug.c~mm-treewide-redefine-max_order-sanely-fix-fix
+++ a/mm/memory_hotplug.c
@@ -605,7 +605,13 @@ static void online_pages_range(unsigned
 	 * this and the first chunk to online will be pageblock_nr_pages.
 	 */
 	for (pfn = start_pfn; pfn < end_pfn;) {
-		int order = min_t(int, MAX_ORDER, __ffs(pfn));
+		int order;
+
+		/* __ffs() behaviour is undefined for 0 */
+		if (pfn)
+			order = min_t(int, MAX_ORDER, __ffs(pfn));
+		else
+			order = MAX_ORDER;
 
 		(*online_page_callback)(pfn_to_page(pfn), order);
 		pfn += (1UL << order);
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-treewide-redefine-max_order-sanely-fix-fix.patch

