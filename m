Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33130C63703
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 23:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiLGXQX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Dec 2022 18:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiLGXQV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2022 18:16:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698484DE8
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 15:16:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C378761CEB
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 23:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8BEC433D6;
        Wed,  7 Dec 2022 23:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670454979;
        bh=zBTvtSfYpKoN4GoZT1k12kUBaI5G3jqkd8QHpgx5NkY=;
        h=Date:To:From:Subject:From;
        b=eZT3QLZEJvACIIbbrSUxz353k66Po+JH/Zo72qJPY9Td2inHezy5B671iUVM9dlUC
         bs97TiyLbzfu+0JPEKJLwwJXJzK1Ubhuc0Ts7nrAuK11fm9pfH2U6cGYFSe8qKsTew
         FtgdrsEcSxtFV6tsnFG4RQjqDeanR9krScmh/gmY=
Date:   Wed, 07 Dec 2022 15:16:18 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio-dtor-and-order-setter-functions-fix.patch added to mm-unstable branch
Message-Id: <20221207231619.1F8BEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify folio_set_compound_order() zero support
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio-dtor-and-order-setter-functions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio-dtor-and-order-setter-functions-fix.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: clarify folio_set_compound_order() zero support
Date: Wed, 7 Dec 2022 14:37:31 -0800

Document hugetlb's use of a zero compound order so support for zero
orders is not removed from folio_set_compound_order().

Link: https://lkml.kernel.org/r/20221207223731.32784-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-add-folio-dtor-and-order-setter-functions-fix
+++ a/include/linux/mm.h
@@ -1019,9 +1019,16 @@ static inline void set_compound_order(st
 #endif
 }
 
+/*
+ * folio_set_compound_order is generally passed a non-zero order to
+ * initialize a large folio.  However, hugetlb code abuses this by
+ * passing in zero when 'dissolving' a large folio.
+ */
 static inline void folio_set_compound_order(struct folio *folio,
 		unsigned int order)
 {
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+
 	folio->_folio_order = order;
 #ifdef CONFIG_64BIT
 	folio->_folio_nr_pages = order ? 1U << order : 0;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-add-folio-dtor-and-order-setter-functions.patch
mm-add-folio-dtor-and-order-setter-functions-fix.patch
mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch
mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch
mm-hugetlb-convert-update_and_free_page-to-folios.patch
mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch
mm-hugetlb-convert-enqueue_huge_page-to-folios.patch
mm-hugetlb-convert-free_gigantic_page-to-folios.patch
mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch

