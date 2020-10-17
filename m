Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165F5C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFA5A20E65
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976435;
	bh=VlZELGYYfGYDdh/QokchyFR5JVtzlL8vI17tRfmCMQQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XUN2OAsFGQ2qGMplBzz99d2qUX2t1EE7PUSEqqc8x9PUTyCtqh/w6kSOEH9Mja0YR
	 xgCzp5B5LETCQTKxDdfad46Jsw1X7dnQJAOyAdQ4uxXdy89RwCPYs7ymsTruJdSEDf
	 FzGW4BFV0sUJkHtuvA27t1+YJ+QjITzmMNuYHNtw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439885AbgJQXNz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E14208B6;
        Sat, 17 Oct 2020 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976434;
        bh=VlZELGYYfGYDdh/QokchyFR5JVtzlL8vI17tRfmCMQQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VX2OI9jTJtrXJaKppvYkJztGHQk9s0N/61deAAfSvnVc/tAL8GnT8H4wxJwHDpJje
         8r/hDbgluxwQJk+XocHJ0+LbbNSgb1fZ24/EayyqZXRIp6oJUnyMCRaYumHo3HWhzM
         VpIQlLAWG0UqjwXzyHH9eN47XDNRyb0YCacqKnrY=
Date:   Sat, 17 Oct 2020 16:13:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 06/40] mm: kmem: enable kernel memcg accounting
 from interrupt contexts
Message-ID: <20201017231353.tyvwMYEGc%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: enable kernel memcg accounting from interrupt contexts

If a memcg to charge can be determined (using remote charging API), there
are no reasons to exclude allocations made from an interrupt context from
the accounting.

Such allocations will pass even if the resulting memcg size will exceed
the hard limit, but it will affect the application of the memory pressure
and an inability to put the workload under the limit will eventually
trigger the OOM.

To use active_memcg() helper, memcg_kmem_bypass() is moved back to
memcontrol.c.

Link: http://lkml.kernel.org/r/20200827225843.1270629-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ------------
 mm/memcontrol.c            |   13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts
+++ a/include/linux/memcontrol.h
@@ -1531,18 +1531,6 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_likely(&memcg_kmem_enabled_key);
 }
 
-static inline bool memcg_kmem_bypass(void)
-{
-	if (in_interrupt())
-		return true;
-
-	/* Allow remote memcg charging in kthread contexts. */
-	if ((!current->mm || (current->flags & PF_KTHREAD)) &&
-	     !current->active_memcg)
-		return true;
-	return false;
-}
-
 static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
 					 int order)
 {
--- a/mm/memcontrol.c~mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts
+++ a/mm/memcontrol.c
@@ -1090,6 +1090,19 @@ static __always_inline struct mem_cgroup
 	return memcg;
 }
 
+static __always_inline bool memcg_kmem_bypass(void)
+{
+	/* Allow remote memcg charging from any context. */
+	if (unlikely(active_memcg()))
+		return false;
+
+	/* Memcg to charge can't be determined. */
+	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+		return true;
+
+	return false;
+}
+
 /**
  * If active memcg is set, do not fallback to current->mm->memcg.
  */
_
