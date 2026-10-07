Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA616175A8D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334138; cv=none; b=OlGJCrcuD+HgY5CSFwWFpyOsV3M7+K5WlyP8aHhHy+aXqcvp5kbbNhSg1pDLtkrARelF6LHrpXf6SfYArLzelWHCb4qqdFlXWswz/BaA0QaPGXbeFGbpz9edqNJTxuf0hxyw9DxWdJbXIAQsE1HSSFhGxYrfLEwS0/mdGT0bGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334138; c=relaxed/simple;
	bh=baAYHUed6mMJlWz1v2Q+59kC6cFcYNEK0yb1Bu5z4Gc=;
	h=Date:To:From:Subject:Message-Id; b=Yg4lp9o5RkOLNjQrwvMRdtnhY9z6j6XglRYV8uozGEclSyde+2/ocGA3MXUAcfD2SMqII9ald0bpBkmLC4vDMNVAWcJK6kKgoRfEzd+Nvt2JuRLxVM8eJfhIlp7+A314XPWnCcDKmveo4nmciGrXc8iF4nuc4XE4yvtpziM7oWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d2bi8OeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d2bi8OeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2AE1F0089C;
	Wed,  7 Oct 2026 00:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334137;
	bh=JEPdgOsstNj9hSiT2qaLlLaasZWoktEGHIcKf6u6ujQ=;
	h=Date:To:From:Subject;
	b=d2bi8OeN8AGyTeKmfTSz0qFhNyfnYaHPtgnAYlqcZ3riYIUYs+6J+sfvCdGX+1yl9
	 hibQMz82m6CfGco0Z/AUEnKwXGtp1lmcjoNzV+ZZUXTP+JrcTgJNBU0SEuAr5MwQY1
	 HeHGf2YcCn0dy1kAFC1OPed7G/EHztQfGGiJmDlw=
Date: Tue, 06 Oct 2026 17:48:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,hao.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-anon_vma_trylock_write.patch removed from -mm tree
Message-Id: <20261007004857.AE2AE1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused anon_vma_trylock_write()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-anon_vma_trylock_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Li <hao.li@linux.dev>
Subject: mm: remove unused anon_vma_trylock_write()
Date: Thu, 27 Aug 2026 15:18:06 +0800

The last user of anon_vma_trylock_write() was removed by cc22b9978509,
leaving the helper unused.  Remove it.

Link: https://lore.kernel.org/20260827071845.17636-1-hao.li@linux.dev
Signed-off-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/internal.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/internal.h~mm-remove-unused-anon_vma_trylock_write
+++ a/mm/internal.h
@@ -295,11 +295,6 @@ static inline void anon_vma_lock_write(s
 	down_write(&anon_vma->root->rwsem);
 }
 
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
 static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
 	up_write(&anon_vma->root->rwsem);
_

Patches currently in -mm which might be from hao.li@linux.dev are


