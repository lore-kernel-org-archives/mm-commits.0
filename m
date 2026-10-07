Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED56E25A2A2
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334281; cv=none; b=jNv2Mxf9qnYlGPPAp3Ogd/Nlhn/RYmRqSpY+R534HeNq3eYqqwqJ5ykeezzDeKLA8gqX6WxthJr0CNIHnGiijQSVv544jV/QK1HyeY93BMEZL6JQeKQ8w4kJ0b3BJUx0xbXG/yzTHHYt5r7gL06ZgoWxd2+Oh9BvR2KOUvg6pjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334281; c=relaxed/simple;
	bh=+JeZ2KXFrXbidilxYYwNBpi1wdIgfnLG77ZqaADKcAU=;
	h=Date:To:From:Subject:Message-Id; b=X2Ov37KP7pRva3IqLc+4N/9JsEMLIofoIrSDVlEGzyyovSpkJVDZS8GaXQlAM5j22YHOGG4jcBWwYrhvYaes/Y9sVwXIJRVy/wkKMS7jNa9CKBjlM7VT1Xqo5jfgQNo1RQZhQB3Mx+PJgVQAnVnEzN2H+c8ctI+JBlpI8XBm6RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v9H3zI2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v9H3zI2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C466A1F0089D;
	Wed,  7 Oct 2026 00:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334279;
	bh=gOdszm2mtXz+f5kswb+VTgZICc52DD5XAWKns2rX6Rc=;
	h=Date:To:From:Subject;
	b=v9H3zI2OqT/Da2hXQuwR9gaevB6uX6X6JKGikMsF2Ybt8MsRji5TYzsxiby0IEhfV
	 r6g652CP7bHUPpv+pxiDOgYRHxG2AH306k33xoBQRf9erYWekFyEbqVRlXiUMRZjYZ
	 jw8W1VND8H5ZsKrn6XrZ7Ev4BYiApGQ+frZQDZbg=
Date: Tue, 06 Oct 2026 17:51:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-unused-damon_nr_running_ctxs.patch removed from -mm tree
Message-Id: <20261007005119.C466A1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove unused damon_nr_running_ctxs()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-unused-damon_nr_running_ctxs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: mm/damon/core: remove unused damon_nr_running_ctxs()
Date: Mon, 31 Aug 2026 07:57:22 -0700

damon_nr_running_ctxs() has had no in-tree users since commit 5ec4333b1967
("mm/damon: remove DAMON debugfs interface") removed all of its callers.

Remove the unused declaration and definition.

Link: https://lore.kernel.org/20260831145724.82387-3-sj@kernel.org
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 include/linux/damon.h |    1 -
 mm/damon/core.c       |   14 --------------
 2 files changed, 15 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-unused-damon_nr_running_ctxs
+++ a/include/linux/damon.h
@@ -1065,7 +1065,6 @@ int damon_set_attrs(struct damon_ctx *ct
 void damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_commit_ctx(struct damon_ctx *old_ctx, struct damon_ctx *new_ctx);
-int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
--- a/mm/damon/core.c~mm-damon-core-remove-unused-damon_nr_running_ctxs
+++ a/mm/damon/core.c
@@ -1847,20 +1847,6 @@ out:
 	return err;
 }
 
-/**
- * damon_nr_running_ctxs() - Return number of currently running contexts.
- */
-int damon_nr_running_ctxs(void)
-{
-	int nr_ctxs;
-
-	mutex_lock(&damon_lock);
-	nr_ctxs = nr_running_ctxs;
-	mutex_unlock(&damon_lock);
-
-	return nr_ctxs;
-}
-
 /* Returns the size upper limit for each monitoring region */
 static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 {
_

Patches currently in -mm which might be from hank20010209@gmail.com are


