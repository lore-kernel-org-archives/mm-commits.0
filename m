Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72940C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2097C2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633396;
	bh=M3tfkc7yQuQqJPmPRhOUVyUtFmgPxzB4EpvcwYwdpQY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=L03hOH5hvHCgfBsfTJevXIZ9RI0Epg8reMQGJlscC8UVU1aE/TKV1kfdE4u6OE4M/
	 8xzh4wJsb41aguNyFqKm7LyTJqMSxrZG4GcL5Lvk0mxwWvwlqQAq/oYTTD+uygjr89
	 MRFTzfza9sSpJbyxRwepS+FNg8fkvT1JX2n5gAZ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgJMX4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A90FD2222F;
        Tue, 13 Oct 2020 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633394;
        bh=M3tfkc7yQuQqJPmPRhOUVyUtFmgPxzB4EpvcwYwdpQY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bq5UmpcFhSFF1AUdq9AvcKoxCmo9blCBt2kf7WHqmepNxhD5iqWTi2jIdTVJ023z3
         bO/kL+76cCn1bZ0tC2Yw5DWIOZlWBAju0n0TIdoFLCkDgSZDxMaawsylSamqI2gzA9
         vZmeefAsWGVEi7BrMypGg06M+YBNY2S3fgS+R2JE=
Date:   Tue, 13 Oct 2020 16:56:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 148/181] mm/hugetlb: a page from buddy is not on
 any list
Message-ID: <20201013235633.ZilQoOIiU%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: a page from buddy is not on any list

The page allocated from buddy is not on any list, so just use list_add()
is enough.

Link: https://lkml.kernel.org/r/20200831022351.20916-6-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-a-page-from-buddy-is-not-on-any-list
+++ a/mm/hugetlb.c
@@ -2416,7 +2416,7 @@ struct page *alloc_huge_page(struct vm_a
 			h->resv_huge_pages--;
 		}
 		spin_lock(&hugetlb_lock);
-		list_move(&page->lru, &h->hugepage_activelist);
+		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
_
