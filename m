Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8894B469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122599; cv=none; b=tsclcldvEA4bEwvA4LxIIbgiBH/jgRec1x0cy9bsO26KC4i4l39+FGmvlyAGNJof+6CkTvVKlK8RTKUlmc0BngTh8f70zR42yW6IlauT8HVNh2NywN5ShMbk20qG2Bw/rWyy4BZ4OIfdPvMDzyD/gHZclB8DPBguj/eL5U9v+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122599; c=relaxed/simple;
	bh=EIfyFJ/Wx7z4Ic+J28WkRaX2tNiATEVqCBzPboftT+U=;
	h=Date:To:From:Subject:Message-Id; b=HgZAjlQFDYePX+WIZndAHZV6UUMXiNDcT9AXGWHifuO2fgTofdZNUeKd37/4eW3AaVmkuYP3kXHiHvx+cb+fWmXb4XJ0wE6JX2nCk3fo+LhfE8tvMqKqfgPHqjikPV+wN+gsI1qyXB8z3CzSErQh/zvMbi1eNjoPisaKLrczD4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mxPMX61/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mxPMX61/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036A9C4CEE3;
	Thu, 10 Jul 2025 04:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122599;
	bh=EIfyFJ/Wx7z4Ic+J28WkRaX2tNiATEVqCBzPboftT+U=;
	h=Date:To:From:Subject:From;
	b=mxPMX61/aOgIWxaTtCuQ5gYBBC1FnlwFfH1E5R0yDVUbdp3fReX0M4p9hnkZ4Zwbz
	 9MA+AqFSuTH2WyWfs4KUKCWljf+VtW7Hqb29OWq2roQ4tMeg1KCQrqrd4QBPcY3AxM
	 gjzlMac9iCwySGL351NhKU4v2JCqnAo6eRYSjvh8=
Date: Wed, 09 Jul 2025 21:43:18 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,dev.jain@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple-tree-use-goto-label-to-simplify-code-fix.patch removed from -mm tree
Message-Id: <20250710044319.036A9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple-tree-use-goto-label-to-simplify-code-fix
has been removed from the -mm tree.  Its filename was
     maple-tree-use-goto-label-to-simplify-code-fix.patch

This patch was dropped because it was folded into maple-tree-use-goto-label-to-simplify-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple-tree-use-goto-label-to-simplify-code-fix
Date: Tue Jun 24 04:28:16 PM PDT 2025

add newline, per Liam (and remove one, per akpm)

Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-use-goto-label-to-simplify-code-fix
+++ a/lib/maple_tree.c
@@ -4560,13 +4560,13 @@ again:
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
-
 	if (likely(entry))
 		return entry;
 
 	if (!empty) {
 		if (mas->index <= min)
 			goto underflow;
+
 		goto again;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple-tree-use-goto-label-to-simplify-code.patch
mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

