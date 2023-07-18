Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FE2EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 18:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjGRSLE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 14:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjGRSLD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 14:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E125B6
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 11:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF98D6151D
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 18:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48224C433C7;
        Tue, 18 Jul 2023 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689703861;
        bh=pT68f6YKk2/4WSAYJp5xnimmCoJbaBKN4E8En2uLwwo=;
        h=Date:To:From:Subject:From;
        b=xlRo2/vrn4mraKUw+HcO6KTRGB2d4s1gp+eeTn95QzJavU+h2DgKDSVmZKePQ9ere
         L+Ea8iusMGqp4mGn3wboJSl780oTF08RMl7IlZFvyHr5z+y+W14JqFI4aO/5yrZh5k
         H6LsoXM7eoK2Yn2hqlcdmHZrjj8zL/ZKYIwFcoUc=
Date:   Tue, 18 Jul 2023 11:11:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch added to mm-unstable branch
Message-Id: <20230718181101.48224C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: correct stale comment of rmap_walk_anon and rmap_walk_file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/rmap: correct stale comment of rmap_walk_anon and rmap_walk_file
Date: Tue, 18 Jul 2023 17:21:36 +0800

1. update page to folio in comment
2. add comment of new added @locked

Link: https://lkml.kernel.org/r/20230718092136.1935789-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file
+++ a/mm/rmap.c
@@ -2397,11 +2397,12 @@ out:
 /*
  * rmap_walk_anon - do something to anonymous page using the object-based
  * rmap method
- * @page: the page to be handled
+ * @folio: the folio to be handled
  * @rwc: control variable according to each walk type
+ * @locked: caller holds relevant rmap lock
  *
- * Find all the mappings of a page using the mapping pointer and the vma chains
- * contained in the anon_vma struct it points to.
+ * Find all the mappings of a folio using the mapping pointer and the vma
+ * chains contained in the anon_vma struct it points to.
  */
 static void rmap_walk_anon(struct folio *folio,
 		struct rmap_walk_control *rwc, bool locked)
@@ -2445,10 +2446,11 @@ static void rmap_walk_anon(struct folio
 
 /*
  * rmap_walk_file - do something to file page using the object-based rmap method
- * @page: the page to be handled
+ * @folio: the folio to be handled
  * @rwc: control variable according to each walk type
+ * @locked: caller holds relevant rmap lock
  *
- * Find all the mappings of a page using the mapping pointer and the vma chains
+ * Find all the mappings of a folio using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
  */
 static void rmap_walk_file(struct folio *folio,
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch
mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch

