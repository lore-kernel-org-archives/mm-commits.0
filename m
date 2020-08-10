Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3510C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A544D2065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027216;
	bh=j+q7vMvAYtUE8vOIsNYTLX9z6OAYmHXpg2tvogqjIsQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FA2TY09bre//Ap2ggzzkG4zYH4B629JMjIDfLeY/VxeW+W31cKXMMaow6eD+plD0K
	 J/DYIMk/RfazwR5724YWO7xtuJwShzsF5b1fAYEUyuQZbZ0N1BEDRfr7HhApSwJgQA
	 cGin3DoTKeUbihYSDO+Rk3OlSNMHNV10YrhzK+mY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJCkQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCkQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF9B206C3;
        Mon, 10 Aug 2020 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027214;
        bh=j+q7vMvAYtUE8vOIsNYTLX9z6OAYmHXpg2tvogqjIsQ=;
        h=Date:From:To:Subject:From;
        b=xNXUM/I/uGz2Mz3tgfeIU86zbtKmHoXjol4B0PlyKpJhIDCQjl62sXiIVJ7pjdekh
         ipmFUdCZ1Wzy+bLyLFBdA8K3oPQ6Ba3wzayIXjGT+StSttKFfRBJQeNG+Eq7ZvEJJf
         FZWZF5cCdRogIuHWuwYsY3WdcZBEbhTA63nxr7Kc=
Date:   Sun, 09 Aug 2020 19:40:14 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-page_alloc-fallbacks-at-most-has-3-elements.patch removed from -mm tree
Message-ID: <20200810024014.A94sUIjjS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fallbacks at most has 3 elements
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fallbacks-at-most-has-3-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


