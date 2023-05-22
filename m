Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDA1C7EE2A
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 20:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbjEVUsR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 16:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjEVUsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 16:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BB7B7
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 13:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F16E62BF4
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 20:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2726C433D2;
        Mon, 22 May 2023 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684788493;
        bh=plnh3zfDDSFZ1fgUhAmipaRNQ09a4CZzQpPHR3w9LcA=;
        h=Date:To:From:Subject:From;
        b=RniszmDe8BBzZ7sEuxl25KC6rFnJX9h/EEE6Naxekh4SPBcrgNuWDEl0jAyFQ9zMM
         S1G+CIf1wWrnwD1xRbwLtNfP6EI8FLUiqgjzbKSe3TV4pFU6m6u2cNh6ZVUTQypAPl
         fjWNXMreNN9L2RfgHywpk5A/wEf2XushizBlWrGA=
Date:   Mon, 22 May 2023 13:48:12 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch added to mm-unstable branch
Message-Id: <20230522204812.E2726C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: cleanup lru_gen_test_recent()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch

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
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: cleanup lru_gen_test_recent()
Date: Mon, 22 May 2023 11:20:58 +0000

Avoid passing memcg* and pglist_data* to lru_gen_test_recent()
since we only use the lruvec anyway.

Link: https://lkml.kernel.org/r/20230522112058.2965866-4-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

--- a/mm/workingset.c~mm-multi-gen-lru-cleanup-lru_gen_test_recent
+++ a/mm/workingset.c
@@ -257,59 +257,46 @@ static void *lru_gen_eviction(struct fol
 
 /*
  * Tests if the shadow entry is for a folio that was recently evicted.
- * Fills in @memcgid, @pglist_data, @token, @workingset with the values
- * unpacked from shadow.
+ * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
-static bool lru_gen_test_recent(void *shadow, bool file, int *memcgid,
-		struct pglist_data **pgdat, unsigned long *token, bool *workingset)
+static bool lru_gen_test_recent(void *shadow, bool file, struct lruvec **lruvec,
+				unsigned long *token, bool *workingset)
 {
-	struct mem_cgroup *eviction_memcg;
-	struct lruvec *lruvec;
-	struct lru_gen_folio *lrugen;
+	int memcg_id;
 	unsigned long min_seq;
+	struct mem_cgroup *memcg;
+	struct pglist_data *pgdat;
 
-	unpack_shadow(shadow, memcgid, pgdat, token, workingset);
-	eviction_memcg = mem_cgroup_from_id(*memcgid);
+	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
 
-	lruvec = mem_cgroup_lruvec(eviction_memcg, *pgdat);
-	lrugen = &lruvec->lrugen;
+	memcg = mem_cgroup_from_id(memcg_id);
+	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-	min_seq = READ_ONCE(lrugen->min_seq[file]);
+	min_seq = READ_ONCE((*lruvec)->lrugen.min_seq[file]);
 	return (*token >> LRU_REFS_WIDTH) == (min_seq & (EVICTION_MASK >> LRU_REFS_WIDTH));
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
 {
 	int hist, tier, refs;
-	int memcg_id;
 	bool workingset;
 	unsigned long token;
-	unsigned long min_seq;
 	struct lruvec *lruvec;
 	struct lru_gen_folio *lrugen;
-	struct mem_cgroup *memcg;
-	struct pglist_data *pgdat;
 	int type = folio_is_file_lru(folio);
 	int delta = folio_nr_pages(folio);
 
 	rcu_read_lock();
 
-	if (!lru_gen_test_recent(shadow, type, &memcg_id, &pgdat, &token,
-			&workingset))
-		goto unlock;
-
-	memcg = folio_memcg_rcu(folio);
-	if (memcg_id != mem_cgroup_id(memcg))
+	if (!lru_gen_test_recent(shadow, type, &lruvec, &token, &workingset))
 		goto unlock;
 
-	if (pgdat != folio_pgdat(folio))
+	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
-	min_seq = READ_ONCE(lrugen->min_seq[type]);
 
-	hist = lru_hist_from_seq(min_seq);
+	hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
 	/* see the comment in folio_lru_refs() */
 	refs = (token & (BIT(LRU_REFS_WIDTH) - 1)) + workingset;
 	tier = lru_tier_from_refs(refs);
@@ -339,8 +326,8 @@ static void *lru_gen_eviction(struct fol
 	return NULL;
 }
 
-static bool lru_gen_test_recent(void *shadow, bool file, int *memcgid,
-		struct pglist_data **pgdat, unsigned long *token, bool *workingset)
+static bool lru_gen_test_recent(void *shadow, bool file, struct lruvec **lruvec,
+				unsigned long *token, bool *workingset)
 {
 	return false;
 }
@@ -435,8 +422,7 @@ bool workingset_test_recent(void *shadow
 	unsigned long eviction;
 
 	if (lru_gen_enabled())
-		return lru_gen_test_recent(shadow, file, &memcgid, &pgdat, &eviction,
-			workingset);
+		return lru_gen_test_recent(shadow, file, &eviction_lruvec, &eviction, workingset);
 
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
 	eviction <<= bucket_order;
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-use-macro-for-bitmap.patch
mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch
mm-multi-gen-lru-add-helpers-in-page-table-walks.patch
mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch

