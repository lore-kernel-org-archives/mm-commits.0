Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AB4C00528
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjGXRnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjGXRnr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EADD170D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A1B561320
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20B2C433C8;
        Mon, 24 Jul 2023 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220621;
        bh=+VRLkEYWp6fl+Jllx6EBpz5xHKaW1+4/LxklWuh2Q0A=;
        h=Date:To:From:Subject:From;
        b=j4VfBgPifZYcbh5BMGhbT9oIeVGYhZCNqiNzIRlbSItEe6Grv1AoeI+7jMPYelx0y
         fCaOPRgD2VmzswndDiilD0nyikyFKzWuZnRqKOr2fiBt43UxlPsVu69aUJG7MFFCxw
         jfQ960oQ1To7qRIukLzuOfRHTldR4dL/DANlPj5s=
Date:   Mon, 24 Jul 2023 10:43:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-introduce-bio_first_folio_all.patch added to mm-unstable branch
Message-Id: <20230724174341.A20B2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: introduce bio_first_folio_all()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-introduce-bio_first_folio_all.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-introduce-bio_first_folio_all.patch

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

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch

