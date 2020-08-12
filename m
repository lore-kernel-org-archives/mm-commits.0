Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6976C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5ADE2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196004;
	bh=wqXVTt4O0KzG/w/ZUyl1OuzUY8n5UjdKJEUZ0SYR1uY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=o9F1s/zZV9I3bdZNmDl5zbAq3iBDsryDGulLQwdsRUTIP4ebYzRKFgS9sd7RFqmvt
	 w1EC73f/Pfsbq/wGLAXp+emJxGowo7VY6rXyBZthhA1nETcXJYciV+AqJahsDarvOj
	 xQpyZmgqD6otoxUpIItvhzr+3ltl84ESmILZB0nI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHLBdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgHLBdY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75CB1206B2;
        Wed, 12 Aug 2020 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196003;
        bh=wqXVTt4O0KzG/w/ZUyl1OuzUY8n5UjdKJEUZ0SYR1uY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PWTwvIPx/T+7iMGqwRoCr5QQKul+OWkqeOX2ZQxKAD1LlWa6pu35v5VF5IqnKU4Ec
         ppeDZlR4iAmVmo5Viei+ML0D3lHdxwUgXch00AJJh9N2XfW+5hx5t0W6KvodqoIPH4
         XbN1rrC1YdVuOX1H2pkhDXoQIT8P8p0ptwyX1fhI=
Date:   Tue, 11 Aug 2020 18:33:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 059/165] mm/usercopy.c: delete duplicated word
Message-ID: <20200812013323.J0V95e5Ge%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/usercopy.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-13-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/usercopy.c~mm-usercopyc-delete-duplicated-word
+++ a/mm/usercopy.c
@@ -43,7 +43,7 @@ static noinline int check_stack_object(c
 
 	/*
 	 * Reject: object partially overlaps the stack (passing the
-	 * the check above means at least one end is within the stack,
+	 * check above means at least one end is within the stack,
 	 * so if this check fails, the other end is outside the stack).
 	 */
 	if (obj < stack || stackend < obj + len)
_
