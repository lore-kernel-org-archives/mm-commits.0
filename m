Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7A5C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B3596056B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347918AbhIBV6K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347609AbhIBV6K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086E560F12;
        Thu,  2 Sep 2021 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619831;
        bh=Fl0YsnghtRiidK9h4QnfztRysWxaJOTv5ETAX8kQ4Y4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uvhmSlvOcEocuOlOXODqPvfYPZg8p3EyAJT4PtOR/lFvfZIXGeIzt2Dp0L+nLyFdc
         cfIeXD4wiimpu1NwQifVFwjk06HVwY4O2sZPQ/X5d1QapDm9VJ3114mWQM8gJeHcE5
         HHTUdAdH5unwNg2mNgryTfOewpkxaedJkPN8uDOk=
Date:   Thu, 02 Sep 2021 14:57:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 135/212] include/linux/mmzone.h: avoid a warning
 in sparse memory support
Message-ID: <20210902215710.ckzHIoZ99%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Subject: include/linux/mmzone.h: avoid a warning in sparse memory support

cppcheck warns that we're possibly losing information by shifting an int. 
It's a false positive, because we don't allow for a NUMA node ID that
large, but if we ever change SECTION_NID_SHIFT, it could become a problem,
and in any case this is usually a legitimate warning.  Fix it by adding
the necessary cast, which makes the compiler generate the right code.

Link: https://lkml.kernel.org/r/YOya+aBZFFmC476e@casper.infradead.org
Link: https://lkml.kernel.org/r/202107130348.6LsVT9Nc-lkp@intel.com
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~avoid-a-warning-in-sparse-memory-support
+++ a/mm/sparse.c
@@ -117,7 +117,7 @@ static inline int sparse_index_init(unsi
  */
 static inline unsigned long sparse_encode_early_nid(int nid)
 {
-	return (nid << SECTION_NID_SHIFT);
+	return ((unsigned long)nid << SECTION_NID_SHIFT);
 }
 
 static inline int sparse_early_nid(struct mem_section *section)
_
