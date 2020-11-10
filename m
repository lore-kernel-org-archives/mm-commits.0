Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7C9C56202
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 18:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78200207D3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 18:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K63aJg0O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJSud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbgKJSud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 13:50:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C8A206F1;
        Tue, 10 Nov 2020 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605034232;
        bh=WqipS3iiEvaKvCSjfTqqK4XCOgl4JfnyzeOHhlL/CrQ=;
        h=Date:From:To:Subject:From;
        b=K63aJg0OZ88d/1PQVQODH5JucsIs5Eg66QCXl5EElPuOn4YlQcbF3OG3a9cXeznT4
         152EUAwTkp7Cw4LLcOL1h1+rjFkz0Z/vJqlzlInw2qeZn8JUMIBKrMqDapxF4AFI1o
         mnynor18VgkoEwbw0K5SW0tQnm+Gfy62wyo2CPng=
Date:   Tue, 10 Nov 2020 10:50:31 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-memcg-fix-obsolete-code-comments.patch added to -mm
 tree
Message-ID: <20201110185031.xAcuxXaqA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix obsolete code comments
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-obsolete-code-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-obsolete-code-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-obsolete-code-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: fix obsolete code comments

This patch fixes/removes some obsolete comments in the code related
to the kernel memory accounting:
- kmem_cache->memcg_params.memcg_caches has been removed
  by commit 9855609bde03 ("mm: memcg/slab: use a single set of
  kmem_caches for all accounted allocations")
- memcg->kmemcg_id is not used as a gate for kmem accounting since
  commit 0b8f73e10428 ("mm: memcontrol: clean up alloc, online,
  offline, free functions")

Link: https://lkml.kernel.org/r/20201110184615.311974-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 mm/memcontrol.c            |    6 ------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-fix-obsolete-code-comments
+++ a/include/linux/memcontrol.h
@@ -310,7 +310,6 @@ struct mem_cgroup {
 	int			tcpmem_pressure;
 
 #ifdef CONFIG_MEMCG_KMEM
-        /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
 	struct obj_cgroup __rcu *objcg;
@@ -1641,9 +1640,8 @@ static inline void memcg_kmem_uncharge_p
 }
 
 /*
- * helper for accessing a memcg's index. It will be used as an index in the
- * child cache array in kmem_cache, and also to derive its name. This function
- * will return -1 when this is not a kmem-limited memcg.
+ * A helper for accessing memcg's kmem_id, used for getting
+ * corresponding LRU lists.
  */
 static inline int memcg_cache_id(struct mem_cgroup *memcg)
 {
--- a/mm/memcontrol.c~mm-memcg-fix-obsolete-code-comments
+++ a/mm/memcontrol.c
@@ -3680,12 +3680,6 @@ static int memcg_online_kmem(struct mem_
 
 	static_branch_enable(&memcg_kmem_enabled_key);
 
-	/*
-	 * A memory cgroup is considered kmem-online as soon as it gets
-	 * kmemcg_id. Setting the id after enabling static branching will
-	 * guarantee no one starts accounting before all call sites are
-	 * patched.
-	 */
 	memcg->kmemcg_id = memcg_id;
 	memcg->kmem_state = KMEM_ONLINE;
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

