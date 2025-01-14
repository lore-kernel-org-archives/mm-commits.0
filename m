Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA9322F11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835769; cv=none; b=pgyE+8mYMT00HG12+sj9gZXRtNimzPmJ3+T15GQStKfwIw0iPLLJ3TJqDbTleJwhab3j7wz7iCmyfGlUOKEHSzNzbwc9dJwXukZDIyTgXjNT1livBXT1xf0yKsQt6FsNLtyb6MdXFVjNLuEDZ/c3XozncbgaUGmBXJhj5ETw15w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835769; c=relaxed/simple;
	bh=/JGg1PsN7ELO/916KEpPgtDxk4XxQJdGtMBQ1zdiusc=;
	h=Date:To:From:Subject:Message-Id; b=RDt++nWc/jKqWCrB/c0jbK64TNuXcN8Ep9WGGpRL3unedHXpXquF5xHhKoI8WlH4C9FMa8Y7g8iojxqI/nwDsM9BWV/Q7g3FFbNqpQNut4xPp+Kl9c5RRdO/zP1dHZRurGQTELtAVJK7XFcd5Kic4QYb6hudOt020P3yalX12xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WPyGdsav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WPyGdsav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B22EC4CEDD;
	Tue, 14 Jan 2025 06:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736835769;
	bh=/JGg1PsN7ELO/916KEpPgtDxk4XxQJdGtMBQ1zdiusc=;
	h=Date:To:From:Subject:From;
	b=WPyGdsavG65YSzPYtTl0UzHruOzJj/NuOLuYHW6vkaKNYkRf9O/Jm5/5T/Sqfxt23
	 QRXHshsKgFUi6h4C9K1ylpinEshzDcgkt1F3rGjNQ62s+b/8U9BBel1RMxJybQtNT0
	 IdMnfGswJbsPfFPGnBUV/7U+dVV36GXBbmxKGZBY=
Date: Mon, 13 Jan 2025 22:22:48 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch removed from -mm tree
Message-Id: <20250114062249.1B22EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch

This patch was dropped because it was folded into mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix
Date: Fri Nov 29 08:09:32 PM PST 2024

s/vfree/kvfree/, per Shakeel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix
+++ a/mm/swap_cgroup.c
@@ -158,5 +158,5 @@ void swap_cgroup_swapoff(int type)
 	ctrl->map = NULL;
 	mutex_unlock(&swap_cgroup_mutex);
 
-	kvfree(map);
+	vfree(map);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

