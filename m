Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE043C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiK3XlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK3XlY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:41:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DC44AF03
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:41:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F9B2CE1B76
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DB9C43470;
        Wed, 30 Nov 2022 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851679;
        bh=Mvrzu3jzq3PHRCvOPgmbSfehZZ3Zs2JAMoPGt/OoPrc=;
        h=Date:To:From:Subject:From;
        b=Sr2Ecyknp0+BY/I/5l2+uCIub1OUiWgIztPr5t/JSjNOiXC26aqIhEjmJOqCdLpVG
         W4xn1peuHwMw+OFl2h2bNBEbtyrBXNVr8gv7fI6yDE6M4DG8IULJwwyNUQibleyH3a
         qtMyn6Jwf3tH2GlUln83NbhBM53BhZn+Nf6MMOnc=
Date:   Wed, 30 Nov 2022 15:41:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        sfr@canb.auug.org.au, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch removed from -mm tree
Message-Id: <20221130234119.87DB9C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-convert-move_hugetlb_state-to-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch

This patch was dropped because it was folded into mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-convert-move_hugetlb_state-to-folios-fix
Date: Wed Nov  2 02:25:07 PM PDT 2022

fix CONFIG_HUGETLB_PAGE=n build

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-move_hugetlb_state-to-folios-fix
+++ a/include/linux/hugetlb.h
@@ -991,6 +991,11 @@ void hugetlb_unregister_node(struct node
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+{
+	return NULL;
+}
+
 static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-convert-move_hugetlb_state-to-folios.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

