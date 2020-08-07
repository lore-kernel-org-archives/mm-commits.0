Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00041C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C269F22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781203;
	bh=UyXjNW6AyOGJvcaoAVH9fd3CR2zERdJZqy7geiMs9as=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hnm9+k9SS7pzTTQ15MpdnF4ocFF9+T5c7KzDBIEKdWhKYIu55LzTXfN/hFn9u1cut
	 w6EMxIFhyhWGncKHN1F+e9zT0mQ0HcY/Oy+mf/KLDZ2pBNfEDnayvVt2sVAeflvOrK
	 W9jdhLMcpEsNfbPF5OTW/vXqw1pdRMzMEuwHWGVg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgHGGUD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGUD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763E322CB3;
        Fri,  7 Aug 2020 06:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781202;
        bh=UyXjNW6AyOGJvcaoAVH9fd3CR2zERdJZqy7geiMs9as=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FRaI3u1pllaSXMO1cZthcjvH2XtwUaLbLwyq2ByScW0tguWP2TSiEhZzWBKRIh5tW
         zhmjQcJTl1hhaDTlRjaxZW2DDuGbziy5hV6uc03iugiOixKMVyZoLjWC3Qs/wi+lrI
         btTRmF7JzUItbP1UgvPAk6b6EFFEwoutKmPOMsEE=
Date:   Thu, 06 Aug 2020 23:20:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tangyizhou@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 053/163] mm/gup.c: fix the comment of return value
 for populate_vma_page_range()
Message-ID: <20200807062001.1NvKva6WQ%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm/gup.c: fix the comment of return value for populate_vma_page_range()

The return value of populate_vma_page_range() is consistent with
__get_user_pages(), and so is the function comment of return value.

Link: http://lkml.kernel.org/r/20200720034303.29920-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range
+++ a/mm/gup.c
@@ -1404,7 +1404,8 @@ retry:
  *
  * This takes care of mlocking the pages too if VM_LOCKED is set.
  *
- * return 0 on success, negative error code on error.
+ * Return either number of pages pinned in the vma, or a negative error
+ * code on error.
  *
  * vma->vm_mm->mmap_lock must be held.
  *
_
