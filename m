Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AA1FF5E3
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343088; cv=none; b=QaP/mV7u2ZtgZvaykxCOTg1FmU8HaHpeJ+3IbYOydVRiH313ayA0mLTa8OC4sw0JDFL5EPzlNksXJZ37oX7p1wPDhchXmHIlDe2FbItKvynQSIKJGLBuLp6CR/DwGniUFwlC8wcwGItSxNUPkA/geIdn+VwF0QTbhFPzkgHrHaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343088; c=relaxed/simple;
	bh=6lyoa4UllpFmd4pi/Z9m92r5VCuE/6jpRFWbtLgR1CA=;
	h=Date:To:From:Subject:Message-Id; b=DvtyzaNTu5+IdC+OkpZRxdGkyVRlEWxB4vpeFkfHZ1OtJ+Qb4Ro7IckMeIWKQuJKXjcejpBZ079zdJO3Sz8tU94mUtLxs8vNtlrhNHLktwzy547g6+kAKUdyirzbN52qD22+cPOtRQrFt+tzSsszGxKx30BCBiMIdZ0vu1QTBvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PRyaayKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PRyaayKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1608BC116D0;
	Mon, 17 Nov 2025 01:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343088;
	bh=6lyoa4UllpFmd4pi/Z9m92r5VCuE/6jpRFWbtLgR1CA=;
	h=Date:To:From:Subject:From;
	b=PRyaayKZdqD3dUOT+6GIBJLm7M0Kpw0dI5CFJ0zcjIoYwKzgz423FTCnZYG3LFEIi
	 O/SgmEoSP8OxPIiQxo/rhj/jB9wEMA5H0Mm6EYZa1UzymCj/k3lCyKMA3sQGZsvbJh
	 KpVsamdqbjN2ByDhYNdonWj2xvfRsDpn3v9Hv7BY=
Date: Sun, 16 Nov 2025 17:31:27 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch removed from -mm tree
Message-Id: <20251117013128.1608BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip might_alloc() warnings when PF_MEMALLOC is set
has been removed from the -mm tree.  Its filename was
     mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: skip might_alloc() warnings when PF_MEMALLOC is set
Date: Tue, 7 Oct 2025 14:20:33 +0200

might_alloc() catches invalid blocking allocations in contexts where
sleeping is not allowed.

However when PF_MEMALLOC is set, the page allocator already skips reclaim
and other blocking paths.  In such cases, a blocking gfp_mask does not
actually lead to blocking, so triggering might_alloc() splats is
misleading.

Adjust might_alloc() to skip warnings when the current task has
PF_MEMALLOC set, matching the allocator's actual blocking behaviour.

Link: https://lkml.kernel.org/r/20251007122035.56347-9-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/sched/mm.h~mm-skip-might_alloc-warnings-when-pf_memalloc-is-set
+++ a/include/linux/sched/mm.h
@@ -318,6 +318,9 @@ static inline void might_alloc(gfp_t gfp
 	fs_reclaim_acquire(gfp_mask);
 	fs_reclaim_release(gfp_mask);
 
+	if (current->flags & PF_MEMALLOC)
+		return;
+
 	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are


