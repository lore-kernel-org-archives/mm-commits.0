Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0685CC43467
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCF0D21D43
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489207;
	bh=9kSdiw0ny/FcrZvET4z9QLA/jBc+j0BQJerrEReSSQ0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=z2hhUuwIy2oLN6SLs7QalmhMzwnRc32LtkeBhegKYjyv8qU7Fc02HmArqerjP8ail
	 xHNNvGO4BvXcHFkVvYBWiBzJ0shARqedjlK5/6+2W/G1NNQEKfbNJy+mdFF74dprvZ
	 bfwTUVUTrtZxExBov332Cx3/+tB5i5kS/UwGuPg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgISEUH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7CB8221EC;
        Sat, 19 Sep 2020 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489207;
        bh=9kSdiw0ny/FcrZvET4z9QLA/jBc+j0BQJerrEReSSQ0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o7JuTSw1F55slcFCR6DKOUGAZnSSLh0FG81XgVaa4K5/1g4w9Kpm6Go1LavUU/2DE
         ydSgwDYdAD0gL/GLH9GRO1NecmV6RG+wnfvTRCP++zdlyWoaRK/ajdQrrk/Q3ZTwQH
         CPH2gPPvqk2tteUKgJwKOqKba0GuD0HGnGMuCekc=
Date:   Fri, 18 Sep 2020 21:20:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cai@lca.pw,
        hannes@cmpxch.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 03/15] mm: migration of hugetlbfs page skip memcg
Message-ID: <20200919042006.EMz72lT2P%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
