Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1C6C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 00:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiLLAHX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 19:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLAHW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 19:07:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FCE766F
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 16:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9044C60CEC
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 00:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4681C433D2;
        Mon, 12 Dec 2022 00:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670803640;
        bh=GpD7Db2FZL0b9yYJ9IFN4rkC3il8YCK/8SEPCtFVbFw=;
        h=Date:To:From:Subject:From;
        b=MikUuPA9SlEmK0tojleqXnE0Vuk9JCF/IPKzzhsmVTEbmup49kRDwpXy5jmMu1RUL
         Y5jWJVTJQloZMdI3+TtHEjmud654ad11g7n3gQ0ny7PO/5BCLA04BnoaZCqkeE/emO
         evPZ16zoNAKYvzhOrm/niS5zvYLQuy3eWF2DR6sI=
Date:   Sun, 11 Dec 2022 16:07:19 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-folio-dtor-and-order-setter-functions-fix.patch removed from -mm tree
Message-Id: <20221212000719.E4681C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: clarify folio_set_compound_order() zero support
has been removed from the -mm tree.  Its filename was
     mm-add-folio-dtor-and-order-setter-functions-fix.patch

This patch was dropped because it was folded into mm-add-folio-dtor-and-order-setter-functions.patch

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

 include/linux/mm.h |    7 +++++++
 1 file changed, 7 insertions(+)

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

