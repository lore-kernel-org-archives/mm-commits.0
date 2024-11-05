Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF01D172A
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 06:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788173; cv=none; b=DnANYUeuEBqW2E6YkzRucgd/wQi4kxjUgfLUZ0ykd+mxrC6rJEFvLONKWcWp24hSXQNAP5NVTcbnETu2GMHlChmoOZ66nidDradDsGWYyCmisstNCNaVML9WmWSDsnUg2x0n57WGZKUXO7WfF64UwS2L2HXJxk1nteO90Xr5jDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788173; c=relaxed/simple;
	bh=n9gxegr2VCPqHPJuI9nvUV2lvm51zP6N/iBO/a3QFlE=;
	h=Date:To:From:Subject:Message-Id; b=ATDwpS61mGwOlYkyCaxDgVjD1lEP9dN55fK0QkAxRjw4bA5hHNVf27I5CMx7DRSLcinMcOqla/XNHMa2KBFDWvZ5ntEPc/woF/z+z/Ev+QNpjF73blHRbNP3Z1YGrjopJxlD49DzNer5xRIYKw2rZFWx2ftajcBl+dQ6RsUE9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hv2374rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hv2374rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C985BC4CECF;
	Tue,  5 Nov 2024 06:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730788172;
	bh=n9gxegr2VCPqHPJuI9nvUV2lvm51zP6N/iBO/a3QFlE=;
	h=Date:To:From:Subject:From;
	b=hv2374rEVER7yf/R9lGrydChI3hFzTR+xfCnJwmmNUDKR4PA3zzqerYo5VxnCU3RU
	 hs+fZNX63JKg5ROySAzpZxZM3nJch4PxKkdBo6eSAv7bYH51sO+E4BuWj+qdG93A/S
	 VHTg3uksiQcRe/TEVhxrKgjiBZzNEtN54gZAuOO8=
Date: Mon, 04 Nov 2024 22:29:32 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch removed from -mm tree
Message-Id: <20241105062932.C985BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
has been removed from the -mm tree.  Its filename was
     memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

This patch was dropped because it was folded into memcg-v1-no-need-for-memcg-locking-for-mglru.patch

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
Date: Mon, 4 Nov 2024 10:30:29 -0700

remove !rcu_read_lock_held() assertion

  WARNING: CPU: 0 PID: 85 at mm/vmscan.c:3140 folio_update_gen+0x23d/0x250 mm/vmscan.c:3140
  ...

This assertion is incorrect after this patch series that has removed the
charge migration and has removed mem_cgroup_trylock_pages() /
mem_cgroup_unlock_pages() from the caller of this function
(folio_update_gen()).

The assertion was caused by the patch in this thread.  It used to assert
that a folio must be protected from charge migration.  Charge migration is
removed by this series, and as part of the effort, this patch removes the
RCU lock.

Link: https://lkml.kernel.org/r/ZykEtcHrQRq-KrBC@google.com
Link: https://syzkaller.appspot.com/bug?extid=24f45b8beab9788e467e
Link: https://lore.kernel.org/lkml/67294349.050a0220.701a.0010.GAE@google.com/
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru-fix
+++ a/mm/vmscan.c
@@ -3137,7 +3137,6 @@ static int folio_update_gen(struct folio
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
 
 	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
-	VM_WARN_ON_ONCE(!rcu_read_lock_held());
 
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-page_alloc-keep-track-of-free-highatomic.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch

