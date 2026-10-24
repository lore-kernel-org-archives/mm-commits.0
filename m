Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832446;
	b=LfshXJfsgmRvhGXuCxO6aj8DOqyxleTsnQXGwJjHyrViUTgL4idudQVDt46jhysiN8Kx
	 4QpWKUyx33PcBFgfaAvi8CzcwahJ1ztjfTeXUn2JsPRqF2uJZx1K2LQSAs0q7owCsFZfU
	 r5J7RkKCROFATF1bQZMdYL72Gk3Of4lbVlQkvYTbVfnR5HtQhSFLu7Y87I/mN9sYVHH9z
	 8ZYzuIiz0g5iYuTEiQLfvcypjsAFv54omItlJ9+4rPw627CZJxEXxMQMLkZBNtp7H5pKo
	 d87jweWpjkHZw889TWwu1bm1ZLKgQupEWRiLdIseH/3mmDV91ykJvfdnLdX/AFqBKIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832446;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DMBC0JTio5EbmEg1Oyrw6h9AFbVGLRJcGzUqGncZ2ck=;
	b=B0vDPyCkNwGW316pR7vKvhSvFQ7dchmkVUxhsCJaKr20luB6wsw/ypW6YCFPZUIwHUno
	 7gfQhWrx1Lc2CrOcZyjbJhQFAZ24E1pPSfPmAEJeqJ79qnn0FjqRjaQCoGqOvmcYZP13Q
	 wNWW8lDcUKssUGIfm2r1EoV5oNnHBzQZMI21sNRolLfW5lVQn8y7kDmyCvOcqmRl5d+5V
	 YKCvuETwwmo95MBE61Xrko2AAi+M0PagO3mC0ENAJyCAQscPh+NzdrcH6VxCjzQOsiZQi
	 B5fSQjNpJdC8xjh4VGaq0pRgz//oe/rJ+DvMqY0zzKMk4w4GMliSn393NuS/TC3RGCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="f7/oExNi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA96E606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f7/oExNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59341F01825;
	Sat, 24 Oct 2026 09:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832445;
	bh=DMBC0JTio5EbmEg1Oyrw6h9AFbVGLRJcGzUqGncZ2ck=;
	h=Date:To:From:Subject;
	b=f7/oExNiLi3BqSl4NJUJgVJ8x5zuMfy4hZdTCmXA4oAYfIc1H7c1J+H8cGAiC8DvI
	 mColvlvVWUmKiSuyylG7PDsOFuCo3vVRnXIKWadYfF7/apGLAzyiaazjLL40kIfabZ
	 IAsR3fi5Sciek+9mLvSDHWq3DUXVlt1ZOpW9qDmE=
Date: Sat, 24 Oct 2026 02:00:45 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch removed from -mm tree
Message-Id: <20261024090045.B59341F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb_cgroup: add trailing #endif comment for include guard
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb_cgroup: add trailing #endif comment for include guard
Date: Sat,  3 Oct 2026 14:00:29 +0800

The final #endif that closes the _LINUX_HUGETLB_CGROUP_H include guard
is left without a comment.  Add the macro name to the comment for
consistency and easier navigation.

Link: https://lore.kernel.org/20261003060029.2152489-2-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 include/linux/hugetlb_cgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard
+++ a/include/linux/hugetlb_cgroup.h
@@ -268,4 +268,4 @@ static inline void hugetlb_cgroup_migrat
 }
 
 #endif  /* CONFIG_CGROUP_HUGETLB */
-#endif
+#endif /* _LINUX_HUGETLB_CGROUP_H */
_

Patches currently in -mm which might be from lienze@kylinos.cn are


