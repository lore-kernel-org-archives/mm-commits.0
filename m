Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BC6C001DF
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 16:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjGFQjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjGFQjY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 12:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875571BE8
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 09:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F2A60F52
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 16:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386E9C433C9;
        Thu,  6 Jul 2023 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688661561;
        bh=r0VtHMztnTHm3iCT19HxtYxrna1+C7HevYi6Mq+GnGU=;
        h=Date:To:From:Subject:From;
        b=P49n5eIKFcjr2Xw56q6bcpYD6gXxli/iNqhuMUdqnwj7E/cZzRiGQgznnc/G4FnH8
         aIoqqtVVHaSL9LqOJKsdVq7xSzfc8uf+73yx0pYdOaBMj/9EwwuKut2HmnfYuIs0I2
         0IbwEWmOET64j2E0fZqX2qsjfVBlxMdYTCb6qvmA=
Date:   Thu, 06 Jul 2023 09:39:20 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg.patch added to mm-unstable branch
Message-Id: <20230706163921.386E9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove definition of MEM_CGROUP_ID_MAX when !CONFIG_MEMCG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: remove definition of MEM_CGROUP_ID_MAX when !CONFIG_MEMCG
Date: Thu, 6 Jul 2023 19:28:20 +0800

MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured.  Remove
unneeded !CONFIG_MEMCG variant.

Link: https://lkml.kernel.org/r/20230706112820.2393447-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
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
mm-memcg-remove-definition-of-mem_cgroup_id_max-when-config_memcg.patch

