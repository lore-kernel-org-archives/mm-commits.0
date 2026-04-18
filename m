Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10B6376BF7
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 08:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499205; cv=none; b=I6iRq9MVuNwXUqplBAZ4Ge6NzW9M1JeYQfBvsBCBeulSZNLTPig2WF+ht4ki70uIt0eNOIN6IxDQ+J7R7+BYJXhLdZzLyT71lg5Nk7Zh21SvEAmnjCDZtPo7MKg5NRZJSxut7n0puKi9AB400Kni89T5lR4f7+BzoSMF0ykC9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499205; c=relaxed/simple;
	bh=+hOoUU9n7WZF2PkiZD5YOlsZdANo9xISWc/bP/NaC64=;
	h=Date:To:From:Subject:Message-Id; b=Zjm160883M1NIHvYmFoDjDd1wu7lLteaCpxL0ohcKOyu+LlAc8BuubWoKh+pHX2yWeCIjf2PEV7/xNHtT3V5vsSz91r1WwFuOrALiXTAtuBa6rh9qMGHmrE+C8Fy0YScWczsSUFfbJQuNGHmNOEb4ddRrB4Eg9R2m0X5/Q6Zpug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b+OuGSB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+OuGSB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41C7C19424;
	Sat, 18 Apr 2026 08:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499205;
	bh=+hOoUU9n7WZF2PkiZD5YOlsZdANo9xISWc/bP/NaC64=;
	h=Date:To:From:Subject:From;
	b=b+OuGSB+kltsFYAtwF+YPpzSmL8/vDblkfnqpPCZO0B/oPBtEjuW4LstTWja1V1y6
	 DWx7HDpDEC13I8wX8qAeIIGXo1Z2rYsxtMNLYTNRcBwgxi2norbRVaFkyn8m34/iQ9
	 AgeJU6bCPzLz524KecpzQhoQjyrGvTPxZvAgRwWQ=
Date: Sat, 18 Apr 2026 00:59:58 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,koichiro.den@canonical.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-avoid-false-positive-wuninitialized-warning.patch removed from -mm tree
Message-Id: <20260418080004.A41C7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: avoid false-positive -Wuninitialized warning
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/vmscan: avoid false-positive -Wuninitialized warning
Date: Tue, 14 Apr 2026 08:51:58 +0200

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

Shut up the warning by adding a fake initialization to the two instances
of this variable that can run into that corner case.

Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com/
Link: https://lore.kernel.org/20260414065206.3236176-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Koichiro Den <koichiro.den@canonical.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-false-positive-wuninitialized-warning
+++ a/mm/vmscan.c
@@ -4760,7 +4760,7 @@ static int scan_folios(unsigned long nr_
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4779,7 +4779,7 @@ static int get_tier_idx(struct lruvec *l
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
_

Patches currently in -mm which might be from arnd@arndb.de are


