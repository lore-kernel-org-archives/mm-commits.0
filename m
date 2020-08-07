Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4C6C433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2F7822D00
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781232;
	bh=/+GjuyI/einNEPcWggkqcOYCxaQ8Rpt+T+rqa38Zqwo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eua2LrnGIUhmqvW2jsLY8SwSLFYwvaORgozK/XIyXYhh7fZlwVw0dD8NfUhhSjI7U
	 riDbSRnYhSW3h9tFIg1sHbA4ZFIymK83q7ia8yGEzYLUzDOC2/nuF2Fm+P8Tov34yK
	 nVf0ey+gxNiyMfGEYP2dDDUtHxUHbY4SjnRb2CJU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHGGUc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgHGGUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34DEC221E5;
        Fri,  7 Aug 2020 06:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781229;
        bh=/+GjuyI/einNEPcWggkqcOYCxaQ8Rpt+T+rqa38Zqwo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ICF0VlBESrUh5vw8C0dxRLkpAmZRmhBBGP/WSdcbcNNMaSO5z7NK4DPnq8I0aB9SL
         pD8d8LETxQdWF9bIsy0FxzXXYLDlsGL2HjKhNDFK9ihKMxavLHsed88cprvDATEyIu
         unc2z0X1jtSCv8TQfT0Snj42+OZ1SoFgftHh3P2U=
Date:   Thu, 06 Aug 2020 23:20:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, shakeelb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 061/163] mm: kmem: make memcg_kmem_enabled()
 irreversible
Message-ID: <20200807062028.9dTsF8Lvx%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: make memcg_kmem_enabled() irreversible

Historically the kernel memory accounting was an opt-in feature, which
could be enabled for individual cgroups.  But now it's not true, and it's
on by default both on cgroup v1 and cgroup v2.  And as long as a user has
at least one non-root memory cgroup, the kernel memory accounting is on. 
So in most setups it's either always on (if memory cgroups are in use and
kmem accounting is not disabled), either always off (otherwise).

memcg_kmem_enabled() is used in many places to guard the kernel memory
accounting code.  If memcg_kmem_enabled() can reverse from returning true
to returning false (as now), we can't rely on it on release paths and have
to check if it was on before.

If we'll make memcg_kmem_enabled() irreversible (always returning true
after returning it for the first time), it'll make the general logic more
simple and robust.  It also will allow to guard some checks which
otherwise would stay unguarded.

Link: http://lkml.kernel.org/r/20200702180926.1330769-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-make-memcg_kmem_enabled-irreversible
+++ a/mm/memcontrol.c
@@ -3416,7 +3416,8 @@ static int memcg_online_kmem(struct mem_
 	if (memcg_id < 0)
 		return memcg_id;
 
-	static_branch_inc(&memcg_kmem_enabled_key);
+	static_branch_enable(&memcg_kmem_enabled_key);
+
 	/*
 	 * A memory cgroup is considered kmem-online as soon as it gets
 	 * kmemcg_id. Setting the id after enabling static branching will
@@ -3486,11 +3487,6 @@ static void memcg_free_kmem(struct mem_c
 	/* css_alloc() failed, offlining didn't happen */
 	if (unlikely(memcg->kmem_state == KMEM_ONLINE))
 		memcg_offline_kmem(memcg);
-
-	if (memcg->kmem_state == KMEM_ALLOCATED) {
-		WARN_ON(!list_empty(&memcg->kmem_caches));
-		static_branch_dec(&memcg_kmem_enabled_key);
-	}
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
_
