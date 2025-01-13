Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F716EC19;
	Mon, 13 Jan 2025 23:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736810406; cv=none; b=FLgsWP6hh+coC6oexDp6sn66v78CC37gLrleLhepmw6k2MiwhgTaCS8OJaCExAJtGpm2EJjEKgcCUgR7vxhcuhXfWMQE4Ic5dN9gldqm3KQ9vrp+xFeXH7sKlWn4OpAS+kBkvl1Epb9aYhalZKFSLrzvdmjtVkDT/ueap8hVK5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736810406; c=relaxed/simple;
	bh=09NPkdSE13fgHDvnIwFiLs1pv90mgp7kVS82OBB4dwA=;
	h=Date:To:From:Subject:Message-Id; b=lsW/gIIZuPTz+BHAUJcCxVzdW2iqIOfCT/drC8iBoiIT67dM8GYxdExR1WSNR3T1wdYrQnSvxFsyH7HO5OkYuWWLLhMrHeKgfF+D5j9CfjW7RAj5/NBQLNfIef46mdGEYWprjsVy3sllRrRx8koTFSEv0f3C8d7JsVxJrku0JVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mrWZoI7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mrWZoI7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DABAC4CEE2;
	Mon, 13 Jan 2025 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736810406;
	bh=09NPkdSE13fgHDvnIwFiLs1pv90mgp7kVS82OBB4dwA=;
	h=Date:To:From:Subject:From;
	b=mrWZoI7L/ShvCIvpRA6JcoXOIN00Qh/BNl+xJlKbGtUO9By1j4UZnPCl3MuvyX7u7
	 PCRWfcwEaO4QxFyFwvuGuLcwWNAUgzYusUypYbratFDQb/nV3Z6fxEew4J8PVSvWU+
	 DlloWc9TMpDEwqngo8gqUqcqtaEr3jj0e3gt1UDg=
Date: Mon, 13 Jan 2025 15:20:05 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-move-allocations-during-cpu-init-outside-the-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20250113232006.3DABAC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: move allocations during CPU init outside the lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-move-allocations-during-cpu-init-outside-the-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-move-allocations-during-cpu-init-outside-the-lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: move allocations during CPU init outside the lock
Date: Mon, 13 Jan 2025 21:44:58 +0000

In zswap_cpu_comp_prepare(), allocations are made and assigned to various
members of acomp_ctx under acomp_ctx->mutex.  However, allocations may
recurse into zswap through reclaim, trying to acquire the same mutex and
deadlocking.

Move the allocations before the mutex critical section.  Only the
initialization of acomp_ctx needs to be done with the mutex held.

Link: https://lkml.kernel.org/r/20250113214458.2123410-1-yosryahmed@google.com
Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/mm/zswap.c~mm-zswap-move-allocations-during-cpu-init-outside-the-lock
+++ a/mm/zswap.c
@@ -820,15 +820,15 @@ static int zswap_cpu_comp_prepare(unsign
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp;
-	struct acomp_req *req;
+	struct crypto_acomp *acomp = NULL;
+	struct acomp_req *req = NULL;
+	u8 *buffer = NULL;
 	int ret;
 
-	mutex_lock(&acomp_ctx->mutex);
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer) {
+	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	if (!buffer) {
 		ret = -ENOMEM;
-		goto buffer_fail;
+		goto fail;
 	}
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
@@ -836,21 +836,25 @@ static int zswap_cpu_comp_prepare(unsign
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp));
 		ret = PTR_ERR(acomp);
-		goto acomp_fail;
+		goto fail;
 	}
-	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 
-	req = acomp_request_alloc(acomp_ctx->acomp);
+	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		ret = -ENOMEM;
-		goto req_fail;
+		goto fail;
 	}
-	acomp_ctx->req = req;
 
+	/*
+	 * Only hold the mutex after completing allocations, otherwise we may
+	 * recurse into zswap through reclaim and attempt to hold the mutex
+	 * again resulting in a deadlock.
+	 */
+	mutex_lock(&acomp_ctx->mutex);
 	crypto_init_wait(&acomp_ctx->wait);
+
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
@@ -859,15 +863,17 @@ static int zswap_cpu_comp_prepare(unsign
 	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	acomp_ctx->buffer = buffer;
+	acomp_ctx->acomp = acomp;
+	acomp_ctx->is_sleepable = acomp_is_async(acomp);
+	acomp_ctx->req = req;
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
 
-req_fail:
-	crypto_free_acomp(acomp_ctx->acomp);
-acomp_fail:
-	kfree(acomp_ctx->buffer);
-buffer_fail:
-	mutex_unlock(&acomp_ctx->mutex);
+fail:
+	if (acomp)
+		crypto_free_acomp(acomp);
+	kfree(buffer);
 	return ret;
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-move-allocations-during-cpu-init-outside-the-lock.patch

