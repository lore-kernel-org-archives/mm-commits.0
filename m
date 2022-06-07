Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35929C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 03:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiFHDRX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 23:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347754AbiFHDOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 23:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E0919EC0F
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 12:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95140611D8
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 19:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03B8C385A2;
        Tue,  7 Jun 2022 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654629980;
        bh=g7P0OWQTADEEBq8ImWeeigHzLO9E21q2Gs3lYJ1yE5g=;
        h=Date:To:From:Subject:From;
        b=ILOlBBYaIy5Xthig3WNWYEqs5fZ5GgffMncCzNy+jSXvoRN7/oQTfvyULD5lJo2p7
         qdmVYj43AhIWQFu/5opa1EI8F+QlcJTuUty8r8mIJ1Ce0JY8Qs1/pha+RkINPYVlAB
         8oX7SK2TXZgOAd7oRqo+4LNVWPTBKwugHSVlsN5A=
Date:   Tue, 07 Jun 2022 12:26:19 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-fix-wrong-function-name-above-memremap_pages.patch added to mm-unstable branch
Message-Id: <20220607192619.E03B8C385A2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: fix wrong function name above memremap_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap-fix-wrong-function-name-above-memremap_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-fix-wrong-function-name-above-memremap_pages.patch

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
Subject: mm/memremap: fix wrong function name above memremap_pages()
Date: Tue, 7 Jun 2022 22:36:21 +0800

Fix the wrong function name dev_memremap_pages above memremap_pages() to
avoid confusion.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220607143621.58989-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memremap.c~mm-memremap-fix-wrong-function-name-above-memremap_pages
+++ a/mm/memremap.c
@@ -279,8 +279,8 @@ err_pfn_remap:
 
 
 /*
- * Not device managed version of dev_memremap_pages, undone by
- * memunmap_pages().  Please use dev_memremap_pages if you have a struct
+ * Not device managed version of devm_memremap_pages, undone by
+ * memunmap_pages().  Please use devm_memremap_pages if you have a struct
  * device available.
  */
 void *memremap_pages(struct dev_pagemap *pgmap, int nid)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch

