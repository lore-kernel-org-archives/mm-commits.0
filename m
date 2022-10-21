Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0719BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJUBct (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJUBcs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:32:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680F414EC6F
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD465CE2847
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0F6C433C1;
        Fri, 21 Oct 2022 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666315960;
        bh=+BfIs5yoKUoej4GUOK4wbNiIod+YThOCt4GKjBEzwpo=;
        h=Date:To:From:Subject:From;
        b=XDnOn5asBue/lPn4B6aTJAb17tH0l+jTJLEv9TJMUaOfGNY2hFo3k0DyLu+mntjjT
         y4bliE7k1mA0TwzVVrx/9zGWI1r4dNCc1/KclwmTaSzETiy67baOm/SJ4v6yKyziWr
         QaYn2et+apmimytgTK2m9G2GSUTQFrK2WszXyyoc=
Date:   Thu, 20 Oct 2022 18:32:39 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix-2.patch added to mm-unstable branch
Message-Id: <20221021013239.DC0F6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: change break_ksm_pmd|pud_entry() to static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix-2.patch

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
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/ksm: change break_ksm_pmd|pud_entry() to static
Date: Thu, 20 Oct 2022 15:59:13 +0800

break_ksm_pmd|pud_entry() is only used in ksm.c now, change them to
static.

Link: https://lkml.kernel.org/r/20221020075913.1046481-1-yangyingliang@huawei.com
Fixes: 16ee05ec4698 ("mm/ksm: convert break_ksm() to use walk_page_range_vma()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix-2
+++ a/mm/ksm.c
@@ -420,7 +420,7 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-int break_ksm_pud_entry(pud_t *pud, unsigned long addr, unsigned long next,
+static int break_ksm_pud_entry(pud_t *pud, unsigned long addr, unsigned long next,
 			struct mm_walk *walk)
 {
 	/* We only care about page tables to walk to a single base page. */
@@ -429,7 +429,7 @@ int break_ksm_pud_entry(pud_t *pud, unsi
 	return 0;
 }
 
-int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
 			struct mm_walk *walk)
 {
 	bool *ksm_page = walk->private;
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix-2.patch

