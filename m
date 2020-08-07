Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE03C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 093E322C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781286;
	bh=H58aq4rZBZxIDzcV4GGAxsC91DuutB//G1LzUWLK68M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=d44ZIkL05s36QK8ehh8X6BensMUJgeHcndsERMuL9l1XHw946rD/Toa6I05C30dbu
	 xYZbDFn38PFGcN8xIEp+aokHUbwNNjO27dQ4c2S5j+y3kcR9FFjAP7xFh1Jz5a0kta
	 ArGv6/aFbq/VD0uwJlcvVpM4pw/STQ/zAikhnmR0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGVZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA56C2177B;
        Fri,  7 Aug 2020 06:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781285;
        bh=H58aq4rZBZxIDzcV4GGAxsC91DuutB//G1LzUWLK68M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xwGUHggNTHMlgi03GcRh+3SQT5Gy2R1e/5+Muw4nngZ35vkI9xj39YetpuWAvN+jK
         AQjkmAyykePNZhnyL6HVo3jR3XNhzNLxTx/jtMIqgG46iEySWjndICb234JsudDRDB
         ohG3xewR4mk+lzGF9LdWw96/gxipx7/+HBTUpXGI=
Date:   Thu, 06 Aug 2020 23:21:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 077/163] mm: memcg/slab: remove redundant check in
 memcg_accumulate_slabinfo()
Message-ID: <20200807062124.HxrApR2M-%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: remove redundant check in memcg_accumulate_slabinfo()

memcg_accumulate_slabinfo() is never called with a non-root kmem_cache as
a first argument, so the is_root_cache(s) check is redundant and can be
removed without any functional change.

Link: http://lkml.kernel.org/r/20200623174037.3951353-17-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/slab_common.c~mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo
+++ a/mm/slab_common.c
@@ -1104,9 +1104,6 @@ memcg_accumulate_slabinfo(struct kmem_ca
 	struct kmem_cache *c;
 	struct slabinfo sinfo;
 
-	if (!is_root_cache(s))
-		return;
-
 	c = memcg_cache(s);
 	if (c) {
 		memset(&sinfo, 0, sizeof(sinfo));
_
