Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F44C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB06D22D07
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781559;
	bh=B4u3/7m1qpu/zy/YSXhr99cRUqeBVHYzNXa4WKkkhVc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YzhG9ZZphFCouNJkYfJGFDXstKhS565TFzi1i9Xh7OgAC5zwuGz6wPlUNI7M8dy4U
	 hIJuQpQsLnhYWPF67Ln2lblN43wGhJu+2MmdTvnTjJoGkeUVCiiK/ZOnaj9DR7Ej77
	 arDjEvDUbjG4HoZuTLbDa9EgpexTmV3mcop4JIcI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGZ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E2E22CAE;
        Fri,  7 Aug 2020 06:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781558;
        bh=B4u3/7m1qpu/zy/YSXhr99cRUqeBVHYzNXa4WKkkhVc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o0rRsH6KomA914+cYqJPMMOWJfmLNTZvMKHQ3c4KeInU3m8FU+/aI4uDxG1kVMsDN
         l/hug2uGm7mobwBYR/82MshhjR5c+5+rLU5LGCFjL7nVtOwew24G8Y/SkDQur6ldlU
         34smeS6DFOgKTFkFzfO7/wXyQ3bSGtdoMVlj8zY0=
Date:   Thu, 06 Aug 2020 23:25:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 153/163] mm/page_alloc: fallbacks at most has 3
 elements
Message-ID: <20200807062558.ui4uGHaCT%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc: fallbacks at most has 3 elements

MIGRAGE_TYPES is used to be the mark of end and there are at most 3
elements for the one dimension array.

Reduce to 3 to save little memory.

Link: http://lkml.kernel.org/r/20200625231022.18784-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fallbacks-at-most-has-3-elements
+++ a/mm/page_alloc.c
@@ -2268,7 +2268,7 @@ struct page *__rmqueue_smallest(struct z
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
  */
-static int fallbacks[MIGRATE_TYPES][4] = {
+static int fallbacks[MIGRATE_TYPES][3] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_TYPES },
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_TYPES },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_TYPES },
_
