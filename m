Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4746A204936
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374575; cv=none; b=etoXWS5mE1hqM9/NMrb44ByreaOVdGea225VHr6YvWTPnnPsLSFXshQ613hk8hxTsFgfcoOK13rn0Zou11HmZ8o/tRBDPP/YyMDBY+sKUgi1/zslCeHSLx79pY2SM10BilXQrXH8AJ9+B0esr5bDMim7TIgnm9empyKuG55xOdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374575; c=relaxed/simple;
	bh=/6ISpsSsaPk/jzfd2+FcfL0fwSMZftk7XR6g2mYF3yw=;
	h=Date:To:From:Subject:Message-Id; b=ogCmG7h1VtuBRrdi2JCCpEqd6wDLOW2dl0U1RrhtX4qQGIIoGmMRW7SR91XpT1+c/Tlv61RA7YQD4kQ5E6f65lMinl0o9/medWLE+0XAsQDi09B/3TCwNrvJ0FCr61ZKQ3N1w8aSPT11LhER6H2YooDBAMy/19/qWrZCrc2ipzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fCinfzcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fCinfzcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B79DC4CED0;
	Tue, 12 Nov 2024 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374575;
	bh=/6ISpsSsaPk/jzfd2+FcfL0fwSMZftk7XR6g2mYF3yw=;
	h=Date:To:From:Subject:From;
	b=fCinfzcdLDrZLKrE/kkFwj3cjwvATn/ci9hA9JjVKiyTFjaLfBF/VgjsxENKagX0z
	 u89EztU8EqrbTe14gLiCctH4NNpQfwl8oBi8lF178k48vTF59/9TEJpk5nEhIN4iXK
	 lUIzb60ejXMr0XERLJVAvKreXMFaTJVf9PGxU89o=
Date: Mon, 11 Nov 2024 17:22:54 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-dont-export-list_lru_add.patch removed from -mm tree
Message-Id: <20241112012255.0B79DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: don't export list_lru_add
has been removed from the -mm tree.  Its filename was
     mm-list_lru-dont-export-list_lru_add.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/list_lru: don't export list_lru_add
Date: Tue, 5 Nov 2024 01:52:53 +0800

It's no longer used by any module, just remove it.

Link: https://lkml.kernel.org/r/20241104175257.60853-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-dont-export-list_lru_add
+++ a/mm/list_lru.c
@@ -106,7 +106,6 @@ bool list_lru_add(struct list_lru *lru,
 	spin_unlock(&nlru->lock);
 	return false;
 }
-EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
_

Patches currently in -mm which might be from kasong@tencent.com are


