Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89E18DF76
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925695; cv=none; b=ieKFOoau8LRZ6m91EOpkJR0vL/nLTA7OWU+0hFJV+jYgVCLUxyDSlb9ub9p4f9z8mTQngQyQk4Fhar5GK8T894gzUfcuvLTVXANT9ZkxoqxZSGpGZdmOIsvdIViGneIzAShGFlxz14Il9D8xIOFPncYEPFKweI6mM71wCf7Ues4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925695; c=relaxed/simple;
	bh=O+aI2PD4/JD/rwG+lXhV4gV2GpmCyV0QrtwJ6jkbsgY=;
	h=Date:To:From:Subject:Message-Id; b=jcmKT0M8WQBeIBxWgSXjGO0HN6friDL2qlwUL17RPKe/IoX4Igkdy6DoVU8V230yvccMCYl7E8mKIp6gEcw/3IBOaktEd1vPHnQwmWhlJlEyEtzUCFoL7tKVpdANGZ2HxN08jF5Q1tGXhmZxuYrQtX23BQKBzcybsMqtHwNCsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=odesk8HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="odesk8HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5881C4CEC5;
	Mon,  9 Sep 2024 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925694;
	bh=O+aI2PD4/JD/rwG+lXhV4gV2GpmCyV0QrtwJ6jkbsgY=;
	h=Date:To:From:Subject:From;
	b=odesk8HXvXGJHksEC6TpiQih6pCFkCLc4xw7tzpCkW0xt8qK810HfZBLpKTcWeXjc
	 9/U8JpDUmegzsNeyEmGCZc0WN3GXG4kCSKzgTglJGhMRXVQ1ZcVAkiIfts4wws8IHp
	 9ew0FC1wBk5lpiLtu4nNF+7Ux0G57bzuHZBoloDU=
Date: Mon, 09 Sep 2024 16:48:14 -0700
To: mm-commits@vger.kernel.org,zeming@nfschina.com,rdunlap@infradead.org,kees@kernel.org,brauner@kernel.org,adobriyan@gmail.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch removed from -mm tree
Message-Id: <20240909234814.B5881C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: user_namespace: use kmemdup_array() instead of kmemdup() for multiple allocation
has been removed from the -mm tree.  Its filename was
     user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: user_namespace: use kmemdup_array() instead of kmemdup() for multiple allocation
Date: Wed, 28 Aug 2024 15:23:40 +0800

Let the kmemdup_array() take care about multiplication and possible
overflows.

Link: https://lkml.kernel.org/r/20240828072340.1249310-1-ruanjinjie@huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Li zeming <zeming@nfschina.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/user_namespace.c~user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation
+++ a/kernel/user_namespace.c
@@ -853,9 +853,8 @@ static int sort_idmaps(struct uid_gid_ma
 	     cmp_extents_forward, NULL);
 
 	/* Only copy the memory from forward we actually need. */
-	map->reverse = kmemdup(map->forward,
-			       map->nr_extents * sizeof(struct uid_gid_extent),
-			       GFP_KERNEL);
+	map->reverse = kmemdup_array(map->forward, map->nr_extents,
+				     sizeof(struct uid_gid_extent), GFP_KERNEL);
 	if (!map->reverse)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are


