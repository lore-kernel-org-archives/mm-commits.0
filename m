Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246F9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02DF0207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195993;
	bh=KOj7YlmYA04XR1CjGlWvM1TVdip8pfZ2OD9ILjVTcFM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EOvwhLj2uj1IpJblHFtOag/CMHtED7FCwLv4cU/nA91TIYvBSkRykzDm5ERxcSTgk
	 ga5FIgX5ewjZySkU15XT+xQbLZm0c0g0vHm991aRcxE65yb1RCm2DLR9jlvg40aC+Y
	 jJj5MJssDOZdZOaUNAgLw7bPUBe3bkWinkAJ6src=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLBdM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B61206B2;
        Wed, 12 Aug 2020 01:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195991;
        bh=KOj7YlmYA04XR1CjGlWvM1TVdip8pfZ2OD9ILjVTcFM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ftjkafm9VZeFEl0WWLTgFKCbn87Y8tbnC9FT9UgBY3NlDHNO/Wl0O9PsuPS3Nw85E
         Wpeg/kxMFANf7TbS9wMzZ4/sa36VwQDP8L4R3ok9mesOrFA4MCwYYZYgTnKAb0rLbc
         QazxIM6SRwyD6yPtvnTuYTp96CwxrOV97gVMMGaI=
Date:   Tue, 11 Aug 2020 18:33:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 055/165] mm/nommu.c: delete duplicated words
Message-ID: <20200812013311.W99sh2GRR%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/nommu.c: delete duplicated words

Drop the repeated word "that" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-9-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~mm-nommuc-delete-duplicated-words
+++ a/mm/nommu.c
@@ -1762,8 +1762,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * @newsize: The proposed filesize of the inode
  *
  * Check the shared mappings on an inode on behalf of a shrinking truncate to
- * make sure that that any outstanding VMAs aren't broken and then shrink the
- * vm_regions that extend that beyond so that do_mmap() doesn't
+ * make sure that any outstanding VMAs aren't broken and then shrink the
+ * vm_regions that extend beyond so that do_mmap() doesn't
  * automatically grant mappings that are too large.
  */
 int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
_
