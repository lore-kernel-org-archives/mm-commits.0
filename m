Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4034A76D
	for <mm-commits@vger.kernel.org>; Fri, 13 Feb 2026 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771001978; cv=none; b=AopXC6Voe2XbOn5dsZlWUEa4nkuBfki6ghAjnp9a8dsJp7CB4mrH59AJBx7ohaFLS6nbMbPSfxvm3oJfbHpTArdDfEJsKUwN0wWtKEzPN6m8QHgsAFW2MOvw+UIdl5RS04umFQohWSo4Yw6lkqvlBW1csugydbBrp9E7nIO8Jsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771001978; c=relaxed/simple;
	bh=XAdnbkjRrJDwJjIDZHptLijI49ogBXpQg+l9w6wwrn4=;
	h=Date:To:From:Subject:Message-Id; b=jb73uf7fy0gDB1T19wyn/mD8WH+ifpSamGP8qqwX53VquQFjTokyx9KRZwXSd8R8SRjL1uuQEWm5ieGTMHhzJCmSB4TRwsFYp46KrPOhmiZadFtX2j/MGChqmmSeqEhU1ObIj/5PJ1vl/ASpBwGAXDzlwdpK6LVkefQVas+/7jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=puqcX2Jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="puqcX2Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E47C116C6;
	Fri, 13 Feb 2026 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771001978;
	bh=XAdnbkjRrJDwJjIDZHptLijI49ogBXpQg+l9w6wwrn4=;
	h=Date:To:From:Subject:From;
	b=puqcX2JgdKhGJ0XG4AwTJ67ze5tv+CJFZ7BY8XKlTnebWvHBBTg4LbBxScmIDUE84
	 pMyn1jVaI2TmqiPFAzHJXYMDjvNFnrb6lH4ptQtCGZLNde/fjZVdBzn41EBhn54+lH
	 frq8hyaoyqdbyd6s5UXSzemJLkMZvdavcOruU1c8=
Date: Fri, 13 Feb 2026 08:59:37 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,koichiro.den@canonical.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-false-positive-wuninitialized-warning.patch added to mm-new branch
Message-Id: <20260213165937.F3E47C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: avoid false-positive -Wuninitialized warning
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/vmscan: avoid false-positive -Wuninitialized warning
Date: Fri, 13 Feb 2026 13:38:56 +0100

When the -fsanitize=bounds sanitizer is enabled, gcc-16 sometimes runs
into a corner case in the read_ctrl_pos() pos function, where it sees
possible undefined behavior from the 'tier' index overflowing, presumably
in the case that this was called with a negative tier:

In function 'get_tier_idx',
    inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
mm/vmscan.c: In function 'isolate_folios':
mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]

Part of the problem seems to be that read_ctrl_pos() has unusual calling
conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
smaller positive number makes it read a single tier instead.

Avoid this case by splitting read_ctrl_pos() into two separate helpers
that each only do one of the two cases.  This avoids the warning as far as
I can tell, and seems a bit easier to understand to me.

Link: https://lkml.kernel.org/r/20260213123902.3466040-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Koichiro Den <koichiro.den@canonical.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-false-positive-wuninitialized-warning
+++ a/mm/vmscan.c
@@ -3159,20 +3159,15 @@ struct ctrl_pos {
 static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 			  struct ctrl_pos *pos)
 {
-	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
 	pos->gain = gain;
-	pos->refaulted = pos->total = 0;
-
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
-		pos->refaulted += lrugen->avg_refaulted[type][i] +
-				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
-		pos->total += lrugen->avg_total[type][i] +
-			      lrugen->protected[hist][type][i] +
-			      atomic_long_read(&lrugen->evicted[hist][type][i]);
-	}
+	pos->refaulted = lrugen->avg_refaulted[type][tier] +
+			 atomic_long_read(&lrugen->refaulted[hist][type][tier]);
+	pos->total = lrugen->avg_total[type][tier] +
+		     lrugen->protected[hist][type][tier] +
+		     atomic_long_read(&lrugen->evicted[hist][type][tier]);
 }
 
 static void reset_ctrl_pos(struct lruvec *lruvec, int type, bool carryover)
@@ -4640,6 +4635,24 @@ static int get_tier_idx(struct lruvec *l
 	return tier - 1;
 }
 
+static void aggregate_ctrl_pos(struct lruvec *lruvec, int type, int gain,
+			       struct ctrl_pos *pos)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
+
+	pos->gain = gain;
+	pos->refaulted = pos->total = 0;
+
+	for (int i = 0; i < MAX_NR_TIERS; i++) {
+		pos->refaulted += lrugen->avg_refaulted[type][i] +
+				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
+		pos->total += lrugen->avg_total[type][i] +
+			      lrugen->protected[hist][type][i] +
+			      atomic_long_read(&lrugen->evicted[hist][type][i]);
+	}
+}
+
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
 	struct ctrl_pos sp, pv;
@@ -4653,8 +4666,8 @@ static int get_type_to_scan(struct lruve
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	aggregate_ctrl_pos(lruvec, LRU_GEN_ANON, swappiness, &sp);
+	aggregate_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

