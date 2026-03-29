Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB1710F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744828; cv=none; b=W0PWXzxhsYl2GhASw5d7DlGKeLbFzd2Cb/KfodLszfHCDsXZ0/2shrLK5X5qbkYCos0xPqYiUDTKE43Qp9mFuXmgEhsZe7aXxw/O4scESA7Ai45hWvyNLcyai8tvdJNe3fL1lipUs4BPQxTlG/GWhl6MUdnDUreLvwWWdYI9km4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744828; c=relaxed/simple;
	bh=o/T03DYhEEs8FHXiP1geb56wwa65ZjdOHnHetjRUnOA=;
	h=Date:To:From:Subject:Message-Id; b=RULCs8YVvZsZQTBff9Jlfk1Us3+fdv7hP/BybN+DRK/z8wMzUM2eIHIfz4hzgiSB+eQn9+uUUBtNKg4fl/0vosSBOBSiwwsMXM7ameR7TOA/L8v9VEGgDNYBg9gZ0LYlfdg+gPOmUH1wfYIAXURGF2FacmdSlF+Bt9i2akCgpEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KyRDFQ0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KyRDFQ0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C667DC4CEF7;
	Sun, 29 Mar 2026 00:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744827;
	bh=o/T03DYhEEs8FHXiP1geb56wwa65ZjdOHnHetjRUnOA=;
	h=Date:To:From:Subject:From;
	b=KyRDFQ0vljemZ5UZx1s9YlMO8/1hvEsroJKqs3LZdOajN4yaPxNqd0YZQ38S0esNL
	 0cIYf+Ez1ubzDVaXS1osgYWw/zDZ/5jKfYSPEVM8q2BsB3Z49w9iF0b7wlWCYtaj+V
	 dS+xOH+fZHy9k57548GKeHXmPhAmlOA8DGZfzeDQ=
Date: Sat, 28 Mar 2026 17:40:27 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-config-enable-damon_debug_sanity.patch removed from -mm tree
Message-Id: <20260329004027.C667DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/config: enable DAMON_DEBUG_SANITY
has been removed from the -mm tree.  Its filename was
     selftests-damon-config-enable-damon_debug_sanity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/config: enable DAMON_DEBUG_SANITY
Date: Fri, 6 Mar 2026 07:29:13 -0800

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the build config for DAMON selftests.

Link: https://lkml.kernel.org/r/20260306152914.86303-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/config~selftests-damon-config-enable-damon_debug_sanity
+++ a/tools/testing/selftests/damon/config
@@ -4,3 +4,4 @@ CONFIG_DAMON_PADDR=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_RECLAIM=y
 CONFIG_DAMON_LRU_SORT=y
+CONFIG_DAMON_DEBUG_SANITY=y
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

