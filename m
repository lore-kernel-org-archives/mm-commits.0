Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649EFC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E5B2075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027033;
	bh=EqBuDFfWbtjJ1+CszApHZKND+45Ks1Ix2EFKO3CuXy8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GELWIyxNHR7XmFtSQvZIrDBgWam8eEP7TSqiQx18UFD1kgs5KAKO+JBI2t581TzbQ
	 VppXmro591wyGjHdViy25OkY+fUOV8ifC2OqEi39MRnazewgKVpCQE6qmcYFuGjvnI
	 YqSyJe46wG8QeaacntLvI1oN47wweZDl9kdaPeH0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJChM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJChM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2299206CD;
        Mon, 10 Aug 2020 02:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027032;
        bh=EqBuDFfWbtjJ1+CszApHZKND+45Ks1Ix2EFKO3CuXy8=;
        h=Date:From:To:Subject:From;
        b=oL8XI5DpQ36YByzz4rcAnIHWjuRrxtuaAd1J48LbUCAfmSzNoltzq/tSCuwi4Jfk2
         p+yWPfgklU7UM+Dm9zlLhWBNBJ/yc6yG1WVdHFOS0prjgpFJS20aPFFA7Uv2HpbslP
         ODTu/uYrRohOnPMt1zycPVEvTO+uKnLXvqPEdqaI=
Date:   Sun, 09 Aug 2020 19:37:11 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch removed
 from -mm tree
Message-ID: <20200810023711.wkvqRFUPH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: switch to static_branch_likely() in memcg_kmem_enabled()
has been removed from the -mm tree.  Its filename was
     mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: switch to static_branch_likely() in memcg_kmem_enabled()

Currently memcg_kmem_enabled() is optimized for the kernel memory
accounting being off.  It was so for a long time, and arguably the reason
behind was that the kernel memory accounting was initially an opt-in
feature.  However, now it's on by default on both cgroup v1 and cgroup v2,
and it's on for all cgroups.  So let's switch over to
static_branch_likely() to reflect this fact.

Unlikely there is a significant performance difference, as the cost of a
memory allocation and its accounting significantly exceeds the cost of a
jump.  However, the conversion makes the code look more logically.

Link: http://lkml.kernel.org/r/20200707173612.124425-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled
+++ a/include/linux/memcontrol.h
@@ -1448,7 +1448,7 @@ void memcg_put_cache_ids(void);
 
 static inline bool memcg_kmem_enabled(void)
 {
-	return static_branch_unlikely(&memcg_kmem_enabled_key);
+	return static_branch_likely(&memcg_kmem_enabled_key);
 }
 
 static inline bool memcg_kmem_bypass(void)
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

