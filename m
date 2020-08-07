Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA86C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9560022CF6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781540;
	bh=KT3ueLNB31fnYsOKLCyeA9Ey8zx+Sz7NmX46c0vCkLo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mL4exWew0IqjsGhedKJyesp8zu36NcRRY/kyQ5oeQcnCVjrALZ5dKLYl5XKj1o/XQ
	 wcJM9A5Ocw7kk/J4/d3IdWJwwVtyZa2I5VRS+Bsr+P1kzWWEn0ghtgblgKKIaVQmfY
	 lOpt1KJfvIvgLx8DkhGFe6jUc5P70M47aa6bfgDY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHGGZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6A9E22CB3;
        Fri,  7 Aug 2020 06:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781539;
        bh=KT3ueLNB31fnYsOKLCyeA9Ey8zx+Sz7NmX46c0vCkLo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=x9uFRH+1I8e6Jsd12WzBRFEAiakpWNCwP14GrXLIxWv3oTvuG99QQx7YGGjKYVPTS
         i/xIitxwZiMrQtWCVQTA7rMQVUDqfmPK9P5rpYbreBKuhFfPmqM92qHcEjO6rjahqO
         SZkvM5xzz6WTn5jHH2Jo8N1A6d1LRlcj4ffI6a6k=
Date:   Thu, 06 Aug 2020 23:25:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        david@redhat.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 147/163] mm/shuffle: remove dynamic
 reconfiguration
Message-ID: <20200807062538.rBNkbuYpf%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/shuffle: remove dynamic reconfiguration

Commit e900a918b098 ("mm: shuffle initial free memory to improve
memory-side-cache utilization") promised "autodetection of a
memory-side-cache (to be added in a follow-on patch)" over a year ago.

The original series included patches [1], however, they were dropped
during review [2] to be followed-up later.

Due to lack of platforms that publish an HMAT, autodetection is currently
not implemented.  However, manual activation is actively used [3].  Let's
simplify for now and re-add when really (ever?) needed.

[1] https://lkml.kernel.org/r/154510700291.1941238.817190985966612531.stgit@dwillia2-desk3.amr.corp.intel.com
[2] https://lkml.kernel.org/r/154690326478.676627.103843791978176914.stgit@dwillia2-desk3.amr.corp.intel.com
[3] https://lkml.kernel.org/r/CAPcyv4irwGUU2x+c6b4L=KbB1dnasNKaaZd6oSpYjL9kfsnROQ@mail.gmail.com

Link: http://lkml.kernel.org/r/20200624094741.9918-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shuffle.c |   28 ++--------------------------
 mm/shuffle.h |   17 -----------------
 2 files changed, 2 insertions(+), 43 deletions(-)

--- a/mm/shuffle.c~mm-shuffle-remove-dynamic-reconfiguration
+++ a/mm/shuffle.c
@@ -10,33 +10,11 @@
 #include "shuffle.h"
 
 DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
-static unsigned long shuffle_state __ro_after_init;
-
-/*
- * Depending on the architecture, module parameter parsing may run
- * before, or after the cache detection. SHUFFLE_FORCE_DISABLE prevents,
- * or reverts the enabling of the shuffle implementation. SHUFFLE_ENABLE
- * attempts to turn on the implementation, but aborts if it finds
- * SHUFFLE_FORCE_DISABLE already set.
- */
-__meminit void page_alloc_shuffle(enum mm_shuffle_ctl ctl)
-{
-	if (ctl == SHUFFLE_FORCE_DISABLE)
-		set_bit(SHUFFLE_FORCE_DISABLE, &shuffle_state);
-
-	if (test_bit(SHUFFLE_FORCE_DISABLE, &shuffle_state)) {
-		if (test_and_clear_bit(SHUFFLE_ENABLE, &shuffle_state))
-			static_branch_disable(&page_alloc_shuffle_key);
-	} else if (ctl == SHUFFLE_ENABLE
-			&& !test_and_set_bit(SHUFFLE_ENABLE, &shuffle_state))
-		static_branch_enable(&page_alloc_shuffle_key);
-}
 
 static bool shuffle_param;
 static int shuffle_show(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%c\n", test_bit(SHUFFLE_ENABLE, &shuffle_state)
-			? 'Y' : 'N');
+	return sprintf(buffer, "%c\n", shuffle_param ? 'Y' : 'N');
 }
 
 static __meminit int shuffle_store(const char *val,
@@ -47,9 +25,7 @@ static __meminit int shuffle_store(const
 	if (rc < 0)
 		return rc;
 	if (shuffle_param)
-		page_alloc_shuffle(SHUFFLE_ENABLE);
-	else
-		page_alloc_shuffle(SHUFFLE_FORCE_DISABLE);
+		static_branch_enable(&page_alloc_shuffle_key);
 	return 0;
 }
 module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
--- a/mm/shuffle.h~mm-shuffle-remove-dynamic-reconfiguration
+++ a/mm/shuffle.h
@@ -4,23 +4,10 @@
 #define _MM_SHUFFLE_H
 #include <linux/jump_label.h>
 
-/*
- * SHUFFLE_ENABLE is called from the command line enabling path, or by
- * platform-firmware enabling that indicates the presence of a
- * direct-mapped memory-side-cache. SHUFFLE_FORCE_DISABLE is called from
- * the command line path and overrides any previous or future
- * SHUFFLE_ENABLE.
- */
-enum mm_shuffle_ctl {
-	SHUFFLE_ENABLE,
-	SHUFFLE_FORCE_DISABLE,
-};
-
 #define SHUFFLE_ORDER (MAX_ORDER-1)
 
 #ifdef CONFIG_SHUFFLE_PAGE_ALLOCATOR
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
-extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
 extern bool shuffle_pick_tail(void);
 static inline void shuffle_free_memory(pg_data_t *pgdat)
@@ -58,10 +45,6 @@ static inline void shuffle_zone(struct z
 {
 }
 
-static inline void page_alloc_shuffle(enum mm_shuffle_ctl ctl)
-{
-}
-
 static inline bool is_shuffle_order(int order)
 {
 	return false;
_
