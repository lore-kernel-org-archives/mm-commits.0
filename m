Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC0BC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D701264ECB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhBAXoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhBAXoN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:44:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B942F60235;
        Mon,  1 Feb 2021 23:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223012;
        bh=XTYUY6Fb9yp2JC9FNsjKVqgZrZ8X4uibpEtd7o5INY8=;
        h=Date:From:To:Subject:From;
        b=Mmjp6KPlZPrrzeYFt2JSbEiwAsuE0xh7ZZq8g0Tmk5h4ir3EZPWNGdGrU588G+TqX
         i17B76xCEnIi31jvUKro04PAKzaUMvrH6Sggp3H0mzqnHQqwxjZkzLw0Uk+tJ4UlDN
         joTH91vUl7D0+lFLPaLzVe0IfgJDCmSDKxz8amvQ=
Date:   Mon, 01 Feb 2021 15:43:32 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        vbabka@suse.cz
Subject:  +
 mm-workingset-clarify-eviction-order-and-distance-calculation.patch added
 to -mm tree
Message-ID: <20210201234332.ExPVoH0wM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: clarify eviction order and distance calculation
has been added to the -mm tree.  Its filename is
     mm-workingset-clarify-eviction-order-and-distance-calculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-clarify-eviction-order-and-distance-calculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-clarify-eviction-order-and-distance-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from osalvador@suse.de are

mm-workingset-clarify-eviction-order-and-distance-calculation.patch

