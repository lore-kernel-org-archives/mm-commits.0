Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFE2C4727E
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8AFA20BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085477;
	bh=L3UyT7YvO23fYozf7OOQh6TgT5SD2NtXNafepjlq5eU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nvb5zmmDRcBrLcsR9625O2RBNAl6lzHJfEwXNjg9b2o0mzIZkBaRsspOYVIpha5b6
	 gaUBnPDXJMttMEZit2eNOZGkYy8qkb6e2F8DafRXkjOuxibDhmJG8+Qc0ZI4omlDhv
	 oxq3qkecEDQkqsbqua2ApS2CQgvrMdkc5zC3S9zo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgIZB55 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729943AbgIZB55 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:57:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FD592087D;
        Sat, 26 Sep 2020 01:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085476;
        bh=L3UyT7YvO23fYozf7OOQh6TgT5SD2NtXNafepjlq5eU=;
        h=Date:From:To:Subject:From;
        b=LTbcKuVIXbKyxWWSH/4buUzPh9b1DslOI5+cc6nZjJcF5W0pRny5n7IWU2pNBhjHS
         Q1GA+RwQShD4P5WxuLzdEurTYX4KYe/vvMvEKoyJ+S22HJE00V2OI6PFwwDoJRgbek
         GIoOZQbeqhSDKzyt6f9+ExATIozbr4UJ4a/iCSHI=
Date:   Fri, 25 Sep 2020 18:57:56 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxch.org,
        hughd@google.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] mm-migration-of-hugetlbfs-page-skip-memcg.patch
 removed from -mm tree
Message-ID: <20200926015756.RNmt5patw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migration of hugetlbfs page skip memcg
has been removed from the -mm tree.  Its filename was
     mm-migration-of-hugetlbfs-page-skip-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: migration of hugetlbfs page skip memcg

hugetlbfs pages do not participate in memcg: so although they do find most
of migrate_page_states() useful, it would be better if they did not call
into mem_cgroup_migrate() - where Qian Cai reported that LTP's
move_pages12 triggers the warning in Alex Shi's prospective commit
"mm/memcg: warning on !memcg after readahead page charged".

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301359460.5954@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxch.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migration-of-hugetlbfs-page-skip-memcg
+++ a/mm/migrate.c
@@ -668,7 +668,8 @@ void migrate_page_states(struct page *ne
 
 	copy_page_owner(page, newpage);
 
-	mem_cgroup_migrate(page, newpage);
+	if (!PageHuge(page))
+		mem_cgroup_migrate(page, newpage);
 }
 EXPORT_SYMBOL(migrate_page_states);
 
_

Patches currently in -mm which might be from hughd@google.com are


