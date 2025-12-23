Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C234B1AC
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517861; cv=none; b=ri+RGwuGLTQwypH2dsBquuC1OAUW2iC4M4XnJbDUER0RUT6K2F6vgJTa84gRtx266+NWYz5CCjtk9YJaiqg2kq5i4RhbU7zt/IJrlg8Pm+OFT83zG0wexVu99hf3WHE9n6u1gcIfbl6jwFfP0snUx1vBF6jvmSyMU9DDu7AfYYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517861; c=relaxed/simple;
	bh=CrGoE8ugytAjtDOxp3xLAXdyPeNCeKXzyEpnRr2XR3E=;
	h=Date:To:From:Subject:Message-Id; b=o2EsrFI1dGUvUkTLXemtjdhR9gTEcf5s4Rxx1+fYFofHWLJG+/zWJI7w0RdpvJ/LSh6+Cdn22zAKypMqTSH33ZZfitPEQgFKgFWI6q6aWzuMHds+qZ6kkOzNboWTlqDMID5uCUIAlhQTDhq0UnEMOXeYrEELdED4raQqdfap3sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K4tTznMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K4tTznMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87478C113D0;
	Tue, 23 Dec 2025 19:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517860;
	bh=CrGoE8ugytAjtDOxp3xLAXdyPeNCeKXzyEpnRr2XR3E=;
	h=Date:To:From:Subject:From;
	b=K4tTznMbsoMl2IMblpYzVag1s5zZ618mAuWChaCpcp0kkaXp0DL7Lh6T9u7EwuXRd
	 AT0g/V/xCA86Pvv9PmoWbDjyRljtNdPOdCeJfV135j297noyE0GBWCV4AxsOQgWJOZ
	 1Nyd0ebxVzVpZIJkqGP6s7Z2J9rMhyysq6Mf8uns=
Date: Tue, 23 Dec 2025 11:24:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch removed from -mm tree
Message-Id: <20251223192420.87478C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: fix unit conversion for K() macro in OOM log
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: memcg: fix unit conversion for K() macro in OOM log
Date: Tue, 16 Dec 2025 13:20:54 -0800

The commit bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or
alloc failures") added functionality to dump memcg protections on OOM or
allocation failures.  It uses K() macro to dump the information and passes
bytes to the macro.  However the macro take number of pages instead of
bytes.  It is defined as:

 #define K(x) ((x) << (PAGE_SHIFT-10))

Let's fix this.

Link: https://lkml.kernel.org/r/20251216212054.484079-1-shakeel.butt@linux.dev
Fixes: bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or alloc failures")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Chris Mason <clm@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log
+++ a/mm/memcontrol.c
@@ -5638,6 +5638,6 @@ void mem_cgroup_show_protected_memory(st
 		memcg = root_mem_cgroup;
 
 	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
-		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
-		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
+		K(atomic_long_read(&memcg->memory.children_min_usage)),
+		K(atomic_long_read(&memcg->memory.children_low_usage)));
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

lib-buildid-use-__kernel_read-for-sleepable-context.patch

