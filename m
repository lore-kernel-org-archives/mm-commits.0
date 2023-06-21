Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3858BEB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 22:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjFUWBp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 18:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjFUWBo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 18:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BCC10CE
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 15:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ACB3616E9
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 22:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04301C433C8;
        Wed, 21 Jun 2023 22:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687384901;
        bh=Q/V1xm4BxjqUbywO3m9UG3qSlVNh5KQJr7iQ3bJIBwI=;
        h=Date:To:From:Subject:From;
        b=tks42njlv5yVjeO7LYeLh3Da36vvIbbLquC33ROPiPjc1PsT7yiHl786y+Nz17vh8
         6HCHsVrOBikVHTTBQGc+olZUuKUMbjqrM637yhNs8MpPq2PJQRk7Vatn7kDMijsXei
         M+/q2ElOUxcVkQh73qtJF+ZLTfHCOCxt6NOOc3s4=
Date:   Wed, 21 Jun 2023 15:01:40 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-rename-and-document-global_reclaim.patch added to mm-unstable branch
Message-Id: <20230621220141.04301C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: rename and document global_reclaim()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-rename-and-document-global_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-rename-and-document-global_reclaim.patch

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
Subject: mm: memcg: rename and document global_reclaim()
Date: Wed, 21 Jun 2023 02:30:53 +0000

Evidently, global_reclaim() can be a confusing name.  Especially that it
used to exist before with a subtly different definition (removed by commit
b5ead35e7e1d ("mm: vmscan: naming fixes: global_reclaim() and
sane_reclaim()").  It can be interpreted as non-cgroup reclaim, even
though it returns true for cgroup reclaim on the root memcg (through
memory.reclaim).

Rename it to root_reclaim() in an attempt to make it less ambiguous, and
add documentation to it as well as cgroup_reclaim.

Link: https://lkml.kernel.org/r/20230621023053.432374-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Closes: https://lore.kernel.org/lkml/20230405200150.GA35884@cmpxchg.org/
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-memcg-rename-and-document-global_reclaim
+++ a/mm/vmscan.c
@@ -429,12 +429,17 @@ void reparent_shrinker_deferred(struct m
 	up_read(&shrinker_rwsem);
 }
 
+/* Returns true for reclaim through cgroup limits or cgroup interfaces. */
 static bool cgroup_reclaim(struct scan_control *sc)
 {
 	return sc->target_mem_cgroup;
 }
 
-static bool global_reclaim(struct scan_control *sc)
+/*
+ * Returns true for reclaim on the root cgroup. This is true for direct
+ * allocator reclaim and reclaim through cgroup interfaces on the root cgroup.
+ */
+static bool root_reclaim(struct scan_control *sc)
 {
 	return !sc->target_mem_cgroup || mem_cgroup_is_root(sc->target_mem_cgroup);
 }
@@ -489,7 +494,7 @@ static bool cgroup_reclaim(struct scan_c
 	return false;
 }
 
-static bool global_reclaim(struct scan_control *sc)
+static bool root_reclaim(struct scan_control *sc)
 {
 	return true;
 }
@@ -546,7 +551,7 @@ static void flush_reclaim_state(struct s
 	 * memcg reclaim, to make reporting more accurate and reduce
 	 * underestimation, but it's probably not worth the complexity for now.
 	 */
-	if (current->reclaim_state && global_reclaim(sc)) {
+	if (current->reclaim_state && root_reclaim(sc)) {
 		sc->nr_reclaimed += current->reclaim_state->reclaimed;
 		current->reclaim_state->reclaimed = 0;
 	}
@@ -5325,7 +5330,7 @@ static long get_nr_to_scan(struct lruvec
 static unsigned long get_nr_to_reclaim(struct scan_control *sc)
 {
 	/* don't abort memcg reclaim to ensure fairness */
-	if (!global_reclaim(sc))
+	if (!root_reclaim(sc))
 		return -1;
 
 	return max(sc->nr_to_reclaim, compact_gap(sc->order));
@@ -5477,7 +5482,7 @@ static void lru_gen_shrink_lruvec(struct
 {
 	struct blk_plug plug;
 
-	VM_WARN_ON_ONCE(global_reclaim(sc));
+	VM_WARN_ON_ONCE(root_reclaim(sc));
 	VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
 
 	lru_add_drain();
@@ -5538,7 +5543,7 @@ static void lru_gen_shrink_node(struct p
 	struct blk_plug plug;
 	unsigned long reclaimed = sc->nr_reclaimed;
 
-	VM_WARN_ON_ONCE(!global_reclaim(sc));
+	VM_WARN_ON_ONCE(!root_reclaim(sc));
 
 	/*
 	 * Unmapped clean folios are already prioritized. Scanning for more of
@@ -6260,7 +6265,7 @@ static void shrink_lruvec(struct lruvec
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !global_reclaim(sc)) {
+	if (lru_gen_enabled() && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
 		return;
 	}
@@ -6501,7 +6506,7 @@ static void shrink_node(pg_data_t *pgdat
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
-	if (lru_gen_enabled() && global_reclaim(sc)) {
+	if (lru_gen_enabled() && root_reclaim(sc)) {
 		lru_gen_shrink_node(pgdat, sc);
 		return;
 	}
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-fix-double-invalidate-with-exclusive-loads.patch
mm-memcg-rename-and-document-global_reclaim.patch
mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.patch

