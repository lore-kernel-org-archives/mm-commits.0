Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD75230999
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836931; cv=none; b=g7siii6F9uWBLkyhb8IBNG2+28t0QwLynKs8Z0fxPHcWqjPZI2eNhTh9koHVPLjY37ZIhcXpKb8+y9Oryze2tEVbFZDjpBfxzGvcgFUCxOE7VjqKCYe3O8L6gw2JaJvvIOVZ1su3fjn2hjs1rPk5BCVOiuV5E6q3L8PTyaUBrBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836931; c=relaxed/simple;
	bh=Mj5s6yd4WIlzatctnyiJn5o3hekLpJysvE/N7qXFKvA=;
	h=Date:To:From:Subject:Message-Id; b=mrWUcSzriI/A2PX/GoGMa4SQtqPuygWKHU1QAhzSNdBqTkQN/AusDAuxN7xpBfKY9Ywelir/Jlzpwo//x/61A4HCLB9QqtSfY+d76fbuHJOoD4br1pqcX9XoRt+jet6t55blYsOY0QKYvGXf7QIR11d5m/eiPgNHTPQg64VmLF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zU0fKFlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zU0fKFlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F912C4CEE4;
	Tue, 14 Jan 2025 06:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836931;
	bh=Mj5s6yd4WIlzatctnyiJn5o3hekLpJysvE/N7qXFKvA=;
	h=Date:To:From:Subject:From;
	b=zU0fKFlb2XM/dnz0TnpvVeU/IxvAxeKR4WsmjIhDwUSv5JCnKhWXjwlh+BM5GWisU
	 XsJA9xcSZ1XX9K7ntffwJUK2Y41PBwFqlrFHZniEhUivZx760WvQIqyPFQnXv7DfqD
	 7/Qirj/xuDilLbdeXvGjqzSG2B/7kH9YTDkH6Wqg=
Date: Mon, 13 Jan 2025 22:42:10 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch removed from -mm tree
Message-Id: <20250114064211.7F912C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove duplicate list_empty quota->goals check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: mm/damon/core: remove duplicate list_empty quota->goals check
Daye: Mon, 25 Nov 2024 13:56:55 +0900

damos_set_effective_quota() checks quota contidions but there are some
duplicate checks for quota->goals inside.

This patch reduces one of if statement to simplify the esz calculation
logic by setting esz as ULONG_MAX by default.

Link: https://lkml.kernel.org/r/20241125184307.41746-1-sj@kernel.org
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-duplicate-list_empty-quota-goals-check
+++ a/mm/damon/core.c
@@ -1550,7 +1550,7 @@ static unsigned long damos_quota_score(s
 static void damos_set_effective_quota(struct damos_quota *quota)
 {
 	unsigned long throughput;
-	unsigned long esz;
+	unsigned long esz = ULONG_MAX;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -1572,10 +1572,7 @@ static void damos_set_effective_quota(st
 				quota->total_charged_ns;
 		else
 			throughput = PAGE_SIZE * 1024;
-		if (!list_empty(&quota->goals))
-			esz = min(throughput * quota->ms, esz);
-		else
-			esz = throughput * quota->ms;
+		esz = min(throughput * quota->ms, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
_

Patches currently in -mm which might be from honggyu.kim@sk.com are


