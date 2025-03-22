Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD9812F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619834; cv=none; b=uYRWhhdtUAYBDgoav9k8Kj4N8ZZP6+DoL+XNu8ZCXRmIivP6MoDS5Ser/adazsjsXHReNIV4bmpMVCR4em5PuGH6Y1KrfLYOIkLvq7mYz92YlqH6fxe33GC5Ngz3bDIxDbRaHAUgq0WDCCONCJURGu/fSQAjCQQCYuyzYJ9CezU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619834; c=relaxed/simple;
	bh=OzwciPl3l6Is4iGrM4DpvPsRMegWvQgcLIhXoUZHYFw=;
	h=Date:To:From:Subject:Message-Id; b=OETvnrvaMr2KbNqIYnanc/MdGJGgPaRYLUy1kCnC0nROocsknGxHfTnvOIBh1BgL7+yJ6wxbXKDzPBU191F9iSc2MypJGYAa/8U4mSfBC9u2AEva0rYpa12Fl89D7E2gshmDeZVezacMYAyUbfJTubdD8ctVT0wc+6UY+J6O2VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vElRQYGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vElRQYGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8241C4CEDD;
	Sat, 22 Mar 2025 05:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619833;
	bh=OzwciPl3l6Is4iGrM4DpvPsRMegWvQgcLIhXoUZHYFw=;
	h=Date:To:From:Subject:From;
	b=vElRQYGwVAmWa1BPsbKqOdRw8SzxwToWynClJsv+cVsvVzhYA4xxTMkavlcr3q2zi
	 hArpllsKimJbxOv83bPDEEOFYGKTUVs8UVT9vrdjq4q8oKziPHoS+QaLJoSc5Pp9ZY
	 ej23+GInZCCGjBcpOrs/0dc611gidgAtkxSS3s8o=
Date: Fri, 21 Mar 2025 22:03:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-folio_memcg_charged.patch removed from -mm tree
Message-Id: <20250322050353.D8241C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify folio_memcg_charged()
has been removed from the -mm tree.  Its filename was
     mm-simplify-folio_memcg_charged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify folio_memcg_charged()
Date: Fri, 14 Mar 2025 13:36:14 +0000

There's no need to check which kind of pointer is in the memcg_data field,
all we actually care about is whether it's zero or not.  Saves 70 bytes in
workingset_activation() with the Debian config.

Link: https://lkml.kernel.org/r/20250314133617.138071-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-simplify-folio_memcg_charged
+++ a/include/linux/memcontrol.h
@@ -438,9 +438,7 @@ static inline struct mem_cgroup *folio_m
  */
 static inline bool folio_memcg_charged(struct folio *folio)
 {
-	if (folio_memcg_kmem(folio))
-		return __folio_objcg(folio) != NULL;
-	return __folio_memcg(folio) != NULL;
+	return folio->memcg_data != 0;
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


