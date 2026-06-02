Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95893B6C13
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439050; cv=none; b=gDSKo7Fp5f0U+LpC2ppFp2WNtAHUeVz1/jI1y9ckmgsVktqwnyQGASagu/KV207HwW4cUPlQ8mNistygWPu7lMZChnX+EdWOkqsqEW81uJnk75g3B/fWAmyLGRDA9qMnbzXgXF2xVkLapKqBlOZbhCz/IoQRSjisyxQw18cz3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439050; c=relaxed/simple;
	bh=Z8gE/tL7jbRXxZ7SR0Wd6IpAa2QNdR37BzMEcbC6MQo=;
	h=Date:To:From:Subject:Message-Id; b=CqxoF+lg/tqJwEJcHcSLZYTu1vaK8Kfm9/+N49bN0vNDUo8/y7E+M6i9mKeD3zvFsHoFZpZvMsDGrZ0zOCe3GbUcB7QSbzXNwrZAXH/cKG6FzUAjQJRO2wnWyjZb0rdWu5VM3XNKZ30f2TY/ozPdWNXTmGvznjpHGoqAkZeSmx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIWHOt/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIWHOt/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03AB1F00893;
	Tue,  2 Jun 2026 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439048;
	bh=loEvVrz5v0W5D2hmatCB4eHor7u6+GnXZH1xzRdd6nU=;
	h=Date:To:From:Subject;
	b=zIWHOt/SjF87YDfkd6s3v5Egnos8OZvhn0KV8gEH8eaTngu9CZWLr+tuUlpHG1nOR
	 IuErQt9wfE44rr5FAKdyLE46TwFStZF9X4BZ5un6d+1bwxgKmsC3LoT5TL5vLgZ5kZ
	 2JH4bP4c6XsYQjrJFIfY0oUlD5Wgck0jQgS6xzR4=
Date: Tue, 02 Jun 2026 15:24:08 -0700
To: mm-commits@vger.kernel.org,wangxuewen@kylinos.cn,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,18810879172@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinker-simplify-shrinker_memcg_alloc-using-guard.patch removed from -mm tree
Message-Id: <20260602222408.C03AB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shrinker: simplify shrinker_memcg_alloc() using guard()
has been removed from the -mm tree.  Its filename was
     mm-shrinker-simplify-shrinker_memcg_alloc-using-guard.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


