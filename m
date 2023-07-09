Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369E8EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjGIAo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGIAoZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10291B1
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED8960B62
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7BFC433C8;
        Sun,  9 Jul 2023 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688863463;
        bh=VwxxIauoiSAAAYMMyTpULoLqscqqVGZPJSITEz34yHE=;
        h=Date:To:From:Subject:From;
        b=Oq7LzuyLaGQGGBFhybVOiR9fC10y6rRKnKq9Ckiu9Vr0B97dznlzpjnliTPNgqaNy
         PwYX8QQvN/V9zVDf/ZtfC6BBKCbeTNdoOSuwy7HKan+EqyU2cxdlbBCaNL7Fh8w1lK
         tS0xXDSDMfCIpmnojtC6GLiUvBeyM0ncASSTFpnU=
Date:   Sat, 08 Jul 2023 17:44:22 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg.patch removed from -mm tree
Message-Id: <20230709004423.AA7BFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: remove definition of MEM_CGROUP_ID_MAX when !CONFIG_MEMCG
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: remove definition of MEM_CGROUP_ID_MAX when !CONFIG_MEMCG
Date: Thu, 6 Jul 2023 19:28:20 +0800

MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured.  Remove
unneeded !CONFIG_MEMCG variant.

Link: https://lkml.kernel.org/r/20230706112820.2393447-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg
+++ a/include/linux/memcontrol.h
@@ -1158,7 +1158,6 @@ unsigned long mem_cgroup_soft_limit_recl
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
-#define MEM_CGROUP_ID_MAX	0
 
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch

