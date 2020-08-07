Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CE3C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A97F22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781269;
	bh=vSUkyCrxSJ4h5T+2raEVazvOOFp7gHy2SXsHVtILgd8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NSm/njfEJphai0J5JR3YNekgO3ZcL+zXv6Vm6NMj/KjleJHzXu7pb4Nle48ytJ6hZ
	 oy8H+HoGy6kuySUsIcYVucG2rzJQhtd0y1QGwTXmG2nv2wY5V/rdy4xDLfc4rQQ6KA
	 817Wvhbb+pHbG/2fmgbeY7cAYcQubYt1HxTtmlSQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHGGVJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGVI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F6DB2177B;
        Fri,  7 Aug 2020 06:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781267;
        bh=vSUkyCrxSJ4h5T+2raEVazvOOFp7gHy2SXsHVtILgd8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0smpSvB07S8vt+B4ycabX7NmPgSG6K8W0+XKS38hPao4ywxzZ4f+9sq7Em8QfqJjG
         Xhv+1FDM7Du+CoUfDqayeMlf/8JOoNV7bHBc3zuSOXAiQ4y6Fp78e4PQDlftbef3MG
         YNfrZZEDvhzwN58raBxbfCBY+pe+JsZ+MnSmjTDk=
Date:   Thu, 06 Aug 2020 23:21:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 072/163] mm: memcg/slab: move memcg_kmem_bypass()
 to memcontrol.h
Message-ID: <20200807062106.N7mmmABPp%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: move memcg_kmem_bypass() to memcontrol.h

To make the memcg_kmem_bypass() function available outside of the
memcontrol.c, let's move it to memcontrol.h.  The function is small and
nicely fits into static inline sort of functions.

It will be used from the slab code.

Link: http://lkml.kernel.org/r/20200623174037.3951353-12-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++++++++++++
 mm/memcontrol.c            |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh
+++ a/include/linux/memcontrol.h
@@ -1440,6 +1440,18 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
+static inline bool memcg_kmem_bypass(void)
+{
+	if (in_interrupt())
+		return true;
+
+	/* Allow remote memcg charging in kthread contexts. */
+	if ((!current->mm || (current->flags & PF_KTHREAD)) &&
+	     !current->active_memcg)
+		return true;
+	return false;
+}
+
 static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
 					 int order)
 {
--- a/mm/memcontrol.c~mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh
+++ a/mm/memcontrol.c
@@ -2945,18 +2945,6 @@ static void memcg_schedule_kmem_cache_cr
 	queue_work(memcg_kmem_cache_wq, &cw->work);
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
 /**
  * memcg_kmem_get_cache: select the correct per-memcg cache for allocation
  * @cachep: the original global kmem cache
_
