Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69562C4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2002721D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633201;
	bh=cn6ldKR3IkPtdx/kbbylkZ5qtcUPa+GUE3iMpq1iYM4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZyUZQuOzaLqzD59rWQU5HuLwcPOIEyJNl7nJ5Bs3oWOD+s7QMeLlXzPChQJE3kghD
	 rO+ih06ZXAKCg5cpGmJuLf4iZT+HuS44c4nCe6/t0vcON6GG27I7iSscLw9TGhuSXN
	 fq1ZpVRFRGv9GZMXY6FcoxOlGXkKq/9/5s8FlEO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgJMXxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729286AbgJMXxD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12263208B3;
        Tue, 13 Oct 2020 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633183;
        bh=cn6ldKR3IkPtdx/kbbylkZ5qtcUPa+GUE3iMpq1iYM4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EyqesZDlHyxvsgn5S5q5X7Ri8pv0H+U/9dJOslqsZvKfqw9Yi0SsVXpzw7ZP33+6D
         XyjkZXhwGV6rT3yYhNEakcgEnt5iwVJDy2Gh5SanSKmRm+Mqd9Iy5PFyK6pl28iEZU
         pOcKfjbIOWLrG4q0nJS5srmWc2wvuDFSpkgEvZw0=
Date:   Tue, 13 Oct 2020 16:53:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 086/181] mm/page_counter: correct the obsolete
 func name in the comment of page_counter_try_charge()
Message-ID: <20201013235302.UqOg1QVL0%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_counter: correct the obsolete func name in the comment of page_counter_try_charge()

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), page_counter_limit() is renamed to page_counter_set_max().
So replace page_counter_limit with page_counter_set_max in comment.

Link: https://lkml.kernel.org/r/20200917113629.14382-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge
+++ a/mm/page_counter.c
@@ -109,7 +109,7 @@ bool page_counter_try_charge(struct page
 		 *
 		 * The atomic_long_add_return() implies a full memory
 		 * barrier between incrementing the count and reading
-		 * the limit.  When racing with page_counter_limit(),
+		 * the limit.  When racing with page_counter_set_max(),
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
_
