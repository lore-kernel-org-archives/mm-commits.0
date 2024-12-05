Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07035D26D
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373873; cv=none; b=AiwppX6QJrxJd7ATsWMSMLzXHmNX1mlNp0bWMvoa4B68IkJpunHp78Pg8YP6uYyNBphoqjT4bt/xkU7sJr7hQsdTfdIQJkfnMCfh89FQ1/gdqkL0o3ZoR0TJqttNa5/IYxV8g9aGKhqgdq7leHfvwlkDQN98uDxY2T3zWRycL3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373873; c=relaxed/simple;
	bh=BFejmeEBH0k7TfBTDAz1W76m9+xsY4OP19zvkpurI6E=;
	h=Date:To:From:Subject:Message-Id; b=Kc4pzEG819zCJDsoiuelkTPRHH7aqXBkeSv9aGs4MfM5JF/FyExrA6Xk8fcLR/boK2e9PSPKLh6hNsaSdbcKf8dk5CmaSvtRN9K3OzNkYYPnQmFOMlObnvrPfEGf8t+q/jYVvdYXKR//XOAbl7jyDnjk88RxRWdkyv7k+0R22fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1QtvlWqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1QtvlWqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7743FC4CED6;
	Thu,  5 Dec 2024 04:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733373872;
	bh=BFejmeEBH0k7TfBTDAz1W76m9+xsY4OP19zvkpurI6E=;
	h=Date:To:From:Subject:From;
	b=1QtvlWqeD0UEkE5wWNuL8di8HHa1VdkVDMPor4jOs39luy7+1od+pIJ75/vS55zOh
	 HW/WCnFtxHUB1cgaDxTeDqF8C041dNR62/PVOJVmektHmHGEewx7wXx+8qWQxoMVrB
	 hlMwKcZC7KrwTQagmroreTh9M0hz2fpJT5AxnnPc=
Date: Wed, 04 Dec 2024 20:44:31 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-rework-refault-detection.patch added to mm-unstable branch
Message-Id: <20241205044432.7743FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: rework refault detection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-rework-refault-detection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-rework-refault-detection.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: rework refault detection
Date: Sun, 1 Dec 2024 20:28:22 -0700

With anon and file min_seq being able to move independently, rework
workingset protection as well so that the comparison of refaults between
anon and file is always on an equal footing.

Specifically, make lru_gen_test_recent() return true for refaults
happening within the distance of MAX_NR_GENS.  For example, if min_seq of
a type is max_seq-MIN_NR_GENS, refaults from min_seq-1, i.e.,
max_seq-MIN_NR_GENS-1, are also considered recent, since the distance
max_seq-(max_seq-MIN_NR_GENS-1), i.e., MIN_NR_GENS+1 is less than
MAX_NR_GENS.

As an intermediate step to the final optimization, this change by itself
should not have userspace-visiable effects beyond performance.

Link: https://lkml.kernel.org/r/20241202032823.2741019-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Kairui Song <kasong@tencent.com>
Closes: https://lore.kernel.org/CAOUHufahuWcKf5f1Sg3emnqX+cODuR=2TQo7T4Gr-QYLujn4RA@mail.gmail.com/
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Stevens <stevensd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/workingset.c~mm-mglru-rework-refault-detection
+++ a/mm/workingset.c
@@ -260,11 +260,11 @@ static void *lru_gen_eviction(struct fol
  * Tests if the shadow entry is for a folio that was recently evicted.
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
-static bool lru_gen_test_recent(void *shadow, bool file, struct lruvec **lruvec,
+static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 				unsigned long *token, bool *workingset)
 {
 	int memcg_id;
-	unsigned long min_seq;
+	unsigned long max_seq;
 	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat;
 
@@ -273,8 +273,10 @@ static bool lru_gen_test_recent(void *sh
 	memcg = mem_cgroup_from_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-	min_seq = READ_ONCE((*lruvec)->lrugen.min_seq[file]);
-	return (*token >> LRU_REFS_WIDTH) == (min_seq & (EVICTION_MASK >> LRU_REFS_WIDTH));
+	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
+	max_seq &= EVICTION_MASK >> LRU_REFS_WIDTH;
+
+	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
@@ -290,7 +292,7 @@ static void lru_gen_refault(struct folio
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, type, &lruvec, &token, &workingset);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -331,7 +333,7 @@ static void *lru_gen_eviction(struct fol
 	return NULL;
 }
 
-static bool lru_gen_test_recent(void *shadow, bool file, struct lruvec **lruvec,
+static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 				unsigned long *token, bool *workingset)
 {
 	return false;
@@ -432,8 +434,7 @@ bool workingset_test_recent(void *shadow
 		bool recent;
 
 		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, file, &eviction_lruvec,
-					     &eviction, workingset);
+		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction, workingset);
 		rcu_read_unlock();
 		return recent;
 	}
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch

