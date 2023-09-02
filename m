Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0D0C001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbjIBX2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBX2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:28:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08783CDA
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A63D60C08
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7F5C433C8;
        Sat,  2 Sep 2023 23:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693697327;
        bh=sfo1mVhfw/wLGOTI6UvcWL45cJD0dNrMVDwz+A/hpdo=;
        h=Date:To:From:Subject:From;
        b=a9LbONXpYS79hHOqVaSaGCwRrR7KIZp4hJJWdhm7PnHPT13TnZdLNTXjJVI8JC4CZ
         x3JaisDDTbZ4TPMmh4pUaNUPv0YguGOVm4sFRz1Pn/4GVqc8HNwPp0ALgKS4J+Igoo
         Sn3UXrZJopptlX6YLhhPOA8aiRyUQskzOVmSRxuY=
Date:   Sat, 02 Sep 2023 16:28:46 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, longman@redhat.com, ivan@cloudflare.com,
        hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch added to mm-unstable branch
Message-Id: <20230902232846.DE7F5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add a helper for non-unified stats flushing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: add a helper for non-unified stats flushing
Date: Thu, 31 Aug 2023 16:56:09 +0000

Some contexts flush memcg stats outside of unified flushing, directly
using cgroup_rstat_flush().  Add a helper for non-unified flushing, a
counterpart for do_unified_stats_flush(), and use it in those contexts, as
well as in do_unified_stats_flush() itself.

This abstracts the rstat API and makes it easy to introduce modifications
to either unified or non-unified flushing functions without changing
callers.

No functional change intended.

Link: https://lkml.kernel.org/r/20230831165611.2610118-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-add-a-helper-for-non-unified-stats-flushing
+++ a/mm/memcontrol.c
@@ -640,6 +640,17 @@ static inline void memcg_rstat_updated(s
 }
 
 /*
+ * do_stats_flush - do a flush of the memory cgroup statistics
+ * @memcg: memory cgroup to flush
+ *
+ * Only flushes the subtree of @memcg, does not skip under any conditions.
+ */
+static void do_stats_flush(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_flush(memcg->css.cgroup);
+}
+
+/*
  * do_unified_stats_flush - do a unified flush of memory cgroup statistics
  *
  * A unified flush tries to flush the entire hierarchy, but skips if there is
@@ -656,7 +667,7 @@ static void do_unified_stats_flush(void)
 
 	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
 
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	do_stats_flush(root_mem_cgroup);
 
 	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_unified_flush_ongoing, 0);
@@ -7794,7 +7805,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 			break;
 		}
 
-		cgroup_rstat_flush(memcg->css.cgroup);
+		do_stats_flush(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
@@ -7859,8 +7870,10 @@ void obj_cgroup_uncharge_zswap(struct ob
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
 			      struct cftype *cft)
 {
-	cgroup_rstat_flush(css->cgroup);
-	return memcg_page_state(mem_cgroup_from_css(css), MEMCG_ZSWAP_B);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	do_stats_flush(memcg);
+	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
 }
 
 static int zswap_max_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-properly-name-and-document-unified-stats-flushing.patch
mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch
mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch
mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch

