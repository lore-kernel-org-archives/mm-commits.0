Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B99C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8982B61421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhEEBiD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhEEBiD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C56161029;
        Wed,  5 May 2021 01:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178627;
        bh=JsXt/oEnuWO06m9rmttQFdXYOuUJ+A2RloWwahDrc0I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wQ+ZanBX3xM9S5zg3NhwBOtWLDfODNzWpATRghNHtMebnZ0fBo+5mkMTbWZt74ilE
         9xQp/0dzTPkMM4CCcLBQYnos8iZ9ToyPypAhTnw6X2VYisgomVGN/Vv78wxnE96wGP
         k9EFQB/qEwJvuAW7xYFKxmLH4yZux4fpUfRYw9ks=
Date:   Tue, 04 May 2021 18:37:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, aquini@redhat.com,
        david@redhat.com, jglisse@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 081/143] mm/migrate.c: remove unnecessary rc !=
 MIGRATEPAGE_SUCCESS check in 'else' case
Message-ID: <20210505013707.ONwtTzwP8%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate.c: remove unnecessary rc != MIGRATEPAGE_SUCCESS check in 'else' case

It's guaranteed that in the 'else' case of the rc == MIGRATEPAGE_SUCCESS
check, rc does not equal to MIGRATEPAGE_SUCCESS.  Remove this unnecessary
check.

Link: https://lkml.kernel.org/r/20210325131524.48181-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case
+++ a/mm/migrate.c
@@ -1348,7 +1348,7 @@ out_unlock:
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
 		putback_active_hugepage(hpage);
-	else if (rc != -EAGAIN && rc != MIGRATEPAGE_SUCCESS)
+	else if (rc != -EAGAIN)
 		list_move_tail(&hpage->lru, ret);
 
 	/*
_
