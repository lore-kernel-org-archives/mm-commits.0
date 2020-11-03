Return-Path: <SRS0=UcEf=EJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7B0C388F7
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC7DA22226
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604427430;
	bh=UpMcWYC/t+lBZFn1hqEH1XFZWHVwfPPExlLxC8mHsns=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=j/JMk/mSzjshMu57JJjb6MV/h4cFkHakrp+AF7X3rfdn0j8maeVHvIfkFhl7aZ1Cd
	 Ic1pA3aALX5hoPYUuWvCYZCzt0zvGM+Ee/iJOMO5VosbISrA6Xg0PS6t4JwqmwOJHk
	 V6+R022UngtlP1ZfVgejQ82VjvY3Ac/+H+Ivm07M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgKCSRK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgKCSRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 13:17:10 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 947BD207BB;
        Tue,  3 Nov 2020 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427429;
        bh=UpMcWYC/t+lBZFn1hqEH1XFZWHVwfPPExlLxC8mHsns=;
        h=Date:From:To:Subject:From;
        b=vCbRGgmdRCPG071bibtN8jNk8yICkkIcQsrd8oXXuEPo7jO6Avnmvh9VoBhha5u6e
         NTL50Oza/Yc/uzs4c6kMaCMHSzLWZ1QQIEjsgtFM12Ge3EFnU39qYgb2iPS2MBTqvC
         kruR5QwCm2ZfTR/mSAeizLIJSuhLsjyAmitBgLws=
Date:   Tue, 03 Nov 2020 10:17:09 -0800
From:   akpm@linux-foundation.org
To:     laoar.shao@gmail.com, mm-commits@vger.kernel.org,
        yanaijie@huawei.com
Subject:  [merged] mm-make-__invalidate_mapping_pages-static.patch
 removed from -mm tree
Message-ID: <20201103181709.l6KC_AjRE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate.c: make __invalidate_mapping_pages() static
has been removed from the -mm tree.  Its filename was
     mm-make-__invalidate_mapping_pages-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: mm/truncate.c: make __invalidate_mapping_pages() static

Fix the following sparse warning:

mm/truncate.c:531:15: warning: symbol '__invalidate_mapping_pages' was
not declared. Should it be static?

Link: https://lkml.kernel.org/r/20201015054808.2445904-1-yanaijie@huawei.com
Fixes: eb1d7a65f08a ("mm, fadvise: improve the expensive remote LRU cache draining after FADV_DONTNEED")
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/truncate.c~mm-make-__invalidate_mapping_pages-static
+++ a/mm/truncate.c
@@ -528,7 +528,7 @@ void truncate_inode_pages_final(struct a
 }
 EXPORT_SYMBOL(truncate_inode_pages_final);
 
-unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+static unsigned long __invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
 {
 	pgoff_t indices[PAGEVEC_SIZE];
_

Patches currently in -mm which might be from yanaijie@huawei.com are

lib-lzo-make-lzogeneric1x_1_compress-static.patch

