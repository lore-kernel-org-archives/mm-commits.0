Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B1CEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjGBXO6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBXO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B3A1BE
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CCB560CD4
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93618C433C8;
        Sun,  2 Jul 2023 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688339695;
        bh=XM8bYdgMIT1IkB2IBrM0OzMn/5y7ZF/+82iCo/H5YJQ=;
        h=Date:To:From:Subject:From;
        b=V+TVKHgqwcGN9Gup84IabjIrs6qtV8mKPvoCYqGvKWqJ+5/08TtaFGdI8QgLxsLkp
         03ZKQm0L3LzUJ/ypnqh3XNUoJXs/1ihQnAnSMn4q7fY3JjAqRMdRGUP7nAwjSS9Hs4
         zIBnHAvqD6bBR/NuHa+m9n//DKYq3d+TTCZjteeE=
Date:   Sun, 02 Jul 2023 16:14:55 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-unneeded-inline-annotation.patch added to mm-unstable branch
Message-Id: <20230702231455.93618C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: remove unneeded 'inline' annotation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-unneeded-inline-annotation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-unneeded-inline-annotation.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: remove unneeded 'inline' annotation
Date: Mon, 26 Jun 2023 19:43:43 +0800

Remove unneeded 'inline' annotation from num_poisoned_pages_inc() and
num_poisoned_pages_sub().  No functional change intended.

Link: https://lkml.kernel.org/r/20230626114343.1846587-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-inline-annotation
+++ a/mm/memory-failure.c
@@ -75,13 +75,13 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool hw_memory_failure __read_mostly = false;
 
-inline void num_poisoned_pages_inc(unsigned long pfn)
+void num_poisoned_pages_inc(unsigned long pfn)
 {
 	atomic_long_inc(&num_poisoned_pages);
 	memblk_nr_poison_inc(pfn);
 }
 
-inline void num_poisoned_pages_sub(unsigned long pfn, long i)
+void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
 	if (pfn != -1UL)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch

