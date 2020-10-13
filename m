Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC187C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B4BC2222C
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633201;
	bh=s7cBj952iZ9HnlM+Kp5IpiM4BHvzSRRw+HhFaK6RcwI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=q+K/LRg8BJtonqoFoDk+M7MTf2PG8hnjX2uG22oPzVIb+X91VoJflgR5K+fKbG4SV
	 X3whQYesrA3kyt4Aut7w656xukGM9UsbtxgUa5nbg/8adR/AbPaPfZQpgfDL7vqA5n
	 JAosN4Sy2GySrLOqHM4P7xqcOQXaL7nlgUWaZd2U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgJMXxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbgJMXxO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C72206D5;
        Tue, 13 Oct 2020 23:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633194;
        bh=s7cBj952iZ9HnlM+Kp5IpiM4BHvzSRRw+HhFaK6RcwI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KzMn5UTwtG5+5HTo09ZXobz+dQqWAa96TLunafkdiDBqePnBMZaHx/jyy8HqRqFRx
         RzZbJPZiIk1QU20vaZHUYAjqwXpLmvWOHcmdM/NmWpwVZI9w+NdXy+AZ4CATWVYxFt
         J8KlC7vhe6aRcaO1fJ+G3KlHv22IKs14bqC3pNTQ=
Date:   Tue, 13 Oct 2020 16:53:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bsingharora@gmail.com,
        hannes@cmpxchg.org, ira.weiny@intel.com, jglisse@redhat.com,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 089/181] mm/memcg: fix device private memcg
 accounting
Message-ID: <20201013235313.DeYBVw6YC%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/memcg: fix device private memcg accounting

The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
NULL before checking is_device_private_entry() so device private pages are
never handled.  Fix this by checking for non_swap_entry() after handling
device private swap PTEs.

I assume the memory cgroup accounting would be off somehow when moving
a process to another memory cgroup.  Currently, the device private page
is charged like a normal anonymous page when allocated and is uncharged
when the page is freed so I think that path is OK.

Link: https://lkml.kernel.org/r/20201009215952.2726-1-rcampbell@nvidia.com
xFixes: c733a82874a7 ("mm/memcontrol: support MEMORY_DEVICE_PRIVATE")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-device-private-memcg-accounting
+++ a/mm/memcontrol.c
@@ -5516,7 +5516,7 @@ static struct page *mc_handle_swap_pte(s
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
 
 	/*
@@ -5535,6 +5535,9 @@ static struct page *mc_handle_swap_pte(s
 		return page;
 	}
 
+	if (non_swap_entry(ent))
+		return NULL;
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
_
