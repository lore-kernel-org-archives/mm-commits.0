Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B24116FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855621; cv=none; b=Pd/GJ6XzKuhk5JD4LQxbKsOsQUXKyaaPoJPGWAAc056BjWJRXqMMj/Wu2+Lx+a8quyTxk4VZd+FgqMrehzdHx58kK+D0JceueTItcb1g50t/UNM4z9duCyCsnZGuNeNZmpig51TH4LieE8/fm74Y6HThY3+4AQY8ClIrb17Qlw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855621; c=relaxed/simple;
	bh=xzn9cxiaxBgiPiWhznh1qf+4PuIYl46qveHsNNgyQiM=;
	h=Date:To:From:Subject:Message-Id; b=sbr0nfNSXEzOcLAYlpXxmhmpFyIV5ADTCgYqus0LtSleGLyv9xB5zQAPWpZ5nHYXVYW4qpqBBdTiNBnQPkZOBLazXwEy6VpAsZ+Qn3ityHD/LJ5rOy/ZrStvwN6sVgrtOYlVWhSzKe2hllE8NUUHyfX2bsO+B1772XGURa7jmLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHX+NVwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHX+NVwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C00EC4CECF;
	Wed,  6 Nov 2024 01:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855621;
	bh=xzn9cxiaxBgiPiWhznh1qf+4PuIYl46qveHsNNgyQiM=;
	h=Date:To:From:Subject:From;
	b=RHX+NVwSo8sxXv0oPhrzPmzi4b1tSHlFMFx0SMC/+AF0IX+8ztn1p6MCRR+Z9ZYyI
	 1ujYGRd37zQBvt19kaHAPrzE0v5Wa2mJ0WlmdiqCtGDbjs9AULmcA0MpEhxvCmv3zj
	 zudDwEIt3w35dyrCYqtLLkWAZQau86JdFLmekLE0=
Date: Tue, 05 Nov 2024 17:13:40 -0800
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-correct-reallocate_resource-documentation.patch removed from -mm tree
Message-Id: <20241106011341.2C00EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: correct reallocate_resource() documentation
has been removed from the -mm tree.  Its filename was
     resource-correct-reallocate_resource-documentation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Subject: resource: correct reallocate_resource() documentation
Date: Wed, 9 Oct 2024 15:57:51 +0300

reallocate_resource() documentation claims constraint is about "the size
and alignment" but the size is provided in another parameter.  Instead of
size, constraint has the allowed memory range (min, max) so change the
wording to reflect that.

Link: https://lkml.kernel.org/r/20241009125751.8090-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-correct-reallocate_resource-documentation
+++ a/kernel/resource.c
@@ -738,7 +738,7 @@ EXPORT_SYMBOL_GPL(find_resource_space);
  * @root: root resource descriptor
  * @old:  resource descriptor desired by caller
  * @newsize: new size of the resource descriptor
- * @constraint: the size and alignment constraints to be met.
+ * @constraint: the memory range and alignment constraints to be met.
  */
 static int reallocate_resource(struct resource *root, struct resource *old,
 			       resource_size_t newsize,
_

Patches currently in -mm which might be from ilpo.jarvinen@linux.intel.com are


