Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0A6C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A51206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027204;
	bh=mrCCpbHVWz+rUSwCcAsZ1mcs8lAgFoeDvEp4eBMAGqY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=H4L7l7E1/kW3jo8cG4eKmB527cXwekSJCnOfK8dida1j7sfoF+kYnvQnCwPYvDEXw
	 a8SL7bXxVT7aaBiwA2H9WvVi9DeP/7GONonRBeB3j6/91T2w8U2NqIeMoTwlGxHxcr
	 hudltjsTFQclwsgF7Wl9ltEY+a4NRB0Eode9ZABw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHJCkE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJCkE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FF1A206C3;
        Mon, 10 Aug 2020 02:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027202;
        bh=mrCCpbHVWz+rUSwCcAsZ1mcs8lAgFoeDvEp4eBMAGqY=;
        h=Date:From:To:Subject:From;
        b=D32ScesZKfQ6heymE8Dj7Aw6wg04KWV3Auf8Ec3E7ON3sScGm69F+OeaR5p284WdJ
         oTF9qy9HzM4ZgIEDRsHDX6fOMeaGX4C3mZvNoNeYh5qqLjNwRsTdWf8GIRotNcbrx/
         6SFhLmyGrYiZ6/3zQV66lnOLI8QG1cNpksM1UtyU=
Date:   Sun, 09 Aug 2020 19:40:02 -0700
From:   akpm@linux-foundation.org
To:     mgorman@suse.de, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Fallocc-replace-the-definition-of-nr=5Fmigratetype?=
 =?US-ASCII?Q?=5Fbits-with-pb=5Fmigratetype=5Fbits.patch?= removed from -mm
 tree
Message-ID: <20200810024002.u0a25JncT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: replace the definition of NR_MIGRATETYPE_BITS with PB_migratetype_bits
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc.c: replace the definition of NR_MIGRATETYPE_BITS with PB_migratetype_bits

We already have the definition of PB_migratetype_bits and current
NR_MIGRATETYPE_BITS looks like a cyclic definition.

Just use PB_migratetype_bits is enough.

Link: http://lkml.kernel.org/r/20200623124201.8199-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits
+++ a/include/linux/mmzone.h
@@ -88,8 +88,7 @@ static inline bool is_migrate_movable(in
 
 extern int page_group_by_mobility_disabled;
 
-#define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
-#define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
+#define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
 
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


