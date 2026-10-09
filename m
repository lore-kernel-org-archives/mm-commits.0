Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF12406804
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525493; cv=none; b=NRlF7LhFoo94VeB31MG2NICtRaJBYszyPygWJNrbgTpQo0uCklR+PlPGgbQ5oWZdkmatk3WpdO38Fomc1xdKB3Dq0ajjWym+5lYak2uM4Bwh5lEsMU3ghTkDij5P80DxPs28Cgr4oTBvplH51G9wvtL9Sd/yiUfHSEkYK+nQqyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525493; c=relaxed/simple;
	bh=lfFsZk42kUXHpzE3MsZOgj1pXJf9ILo9Cw6PybGxzg8=;
	h=Date:To:From:Subject:Message-Id; b=Jtg9kykNh/Rg7mn51Me0GUlTqYLVZwPwwFqJJ9uCSjV1UpKkLVtqzGZZmHpy+fA1rQjLaFG7vFJ69qfTErZCy29YJLpItVlhJF09zB1FfyDXMGkPopg+gO2Uc5Cz4SPSAtfEXmdj+/S8BxlwO5ECV7w1YDPgMzPkQNnQ6yZ80K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0690ovfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0690ovfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059521F00893;
	Fri,  9 Oct 2026 05:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525492;
	bh=OVvngCbuEcC/uL6Pt70h+qOwZM7btLvvNEM9Bl+bHWo=;
	h=Date:To:From:Subject;
	b=0690ovfQhRkWhyCNie61LOTnTf8r801kfTBJebg6Czp10OQMwxxBEaxk+Gy+GPM9O
	 QdELSoBzLT6CcBi7r4emnXPHwodFaoHcQX6PfApjkvGbmX/dKmUsnDUWNCNXupYlSF
	 7j7MdEU5wm6Uqth3AIKSIGj+d40L4oXd1mpgPKsw=
Date: Thu, 08 Oct 2026 22:58:11 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch removed from -mm tree
Message-Id: <20261009055812.059521F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
has been removed from the -mm tree.  Its filename was
     mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
Date: Thu, 10 Sep 2026 20:35:43 +0800

zswap_invalidate() still walks the per-area xarray even when zswap has
never been enabled.  Add a zswap_never_enabled() to skip it.

Link: https://lore.kernel.org/20260910123544.818146-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zswap.c~mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused
+++ a/mm/zswap.c
@@ -1667,6 +1667,9 @@ void zswap_invalidate(int type, pgoff_t
 	struct xarray *tree;
 	unsigned long i;
 
+	if (zswap_never_enabled())
+		return;
+
 	for (i = 0; i < nr_entries; i++) {
 		tree = zswap_tree(type, offset + i);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mincore-use-per-vma-lock-during-page-table-walk.patch

