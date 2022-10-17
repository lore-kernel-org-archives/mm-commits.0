Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0FEC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiJQUly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiJQUlj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B325C82632
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 534A661286
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9814C433D7;
        Mon, 17 Oct 2022 20:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039038;
        bh=/i3VkumUOq1fFz+OgKzEpHUF2q8HPoH1H0kZr+anreY=;
        h=Date:To:From:Subject:From;
        b=iBdP17m5ZqQbbXQo9Ema0yxxva8zlyjfv8cqw/R9PniupmZSZ9SPVSef0rgNboYJn
         J2ZLTErA4RUTiB0GcLnWGZmdcDz7IbxNdhcpqG9nEtZoDwWqu5fdojFgNc4fm9DKID
         YCrdVPILn5Yk099A4IKcmsg98Bf48OGNhI5X/0ho=
Date:   Mon, 17 Oct 2022 13:37:17 -0700
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-free_huge_page-to-folios-fix.patch added to mm-unstable branch
Message-Id: <20221017203718.A9814C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-convert-free_huge_page-to-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-free_huge_page-to-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-free_huge_page-to-folios-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-convert-free_huge_page-to-folios-fix
Date: Mon Oct 17 01:32:30 PM PDT 2022

fix build

In file included from ./include/linux/mm.h:6,
                 from mm/hugetlb.c:8:
mm/hugetlb.c: In function 'free_huge_page':
mm/hugetlb.c:1707:47: error: passing argument 1 of 'dump_page' from incompatible pointer type [-Werror=incompatible-pointer-types]
 1707 |         VM_BUG_ON_PAGE(folio_mapcount(folio), folio);
      |                                               ^~~~~
      |                                               |
      |                                               struct folio *
./include/linux/mmdebug.h:21:35: note: in definition of macro 'VM_BUG_ON_PAGE'
   21 |                         dump_page(page, "VM_BUG_ON_PAGE(" __stringify(cond)")");\
      |                                   ^~~~
./include/linux/mmdebug.h:12:29: note: expected 'struct page *' but argument is of type 'struct folio *'
   12 | void dump_page(struct page *page, const char *reason);
      |                ~~~~~~~~~~~~~^~~~
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:250: mm/hugetlb.o] Error 1
make[1]: *** [scripts/Makefile.build:500: mm] Error 2
make: *** [Makefile:1992: .] Error 2

Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-free_huge_page-to-folios-fix
+++ a/mm/hugetlb.c
@@ -1704,7 +1704,7 @@ void free_huge_page(struct page *page)
 	unsigned long flags;
 
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
-	VM_BUG_ON_PAGE(folio_mapcount(folio), folio);
+	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
 	hugetlb_set_folio_subpool(folio, NULL);
 	if (folio_test_anon(folio))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-convert-free_huge_page-to-folios-fix.patch

