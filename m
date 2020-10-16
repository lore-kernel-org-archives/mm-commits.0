Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B5BC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8805220E65
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816405;
	bh=cn5yultem/+6mHypbbQ8ih+AQKc065J7TXIe6Lvy4/M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=stdvPY6Dh+D8trcfGfFRp4PtVv8ixl9h13ghUsDQVS4GD4eOOKvWchbJXEkQCsxiX
	 yWqeoW+S+iGmoIGF0S0AmxdUZ41qns9d0f+MLpDJLVTxMOeM9lYJ07htWhXxCc3JDH
	 4xjJzpxgX2LjJ3msis+2oR3Ezi1OvLgpX1hc4JBc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404334AbgJPCqp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404325AbgJPCqp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27B1420B1F;
        Fri, 16 Oct 2020 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816404;
        bh=cn5yultem/+6mHypbbQ8ih+AQKc065J7TXIe6Lvy4/M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fS5bg2+AH/0CFmLdA63YA3H9qR5egLleYOv3d/SyqTaWTXhv4OtJbwecTEUgcVJOh
         aou32v2JLWD1xVN5So4+fQS0WCzcdKjEc2NQkyRvy6TvOBc3jNkMmYkhi0UbdOghRK
         unCIcQbzt/n1w48XGyWzFKNSH0cnUJvB+NeTA2nM=
Date:   Thu, 15 Oct 2020 19:46:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org
Subject:  [patch 086/156] mm/page_reporting.c: drop stale list head
 check in page_reporting_cycle
Message-ID: <20201016024643.FeJGBXKYo%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_reporting.c: drop stale list head check in page_reporting_cycle

list_for_each_entry_safe() guarantees that we will never stumble over the
list head; "&page->lru != list" will always evaluate to true.  Let's
simplify.

[david@redhat.com: Changelog refinements]
Link: http://lkml.kernel.org/r/20200818084448.33969-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle
+++ a/mm/page_reporting.c
@@ -178,7 +178,7 @@ page_reporting_cycle(struct page_reporti
 		 * the new head of the free list before we release the
 		 * zone lock.
 		 */
-		if (&page->lru != list && !list_is_first(&page->lru, list))
+		if (!list_is_first(&page->lru, list))
 			list_rotate_to_front(&page->lru, list);
 
 		/* release lock before waiting on report processing */
_
