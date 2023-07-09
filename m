Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C53EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjGIApB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGIApB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:45:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4158D1B1
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C711F60B62
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26283C433C8;
        Sun,  9 Jul 2023 00:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688863499;
        bh=5aGmbj5RGZsBvfAlIaCmtRsMO18V6dRKzH16LTfnD1o=;
        h=Date:To:From:Subject:From;
        b=QEVI6c43T7hD5uzs/RgRrVjDLbldWZKDcteQqmkL9IARKZgV50luQFAQ3SrysaYSB
         SPK5PV2meffM5CXVsHUnptoqtJq8hyRJXGhqG3/sBEnNTEMX8dqap/WU6JfvnhvYSS
         eqt+/pNF+Om35ttvAJMvcq5wrjwsVk3VAxr6/ff8=
Date:   Sat, 08 Jul 2023 17:44:58 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch added to mm-unstable branch
Message-Id: <20230709004459.26283C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: minor cleanup for MEM_CGROUP_ID_MAX
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch

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
Subject: mm/memcg: minor cleanup for MEM_CGROUP_ID_MAX
Date: Sat, 8 Jul 2023 10:33:04 +0800

MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured.  So remove
unneeded !CONFIG_MEMCG variant.  Also it's only used in
mem_cgroup_alloc(), so move it from memcontrol.h to memcontrol.c.  And
further define it as:

  #define MEM_CGROUP_ID_MAX ((1UL << MEM_CGROUP_ID_SHIFT) - 1)

so if someone changes MEM_CGROUP_ID_SHIFT in the future, then
MEM_CGROUP_ID_MAX will be updated accordingly, as suggested by Muchun.

Link: https://lkml.kernel.org/r/20230708023304.1184111-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 mm/memcontrol.c            |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-minor-cleanup-for-mem_cgroup_id_max
+++ a/include/linux/memcontrol.h
@@ -61,7 +61,6 @@ struct mem_cgroup_reclaim_cookie {
 #ifdef CONFIG_MEMCG
 
 #define MEM_CGROUP_ID_SHIFT	16
-#define MEM_CGROUP_ID_MAX	USHRT_MAX
 
 struct mem_cgroup_id {
 	int id;
@@ -1158,7 +1157,6 @@ unsigned long mem_cgroup_soft_limit_recl
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
-#define MEM_CGROUP_ID_MAX	0
 
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
--- a/mm/memcontrol.c~mm-memcg-minor-cleanup-for-mem_cgroup_id_max
+++ a/mm/memcontrol.c
@@ -5155,6 +5155,7 @@ static struct cftype mem_cgroup_legacy_f
  * those references are manageable from userspace.
  */
 
+#define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
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
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch

