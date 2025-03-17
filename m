Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7021B21577C
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188271; cv=none; b=NY91LfQW7Bvo4ifZtA3D26k956svtCc2cwhXY4RA3xhZE9Axx2CfzOTZVC55Myo6JWF883CceM9Vx05GJNJ7wmTP3ZsTMgIPChyIubvSUIQmaX8Bx7zqpJ8Z3nCckSg1qYVJckla9pVAOEAl0M7s8qB+UwNp8A4xVx/OCeLu9kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188271; c=relaxed/simple;
	bh=gQrl1kcGDlWi0Vvn2qkVIICi6duCNgq9G6c93ng3ouU=;
	h=Date:To:From:Subject:Message-Id; b=CRPG0CNfS+l2Jk66hr67fuu4ebpDGSlHhK2SMlVvByny64C69Lh+w6P5p0VAOXJGEYXC2C8I+zELClqrN0Li957kb9hJSEcKYz/lkffGz3a8D+9lfZfLV19ZmLAIhw+yxPEa22gG7sMBiBfM0WuCJI1xLGBV2g/38b6I5dtszss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CGM8zDc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CGM8zDc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43498C4CEEC;
	Mon, 17 Mar 2025 05:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188271;
	bh=gQrl1kcGDlWi0Vvn2qkVIICi6duCNgq9G6c93ng3ouU=;
	h=Date:To:From:Subject:From;
	b=CGM8zDc60vE85RpV56b+/elYbV734yxrIGoTUgkVniLJPShZTAM393CTwUGGkoMnR
	 dxgIgyHZYzQrt8pr6B7S8PkzuxJMlQt8tluuD0cfei8hZxQg0x6BLYPRm8S1ofvZNs
	 TQXVSX9NYcdwZe7yMBFJki4pA8111XkGYwW9pBNs=
Date: Sun, 16 Mar 2025 22:11:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,nathan@kernel.org,intelfx@intelfx.name,david.laight@aculab.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch removed from -mm tree
Message-Id: <20250317051111.43498C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: revert "fix a W=1 clang compiler warning"
has been removed from the -mm tree.  Its filename was
     mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm/vmstat: revert "fix a W=1 clang compiler warning"
Date: Tue, 11 Feb 2025 12:59:11 -0800

Commit 75b5ab134bb5 enabled -Wenum-enum-conversion in W=1 builds.  Commit
30c2de0a267c ("mm/vmstat: fix a W=1 clang compiler warning") fixed a
-Wenum-enum-conversion warning.  Commit 8f6629c004b1 removed the
-Wenum-enum-conversion option again from W=1 builds.  Since the W=1
compiler warning fix is no longer necessary, revert it.

Link: https://lkml.kernel.org/r/20250211205911.1707684-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ivan Shapovalov <intelfx@intelfx.name>
Cc: David Laight <david.laight@aculab.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-revert-fix-a-w=1-clang-compiler-warning
+++ a/include/linux/vmstat.h
@@ -515,7 +515,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
 }
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
_

Patches currently in -mm which might be from bvanassche@acm.org are


