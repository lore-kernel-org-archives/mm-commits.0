Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D954119FA;
	Fri,  9 Oct 2026 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525516; cv=none; b=MjVqAJ2b053/LMeltMj9L6UoV34XYAYeNiibtVkpaUbnQOmblYq+U6Rq72Ay+N8wodfHxVHCjMZmDgnr//J0jaImJuI+sTQBwudxK8NTLJ7scIljyRPZGaxMWkWpGWktAhYo31hBcjFL/AMRDR7CTaj4twRpkIHj8sWXBLzac3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525516; c=relaxed/simple;
	bh=EsqqXqwYaGtYaXVjbeyXvqvu+aYZvTacMnB9coYvjeA=;
	h=Date:To:From:Subject:Message-Id; b=ueO7tKopjLQLqkgc8ApmZrIgVRKviqRkRcG8w5VZOdb2l3tF2f+IkIcaw50Inel0QURRtYtWqBVSvD2bC2RtdmikJfO964sMuJ+CieueYUvAB9sub/2okXM+PHoVsapkEdMDjmlulniy2QmhavR0E4DlbwPUvypfduyEDitsm8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZL97q7CK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZL97q7CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1511F000FF;
	Fri,  9 Oct 2026 05:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525515;
	bh=L1XMLg/6P8xhyj9ZvlUcshKoYRkfy6/gGMYSJ5K3mak=;
	h=Date:To:From:Subject;
	b=ZL97q7CKlddu5u9dPZN39+uuYWxw0t5CE0UfaEFcNshr7Mp99rxRUPl/e7ql3+dwJ
	 LfQnA1TzTHiH6uxER5bjpdCin1dEk4HdCNLOa7PrI42P3/lIYskrKJ3MOyofbVqq7S
	 zhKa/ZKIs461IjB2QoFt1Of5VVUzioun1jZTP/aM=
Date: Thu, 08 Oct 2026 22:58:34 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_counter-avoid-integer-overflow-in-effective_protection.patch removed from -mm tree
Message-Id: <20261009055835.1B1511F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_counter: avoid integer overflow in effective_protection()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-avoid-integer-overflow-in-effective_protection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/page_counter: avoid integer overflow in effective_protection()
Date: Mon, 7 Sep 2026 10:54:44 +0800

Patch series "mm/mglru: fix ineffective memory protection for non-kswapd
reclaim", v4.

For MGLRU, memory.min/low is not honored during non-kswapd global reclaim
(global direct reclaim and root-level memory.reclaim), because these paths
shrink memcgs using stale protection (emin/elow).

Patch 2 is the actual fix.  Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which patch
2's new caller would also be exposed to.


This patch (of 2):

effective_protection() scales a parent's protection by a ratio of page
counts, e.g.  for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

The multiply is done at unsigned long width before dividing.  On systems
with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
protection value and silently breaking memory.min/low enforcement.

Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate.  Because
usage and parent_usage are not read atomically (a child is charged before
its parent), usage - protected can briefly exceed the divisor, making the
quotient overflow 64 bits and trap (#DE on x86).  Cap it so the ratio
stays <= 1.

Reported by the sashiko review tool [1].

Link: https://lore.kernel.org/20260907025445.1836238-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260907025445.1836238-2-ridong.chen@linux.dev
Link: https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1 [1]
Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-4-8
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_counter.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-avoid-integer-overflow-in-effective_protection
+++ a/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -376,7 +377,8 @@ static unsigned long effective_protectio
 	 * otherwise get a smaller chunk than what they claimed.
 	 */
 	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
+		return mul_u64_u64_div_u64(protected, parent_effective,
+					   siblings_protected);
 
 	/*
 	 * Ok, utilized protection of all children is within what the
@@ -417,13 +419,20 @@ static unsigned long effective_protectio
 	if (parent_effective > siblings_protected &&
 	    parent_usage > siblings_protected &&
 	    usage > protected) {
-		unsigned long unclaimed;
+		unsigned long parent_unclaimed, parent_unprotected, unprotected;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		parent_unclaimed = parent_effective - siblings_protected;
+		parent_unprotected = parent_usage - siblings_protected;
 
-		ep += unclaimed;
+		/*
+		 * The usages aren't read atomically, so a child can transiently
+		 * appear to use more than its parent, making the ratio exceed 1
+		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
+		 */
+		unprotected = min(usage - protected, parent_unprotected);
+
+		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected,
+					  parent_unprotected);
 	}
 
 	return ep;
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

