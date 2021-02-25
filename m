Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC38C4332E
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9891064F46
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhBYT2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhBYTZn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD9964F7A;
        Thu, 25 Feb 2021 19:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280512;
        bh=Bv8WL1SjKkAKi9B5fDZRvgbrlG1jsf28KhU3ghavasc=;
        h=Date:From:To:Subject:From;
        b=kKxoft+ZoqrNAOCSZeoSNuf3ZB9GUzU93iRt7CBVrlizDuPA0GLIfnNQGSZQolcpB
         7+G2VkfTpZgp0eWCTkbAMlOtccvraofl29zAwf3LwBn1XrRV2kvORJ03amQTg7+Gf/
         Yume283wMPX2MqP9ZH04YPu0lx6Q+YCRH9epGagA=
Date:   Thu, 25 Feb 2021 11:15:11 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        david@redhat.com, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  [merged]
 mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch
 removed from -mm tree
Message-ID: <20210225191511.5Ubu3PC4F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: use list_entry_is_head() in page_reporting_cycle()
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: sh <sh_def@163.com>
Subject: mm/page_reporting: use list_entry_is_head() in page_reporting_cycle()

Replace '&next->lru != list' with list_entry_is_head().  No functional
change.

Link: https://lkml.kernel.org/r/20201222182735.GA1257912@ubuntu-A520I-AC
Signed-off-by: sh <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle
+++ a/mm/page_reporting.c
@@ -211,7 +211,7 @@ page_reporting_cycle(struct page_reporti
 	}
 
 	/* Rotate any leftover pages to the head of the freelist */
-	if (&next->lru != list && !list_is_first(&next->lru, list))
+	if (!list_entry_is_head(next, list, lru) && !list_is_first(&next->lru, list))
 		list_rotate_to_front(&next->lru, list);
 
 	spin_unlock_irq(&zone->lock);
_

Patches currently in -mm which might be from sh_def@163.com are


