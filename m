Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9F73FD132;
	Fri,  9 Oct 2026 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525408; cv=none; b=KnYsrg6f7QELFHCTjPaB2/S6bJoSs/T37115R8KDHtcIMdJfpShbJI4eUiqRQdgfg37jx/QaSK1Kvf/yhfdy+kfICTnxmQq9+usr4cHUamGmcLciutfHawz0SZSIjYno1pxswsB3CZa8QCoel9zXI1u8m263lVHfW19gs6/UFjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525408; c=relaxed/simple;
	bh=BOFtcvCDqQUmeYKzzPXwWeOSuwjuK1PN2qhe93D2oi4=;
	h=Date:To:From:Subject:Message-Id; b=RLEKHMHtQRt+JC68tTM6mxTJ5xPtWuSNIN2jqhKvYor8SQV3qiiOxqdokHcSaqgJ8FBrjr8plX3+XkPYif95QqF/xMYb4o+Hn9kvLMhzTDN4MuC/n73MkgTCGX3H71rpsGaPrtl5CedxB63/pRSKsIoMcrBGRr+p6KgFOPt8bYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ssPO2RIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ssPO2RIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90341F00893;
	Fri,  9 Oct 2026 05:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525407;
	bh=R94sB/yF4aeXfxcaCWgf8A7/VHroURWuswW6V11lEiQ=;
	h=Date:To:From:Subject;
	b=ssPO2RIk0N07pQX7j0kF6MMbb2BMUGkMjVnmyUFXIC7xGTaBl+ZZOE1aPxEL5BonT
	 MpfSZ+95bKcqk/S1eaTAKC2PGTnZalfW+tWfiNQ8ZGaHpusI51C6buKH51tTlxw0kG
	 dq0oGI8NGB/6UJUXzdbYQKMjwYcBmT5X/PuxdPHw=
Date: Thu, 08 Oct 2026 22:56:46 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch removed from -mm tree
Message-Id: <20261009055646.D90341F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: avoid false-positive -Wuninitialized warning, again
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/vmscan: avoid false-positive -Wuninitialized warning, again
Date: Wed, 16 Sep 2026 10:34:46 +0200

I previously worked around a false-postive gcc-16 warning in the
get_tier_idx() function, by adding a fake initializer. This happens with
the -fsanitize=bounds sanitizer when the compiler creates a specialized
variant of isolate_folios():

In function 'get_tier_idx',
    inlined from 'isolate_folios.constprop' at mm/vmscan.c:4982:9:
mm/vmscan.c:4934:9: error: 'sp.refaulted' is used uninitialized [-Werror=uninitialized]
 4934 |         read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/vmscan.c: In function 'isolate_folios.constprop':
mm/vmscan.c:4946:25: note: 'sp.refaulted' was declared here
 4946 |         struct ctrl_pos sp, pv = {};
      |                         ^~

Adding another "= {}" would solve the problem as well, but to prevent
this from happening again after the next code refactoring, try instead to
prevent this by forbidding interprocedural optimizations on this function.

Link: https://lore.kernel.org/all/20260213123902.3466040-1-arnd@kernel.org/
Link: https://lore.kernel.org/20260916083456.4136132-1-arnd@kernel.org
Fixes: 3de705a43a46 ("mm/vmscan: avoid false-positive -Wuninitialized warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/vmscan.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-false-positive-wuninitialized-warning-again
+++ a/mm/vmscan.c
@@ -3223,8 +3223,11 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
-			  int tier_max, int gain, struct ctrl_pos *pos)
+/*
+ * __noipa works around gcc-16 warning for uninitialized use of pos->refaulted
+ */
+static void __noipa read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+				  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -4873,7 +4876,7 @@ static int scan_folios(unsigned long nr_
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4892,7 +4895,7 @@ static int get_tier_idx(struct lruvec *l
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-core-reduce-stack-usage-further.patch

