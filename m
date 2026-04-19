Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA8E309EEB;
	Sun, 19 Apr 2026 06:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776579943; cv=none; b=i4Yrn7tfaKTZKFc/aBJolAp3gLEK0Efr1/cjw20eTBe9G+pfOpjLTOUnEq3At9cqtbO5Jx5yjPvSkGbOUI/uvbReYqfpqTjPJawR+NhdXAQ8deZLhtVoNKIBBO3DzT2gTtf6SH7OTjbScRc83qzXk0ST4CqmpBiwZT2JLvmLYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776579943; c=relaxed/simple;
	bh=GI9z+HVw7et4Hicvudtlmggkyiwu7fx6ClNVf2imS9c=;
	h=Date:To:From:Subject:Message-Id; b=h99B25U2tQhuKJp+UAf1W01AJ5IljXEUcaBCngqsZRVlcu4q+FhnKKTyET2aGTrDdP3rdyV64ZAhVQtLy12tv9lErAamXoYEyUBvQMBg40Vgaiftuo9bcWSKQguJ2Kc7D2Iucb2xsoUYi/K0NX8nMvSotrktrjBBy8DcOsjp1kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVm9uv9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVm9uv9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DF8C2BCAF;
	Sun, 19 Apr 2026 06:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776579943;
	bh=GI9z+HVw7et4Hicvudtlmggkyiwu7fx6ClNVf2imS9c=;
	h=Date:To:From:Subject:From;
	b=JVm9uv9LWnm6E/IMjvkqV+oEUaUspiuLWRJI4y19/Umg9FOEPad7EiVM8nLnUfj4j
	 zwWPZA8IaKeKDC1Q4A1WiqZgVAQn/zDBg9VJf3MLkPsrCiIOiTAKS3Yr7WGVIE6NAa
	 HxOaRp7Aq4x2J6pDkoiN/G7Un/4385u95MlADZqk=
Date: Sat, 18 Apr 2026 23:25:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,chenyichong@uniontech.com,baoquan.he@linux.dev,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-take-vmap_purge_lock-in-shrinker.patch removed from -mm tree
Message-Id: <20260419062542.F3DF8C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: take vmap_purge_lock in shrinker
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-take-vmap_purge_lock-in-shrinker.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: take vmap_purge_lock in shrinker
Date: Mon, 13 Apr 2026 21:26:46 +0200

decay_va_pool_node() can be invoked concurrently from two paths:
__purge_vmap_area_lazy() when pools are being purged, and the shrinker via
vmap_node_shrink_scan().

However, decay_va_pool_node() is not safe to run concurrently, and the
shrinker path currently lacks serialization, leading to races and possible
leaks.

Protect decay_va_pool_node() by taking vmap_purge_lock in the shrinker
path to ensure serialization with purge users.

Link: https://lore.kernel.org/20260413192646.14683-1-urezki@gmail.com
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-take-vmap_purge_lock-in-shrinker
+++ a/mm/vmalloc.c
@@ -5416,6 +5416,7 @@ vmap_node_shrink_scan(struct shrinker *s
 {
 	struct vmap_node *vn;
 
+	guard(mutex)(&vmap_purge_lock);
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 
_

Patches currently in -mm which might be from urezki@gmail.com are


