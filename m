Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F23913AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744950; cv=none; b=SCuxvrlMRUrlvwqbmcrnT44sm83bWFdaq7OXjm5x35czykgNFBuonRAUGKuUmAU4tVIswYVoTbtqvpnZ/OvEeWxgwGzsxdCkLo3w85olmDx9dO+Xp9Xny/7EbwBxTuF1x9rnzRammgy+42mQ4WWthC7BFOjHtrGvEJqEqr7ENHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744950; c=relaxed/simple;
	bh=rXChrWazAJkmABvCMhHuB5t5OMQCVImAAW/h+SF0W0Y=;
	h=Date:To:From:Subject:Message-Id; b=mu24046Ope9plNUbShkLLt/b32UyytJAkmpOeKfkyA5lwQtfVYKUgez/hM/yWc9aavJ+wekzi/ArZFN00emaF5SwKXbmNe0mgZfoIChzNX+bxAwZSEQ8nm8cc/C+SDLbW/LshkmpF3D90biNwMxjm1SyZ+sE2G0TGBox6nUGvyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mn/7fGpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mn/7fGpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463B8C4CEF7;
	Sun, 29 Mar 2026 00:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744950;
	bh=rXChrWazAJkmABvCMhHuB5t5OMQCVImAAW/h+SF0W0Y=;
	h=Date:To:From:Subject:From;
	b=mn/7fGpuSXg2lUH6z5PlixBbwElPCaqQcaT72NBKU5AiGy6KyxZC/2uV1gWangLW9
	 w12sbLtPtiq8HfGorgNr7/9eEh9honyyuUxx0F+Z+Mm6NiUWV7Mf9zQUMhOUhftWMq
	 VHhWWNBC8G/bjW1Xx7f8410wuqWp+XB8jqxv3n6Y=
Date: Sat, 28 Mar 2026 17:42:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-document-damos_commit_dests-failure-semantics.patch removed from -mm tree
Message-Id: <20260329004230.463B8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: document damos_commit_dests() failure semantics
has been removed from the -mm tree.  Its filename was
     mm-damon-core-document-damos_commit_dests-failure-semantics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: mm/damon/core: document damos_commit_dests() failure semantics
Date: Fri, 20 Mar 2026 07:36:45 -0700

Add a kernel-doc-like comment to damos_commit_dests() documenting its
allocation failure contract: on -ENOMEM, the destination structure is left
in a partially torn-down state that is safe to deallocate via
damon_destroy_scheme(), but must not be reused for further commits.

This was unclear from the code alone and led to a separate patch [1]
attempting to reset nr_dests on failure.  Make the intended usage explicit
so future readers do not repeat the confusion.

Link: https://lkml.kernel.org/r/20260320143648.91673-1-sj@kernel.org
Link: https://lore.kernel.org/20260318214939.36100-1-objecting@objecting.org [1]
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-document-damos_commit_dests-failure-semantics
+++ a/mm/damon/core.c
@@ -1060,6 +1060,23 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+/*
+ * damos_commit_dests() - Copy migration destinations from @src to @dst.
+ * @dst:	Destination structure to update.
+ * @src:	Source structure to copy from.
+ *
+ * If the number of destinations has changed, the old arrays in @dst are freed
+ * and new ones are allocated.  On success, @dst contains a full copy of
+ * @src's arrays and count.
+ *
+ * On allocation failure, @dst is left in a partially torn-down state: its
+ * arrays may be NULL and @nr_dests may not reflect the actual allocation
+ * sizes.  The structure remains safe to deallocate via damon_destroy_scheme(),
+ * but callers must not reuse @dst for further commits — it should be
+ * discarded.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
 static int damos_commit_dests(struct damos_migrate_dests *dst,
 		struct damos_migrate_dests *src)
 {
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

