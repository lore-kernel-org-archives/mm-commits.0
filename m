Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84ADFC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbjHKXOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF83D44BD
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBCE67ADC
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F49C433C7;
        Fri, 11 Aug 2023 23:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794948;
        bh=NS4wvOGzRpMebICRNw3j5dwN1CoHMuhDSoKFXcyMS/s=;
        h=Date:To:From:Subject:From;
        b=mbkkKfFr9sV3lePSdprVPHY0Qb9QWHSoLc+3YkEvxlkpaCDzlx+FpU5M+fGHyJaGp
         gmDX2FIZoHAcVGvaue4A9lPosUR9vkebXFNNEAhz+RRF8KNogoD/TB/oQAtbJiUqqf
         netmrpR1fE+YTxSNOZGO+UYGzZtjfz4acQ9ITHzw=
Date:   Fri, 11 Aug 2023 16:02:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-introduce-bio_first_folio_all.patch removed from -mm tree
Message-Id: <20230811230227.E4F49C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: introduce bio_first_folio_all()
has been removed from the -mm tree.  Its filename was
     mm-page_io-introduce-bio_first_folio_all.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: introduce bio_first_folio_all()
Date: Fri, 21 Jul 2023 11:44:44 +0800

Introduce bio_first_folio_all() to return a folio, which makes it easier
to use.

Link: https://lkml.kernel.org/r/20230721034451.16412-4-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/biovecs.rst |    1 +
 include/linux/bio.h             |    5 +++++
 2 files changed, 6 insertions(+)

--- a/Documentation/block/biovecs.rst~mm-page_io-introduce-bio_first_folio_all
+++ a/Documentation/block/biovecs.rst
@@ -134,6 +134,7 @@ Usage of helpers:
 	bio_for_each_bvec_all()
 	bio_first_bvec_all()
 	bio_first_page_all()
+	bio_first_folio_all()
 	bio_last_bvec_all()
 
 * The following helpers iterate over single-page segment. The passed 'struct
--- a/include/linux/bio.h~mm-page_io-introduce-bio_first_folio_all
+++ a/include/linux/bio.h
@@ -253,6 +253,11 @@ static inline struct page *bio_first_pag
 	return bio_first_bvec_all(bio)->bv_page;
 }
 
+static inline struct folio *bio_first_folio_all(struct bio *bio)
+{
+	return page_folio(bio_first_page_all(bio));
+}
+
 static inline struct bio_vec *bio_last_bvec_all(struct bio *bio)
 {
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

