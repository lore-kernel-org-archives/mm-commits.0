Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECC71C3C11;
	Tue, 21 Oct 2025 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086817; cv=none; b=QBOjL8E62cefQD0ptfjWlIJCMi3IJ+eTgSVzrCzli76fZduNMA5RKybkm6u3XIOg3mZkvQ2QwRrZY/cctkQCIz2iwqL9yA9x8onw9sznSDeSUUNx9QFznAfUZdXPL3HQkGNrmvo20YHWR/EPk+DyFRnVUtPFcPC/MQj3v3dIEmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086817; c=relaxed/simple;
	bh=JXub9fOrDGF3WuKQ/J+8Zv2pu+lIwPGencIdv8IjiPk=;
	h=Date:To:From:Subject:Message-Id; b=MC2EMnuZ/sicn9a9dgGJJUukAxKQM7YyEGZyuJGK2OAjo7PLITS3JwNTIJFMRF3DG0Jvz4W5tso2/nn5zjJyAdNLBIaN2eux8pTcBcZgVEHH55hgQLXcEtWctTlFYp0YIjr1YTLP2muFAy/g5PE49hdeyZm4Rh1bzJ1IoDZhkic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YvsWrfXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YvsWrfXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99891C4CEF1;
	Tue, 21 Oct 2025 22:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086816;
	bh=JXub9fOrDGF3WuKQ/J+8Zv2pu+lIwPGencIdv8IjiPk=;
	h=Date:To:From:Subject:From;
	b=YvsWrfXWrMW2mJRWb2D1aRaZ5jnsgBLkohn0IjKM25C1HMA7eNEMZQwYS3/9YJCat
	 2Tr2Yon+nrSl+zMSn+eX4s81EptdMbl2G9KI8RUwGq+ew4zanCFBfeIzIO5wswyj2E
	 TLWT+PIqfXp3ow5A+vsTN0mkpxAz27reU2VnrVlA=
Date: Tue, 21 Oct 2025 15:46:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-list_add_tail-call-on-damon_call.patch removed from -mm tree
Message-Id: <20251021224656.99891C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix list_add_tail() call on damon_call()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-list_add_tail-call-on-damon_call.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix list_add_tail() call on damon_call()
Date: Tue, 14 Oct 2025 13:59:36 -0700

Each damon_ctx maintains callback requests using a linked list
(damon_ctx->call_controls).  When a new callback request is received via
damon_call(), the new request should be added to the list.  However, the
function is making a mistake at list_add_tail() invocation: putting the
new item to add and the list head to add it before, in the opposite order.
Because of the linked list manipulation implementation, the new request
can still be reached from the context's list head.  But the list items
that were added before the new request are dropped from the list.

As a result, the callbacks are unexpectedly not invocated.  Worse yet, if
the dropped callback requests were dynamically allocated, the memory is
leaked.  Actually DAMON sysfs interface is using a dynamically allocated
repeat-mode callback request for automatic essential stats update.  And
because the online DAMON parameters commit is using a non-repeat-mode
callback request, the issue can easily be reproduced, like below.

    # damo start --damos_action stat --refresh_stat 1s
    # damo tune --damos_action stat --refresh_stat 1s

The first command dynamically allocates the repeat-mode callback request
for automatic essential stat update.  Users can see the essential stats
are automatically updated for every second, using the sysfs interface.

The second command calls damon_commit() with a new callback request that
was made for the commit.  As a result, the previously added repeat-mode
callback request is dropped from the list.  The automatic stats refresh
stops working, and the memory for the repeat-mode callback request is
leaked.  It can be confirmed using kmemleak.

Fix the mistake on the list_add_tail() call.

Link: https://lkml.kernel.org/r/20251014205939.1206-1-sj@kernel.org
Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-list_add_tail-call-on-damon_call
+++ a/mm/damon/core.c
@@ -1450,7 +1450,7 @@ int damon_call(struct damon_ctx *ctx, st
 	INIT_LIST_HEAD(&control->list);
 
 	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&ctx->call_controls, &control->list);
+	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch

