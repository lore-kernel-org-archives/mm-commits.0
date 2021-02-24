Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA920C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB5C64E60
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbhBXUJx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235298AbhBXUJa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5434A64F20;
        Wed, 24 Feb 2021 20:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197328;
        bh=787urpnHfsBgwCqx+7n1DXo2pCIOdY7aT9xYWCKKemQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k3OOA/kGtXegfeV6+K0cAAaTqzkUK9YMGAoHfdagwXjJ/upZge71dn2m88bciVnLi
         qEQvDtOPsMQDVk677wh7zM+j8Gwe7YvwB9QII+iqzi/Hw1rD3wxMJsNmbgli8dxNNj
         CdLG57fMLdzZPWM0DBmAUDQSi8WcAjjlb62mTSpI=
Date:   Wed, 24 Feb 2021 12:08:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 145/173] mm: workingset: clarify eviction order
 and distance calculation
Message-ID: <20210224200847.MgJboFbIP%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm: workingset: clarify eviction order and distance calculation

The premise of the refault distance is that it can be seen as a deficit of
the inactive list space, so that if the inactive list would have had (R -
E) more slots, the page would not have been evicted but promoted to the
active list instead.

However, the way the code is ordered right now set us to be off by one, so
the real number of slots would be (R - E) + 1.  I stumbled upon this when
trying to understand the code and it puzzled me that the comments did not
match what the code did.

This it not an issue at all since evictions and refaults tend to happen in
a number large enough that being off-by-one does not have any impact - and
since the compiler and CPUs are free to rearrange the execution sequence
anyway.

But as Johannes says, it is better to re-arrange the code in the proper
order since otherwise would be misleading to somebody who is actively
reading and trying to understand the logic of the code - like it happened
to me.

Link: https://lkml.kernel.org/r/20210201060651.3781-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-workingset-clarify-eviction-order-and-distance-calculation
+++ a/mm/workingset.c
@@ -263,10 +263,10 @@ void *workingset_eviction(struct page *p
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 	return pack_shadow(memcgid, pgdat, eviction, PageWorkingset(page));
 }
 
_
