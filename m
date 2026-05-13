Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E6619CD03
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778714240; cv=none; b=YujjtqeWsasmvY+K4hHn/UQ0k5ayvcIqxODI56s6dTtFLnFCL/GrVOKy2vTOft8Y59pg81Zjx5ZkeRmt6njSI5hE65XxEzD6v2Kd/cG+IWBp7oy8Fx/tizvNN5qx+9G9MECVIGJU3sza1o3QVlavJrXQ1hT7gzibAR3BU0PtksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778714240; c=relaxed/simple;
	bh=kuESs0ofR5JmHC7C1GGXrlO7emXqqvSmN1pDfXjdhns=;
	h=Date:To:From:Subject:Message-Id; b=usgvkVaweTV5vduAxtKqRTTRLXXvnB4Wiea9w4hWLoqyLZWuEU6z/LoR2DPvghr9Z1sDDs7TrfiQKBcpzcZFA7A2GcFrFs+Lbx6Cq4fynjPSSrdoH/vIw/h/Bw/g5obITDXuBMsC+oDCl4Y9YbaXatpuBreFXXEsK2G/le6xcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xTD14sfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xTD14sfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DFEC19425;
	Wed, 13 May 2026 23:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778714239;
	bh=kuESs0ofR5JmHC7C1GGXrlO7emXqqvSmN1pDfXjdhns=;
	h=Date:To:From:Subject:From;
	b=xTD14sfqgT5qFN+VgSRLT2CdxyA3UzG8o+HpE9XTbQgTfcHBS5l5WcQmERPe//T5i
	 2NdVD60AAKlOE3mygzK/Q7KZfGzIDHimEaRIrhyhmFlBu1YWlI5mv2fGfLzmol8sUO
	 TSe4OfBxcVWDthH4K+ONBKMwmCXYpRAmO5xx72tk=
Date: Wed, 13 May 2026 16:17:19 -0700
To: mm-commits@vger.kernel.org,wangxuewen@kylinos.cn,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,18810879172@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-simplify-shrinker_memcg_alloc-using-guard.patch added to mm-new branch
Message-Id: <20260513231719.B2DFEC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shrinker: simplify shrinker_memcg_alloc() using guard()
has been added to the -mm mm-new branch.  Its filename is
     mm-shrinker-simplify-shrinker_memcg_alloc-using-guard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-simplify-shrinker_memcg_alloc-using-guard.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: wangxuewen <18810879172@163.com>
Subject: mm/shrinker: simplify shrinker_memcg_alloc() using guard()
Date: Wed, 13 May 2026 15:52:14 +0800

Use guard(mutex) to automatically handle shrinker_mutex locking and
unlocking in shrinker_memcg_alloc().  This removes the explicit
mutex_unlock() call, the goto-based error path, and the redundant ret
variable, resulting in cleaner and more concise code.

Link: https://lore.kernel.org/20260513075214.2655710-1-18810879172@163.com
Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/shrinker.c~mm-shrinker-simplify-shrinker_memcg_alloc-using-guard
+++ a/mm/shrinker.c
@@ -216,29 +216,26 @@ static DEFINE_IDR(shrinker_idr);
 
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
-	int id, ret = -ENOMEM;
+	int id;
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
 		return -ENOSYS;
 
-	mutex_lock(&shrinker_mutex);
+	guard(mutex)(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
-		goto unlock;
+		return id;
 
 	if (id >= shrinker_nr_max) {
 		if (expand_shrinker_info(id)) {
 			idr_remove(&shrinker_idr, id);
-			goto unlock;
+			return -ENOMEM;
 		}
 	}
 	shrinker->id = id;
-	ret = 0;
-unlock:
-	mutex_unlock(&shrinker_mutex);
-	return ret;
+	return 0;
 }
 
 static void shrinker_memcg_remove(struct shrinker *shrinker)
_

Patches currently in -mm which might be from 18810879172@163.com are

mm-shrinker-simplify-shrinker_memcg_alloc-using-guard.patch

