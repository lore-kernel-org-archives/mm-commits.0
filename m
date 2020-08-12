Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE17C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E083A207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195989;
	bh=cM7BRIFnO/4j5iuDNEt4mh/rCie9k/UdbyF+dHq8984=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=njStaTrAp3AYRdP8PkM8+HHkzRcyr4775+EdkY7zFZ2Xeh4YADR2DsBL1P9qUAuJ4
	 idBEqhlRz8UdYtsqG0itwQEPdLdt4mVU2LUJdfjnTzTiamUbdIP0JdiCV67rFe1KBH
	 comGtfENMWI81TvL2tQZI0AWHD1MImximvDVG04M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLBdJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81931206B2;
        Wed, 12 Aug 2020 01:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195988;
        bh=cM7BRIFnO/4j5iuDNEt4mh/rCie9k/UdbyF+dHq8984=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E9uhw8blvPnd8YweAGbpqAESaT5Qt7Ulq6gki6IDeFLqMhC1Wk6kHynblfpm8NAXB
         El24F1lILtX3LRY0v/uYJZ7o3qStPOSwSxA8hwlaJ0XCoQSYqNLCCH5wiicMVKZXjq
         G/BAE9d6olQaYCSbMj+5wqmyoY5id5bQSAvN840c=
Date:   Tue, 11 Aug 2020 18:33:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 054/165] mm/migrate.c: delete duplicated word
Message-ID: <20200812013308.uxZ0O9Dbo%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate.c: delete duplicated word

Drop the repeated word "and".

Link: http://lkml.kernel.org/r/20200801173822.14973-8-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migratec-delete-duplicated-word
+++ a/mm/migrate.c
@@ -2667,7 +2667,7 @@ restore:
 
 /**
  * migrate_vma_setup() - prepare to migrate a range of memory
- * @args: contains the vma, start, and and pfns arrays for the migration
+ * @args: contains the vma, start, and pfns arrays for the migration
  *
  * Returns: negative errno on failures, 0 when 0 or more pages were migrated
  * without an error.
_
