Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F044C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9F4206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195866;
	bh=VEFuo+QcLns7ijUEBUgF4cE9HvW4N1iVBqbWjsNuqC4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eTKZgUdYJ1oVzd2FMPIcLSw27BM69/chNrfE7Nz8SiY7UNbGly3vsPPZhrEgYs15K
	 7VJAWSGqh69RGxYyE67QuN3d32sTJCHVDylqOWJaCzMdTPZdAtADDlPQsQGaQyUEd8
	 /09/7RGzBAxxtbOGOYwWHYSWYviB4iHLjIzVQYiQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHLBbF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBbF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCDB4207DA;
        Wed, 12 Aug 2020 01:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195865;
        bh=VEFuo+QcLns7ijUEBUgF4cE9HvW4N1iVBqbWjsNuqC4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JeRDlctwZtcDVkhinTwvYDCjw5kfqIVsQiee/O2kx1NXVbxzAuWGyPzKfhIEJP4Vl
         ak7j6O7IqZxRgAB1woZOeifB/kfIRPZ7iIRO6O1IhmeGfa1hLk9iE/2F4a4peZhTyK
         vCsju6Ih6gGFlAKKE0jdHhT+hmbKzYe2UzoPFWk4=
Date:   Tue, 11 Aug 2020 18:31:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        nigupta@nvidia.com, sfr@canb.auug.org.au,
        torvalds@linux-foundation.org
Subject:  [patch 015/165] mm: fix compile error due to
 COMPACTION_HPAGE_ORDER
Message-ID: <20200812013104.IdR0EvZTT%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nitin Gupta <nigupta@nvidia.com>
Subject: mm: fix compile error due to COMPACTION_HPAGE_ORDER

Fix compile error when COMPACTION_HPAGE_ORDER is assigned to
HUGETLB_PAGE_ORDER.  The correct way to check if this constant is defined
is to check for CONFIG_HUGETLBFS.

Link: http://lkml.kernel.org/r/20200623064544.25766-1-nigupta@nvidia.com
Signed-off-by: Nitin Gupta <nigupta@nvidia.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-proactive-compaction-fix
+++ a/mm/compaction.c
@@ -62,7 +62,7 @@ static const int HPAGE_FRAG_CHECK_INTERV
  */
 #if defined CONFIG_TRANSPARENT_HUGEPAGE
 #define COMPACTION_HPAGE_ORDER	HPAGE_PMD_ORDER
-#elif defined HUGETLB_PAGE_ORDER
+#elif defined CONFIG_HUGETLBFS
 #define COMPACTION_HPAGE_ORDER	HUGETLB_PAGE_ORDER
 #else
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
_
