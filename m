Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFC0C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 20:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiHVU7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbiHVU7O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 16:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE85A4D255
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 13:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C6366130F
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 20:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38CCC433D6;
        Mon, 22 Aug 2022 20:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661201950;
        bh=2mzqB8IFMM0bX0AGFmIEl8/d0K/aSWZEu/Crs/iyFvs=;
        h=Date:To:From:Subject:From;
        b=pI5qX9U4K4SxAIhz8vSFo+sB4Z/4s88fE3rPqt3uttGQfeEPa8b/y87rwrID1z7ku
         5bO43rfmFuqQOLx8VitHiImlnjdc45GVdI/T/2ttHwnqKyOuUPnE9Ar61bxna43fbI
         djFc04iqSThC56qhg20m7DmSLmmqpQT2r7oeT5NI=
Date:   Mon, 22 Aug 2022 13:59:09 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch added to mm-unstable branch
Message-Id: <20220822205909.E38CCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: add api documentation for walk_page_range_novma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch

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
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: pagewalk: add api documentation for walk_page_range_novma()
Date: Mon, 22 Aug 2022 15:02:36 +0200

Link: https://lkml.kernel.org/r/8991525.CDJkKcVGEf@devpool047
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-add-api-documentation-for-walk_page_range_novma
+++ a/mm/pagewalk.c
@@ -493,7 +493,15 @@ int walk_page_range(struct mm_struct *mm
 	return 0;
 }
 
-/*
+/**
+ * walk_page_range_novma - walk a range of pagetables not backed by a vma
+ * @mm:		mm_struct representing the target process of page table walk
+ * @start:	start address of the virtual address range
+ * @end:	end address of the virtual address range
+ * @ops:	operation to call during the walk
+ * @pgd:	pgd to walk if different from mm->pgd
+ * @private:	private data for callbacks' usage
+ *
  * Similar to walk_page_range() but can walk any page tables even if they are
  * not backed by VMAs. Because 'unusual' entries may be walked this function
  * will also not lock the PTEs for the pte_entry() callback. This is useful for
_

Patches currently in -mm which might be from eb@emlix.com are

mm-pagewalk-make-error-checks-more-obvious.patch
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch

