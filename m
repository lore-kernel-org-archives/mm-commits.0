Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510581EA90
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577540; cv=none; b=hoWBfQksk6GxnGZwGn8yxlUPk6v2ERC6ij6HqBa69i4dBuriUQmOnF1Mg+iTPzgUqseeTsU/kikM6Y1XbrrwXGGC/U75HHDP33g2x9cw/QS6zJUNJ9HGXMQ6QMicXvZzLCFXyeVpEmQvSC/3nONjxNe/hDiKwOEQQ0apfuFgCfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577540; c=relaxed/simple;
	bh=F7ZRodBUn62ShyRQ1TeI0E/3Mxp8FdifaGuSwpQToXw=;
	h=Date:To:From:Subject:Message-Id; b=uW4YMZfVq8bUT87oLox4mPOoyOq3tcIYWAZ+vYH3k9dfrW1DTb1dJD6iIU7qkNGnZUTw+qKmzfWqSDdzJMxlbDaRpSJ8Y9p8bTWQH896fygUhE+jrhM2+0RILK9XPGv7eoeoLqR/0vYMnY5BnqFW6iuWc+2r7umjhb9oXm/3mDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GycNhN8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GycNhN8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2205C4CECD;
	Thu, 19 Dec 2024 03:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577539;
	bh=F7ZRodBUn62ShyRQ1TeI0E/3Mxp8FdifaGuSwpQToXw=;
	h=Date:To:From:Subject:From;
	b=GycNhN8ETt9j3+J4qPB6ysZHia+4+KeifS61c8Brvuy0oQp1GLnduJvtiVcAtbVHB
	 u9PCYiOsdYv4gXvCfZc76A3etz6QfNdfTZLj4s0pzPJhE+khBtwwEus96BPHhYrKSm
	 igXRozrWaaruTuM+fCYYiub/xWoLk1TSpGGZoTsU=
Date: Wed, 18 Dec 2024 19:05:39 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,koct9i@gmail.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmstat-fix-a-w=1-clang-compiler-warning.patch removed from -mm tree
Message-Id: <20241219030539.D2205C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: fix a W=1 clang compiler warning
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-a-w=1-clang-compiler-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm/vmstat: fix a W=1 clang compiler warning
Date: Thu, 12 Dec 2024 13:31:26 -0800

Fix the following clang compiler warning that is reported if the kernel is
built with W=1:

./include/linux/vmstat.h:518:36: error: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Werror,-Wenum-enum-conversion]
  518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
      |                               ~~~~~~~~~~~ ^ ~~~


Link: https://lkml.kernel.org/r/20241212213126.1269116-1-bvanassche@acm.org
Fixes: 9d7ea9a297e6 ("mm/vmstat: add helpers to get vmstat item names for each enum type")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-fix-a-w=1-clang-compiler-warning
+++ a/include/linux/vmstat.h
@@ -515,7 +515,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
_

Patches currently in -mm which might be from bvanassche@acm.org are


