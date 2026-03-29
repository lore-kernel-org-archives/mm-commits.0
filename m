Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A095255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744894; cv=none; b=F+hXZTj1k4nDdSCBQ9FcVDV8lLNRuzSOomFUH/b1LEPiuM4SNnuLsfyOwCzfd+GNA0oHiVMRUyT3p/oMq2A0qiPZ5MzWTKsxAr54YVj5diB6Bj+VcikeHfzrlGOHIcrOfcq5xyzsPK9XcV6s4zBwscXkdy+8O4gQN5vk+V5QWrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744894; c=relaxed/simple;
	bh=AuEZlGzahyNRw7oJQBFJNDDAWA7uGO+5AFVFlbofDX4=;
	h=Date:To:From:Subject:Message-Id; b=dQNFpptEHZvcTMEnxwdfbM39Zjsuzl3+WvbJBCgoz5WoKDKn2Hf4epGiWf1ABVkEkSCVSFLlE59OQ4BW8G/Y6UgkedxuaPC1WOgjTSFRIBpE2jDX2NUixFLAwBVyIu4QVcCggKuMryxKMxfKIR4ErW0v2NJcYifCgXt4ePwuHys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SYu4uaBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SYu4uaBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D601CC4CEF7;
	Sun, 29 Mar 2026 00:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744893;
	bh=AuEZlGzahyNRw7oJQBFJNDDAWA7uGO+5AFVFlbofDX4=;
	h=Date:To:From:Subject:From;
	b=SYu4uaBHDKZWv529HAItLcdhRTLJzNno95AFhbQxRq+QK+64111orYwFWsHIwazLm
	 +e1HppNMOLaK6HgNE1wnRF6vzHlzrx8XxrZoNGFnWrPmZ+FEZVy4ZvLpvh5SKISOoS
	 YMrRF+Ng7yye3a6r9jEPPqaoGZqs/Sk07P07sucg=
Date: Sat, 28 Mar 2026 17:41:33 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch removed from -mm tree
Message-Id: <20260329004133.D601CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix wrong end address assignment on walk_system_ram()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix wrong end address assignment on walk_system_ram()
Date: Tue, 10 Mar 2026 22:29:22 -0700

Patch series "mm/damon: support addr_unit on default monitoring targets
for modules".

DAMON_RECLAIM and DAMON_LRU_SORT support 'addr_unit' parameters only when
the monitoring target address range is explicitly set.  This was
intentional for making the initial 'addr_unit' support change small.  Now
'addr_unit' support is being quite stabilized.  Having the corner case of
the support is only making the code inconsistent with implicit rules.  The
inconsistency makes it easy to confuse [1] readers.  After all, there is
no real reason to keep 'addr_unit' support incomplete.  Add the support
for the case to improve the readability and more completely support
'addr_unit'.

This series is constructed with five patches.  The first one (patch 1)
fixes a small bug that mistakenly assigns inclusive end address to open
end address, which was found from this work.  The second and third ones
(patches 2 and 3) extend the default monitoring target setting functions
in the core layer one by one, to support the 'addr_unit' while making no
visible changes.  The final two patches (patches 4 and 5) update
DAMON_RECLAIM and DAMON_LRU_SORT to support 'addr_unit' for the default
monitoring target address ranges, by passing the user input to the core
functions.


This patch (of 5):

'struct damon_addr_range' and 'struct resource' represent different types
of address ranges.  'damon_addr_range' is for end-open ranges ([start,
end)).  'resource' is for fully-closed ranges ([start, end]).  But
walk_system_ram() is assigning resource->end to damon_addr_range->end
without the inclusiveness adjustment.  As a result, the function returns
an address range that is missing the last one byte.

The function is being used to find and set the biggest system ram as the
default monitoring target for DAMON_RECLAIM and DAMON_LRU_SORT.  Missing
the last byte of the big range shouldn't be a real problem for the real
use cases.  That said, the loss is definitely an unintended behavior.  Do
the correct adjustment.

Link: https://lkml.kernel.org/r/20260311052927.93921-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260311052927.93921-2-sj@kernel.org
Link: https://lore.kernel.org/20260131015643.79158-1-sj@kernel.org [1]
Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram
+++ a/mm/damon/core.c
@@ -3068,7 +3068,7 @@ static int walk_system_ram(struct resour
 
 	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end;
+		a->end = res->end + 1;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

