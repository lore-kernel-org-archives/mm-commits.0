Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B0633557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671912; cv=none; b=Tcu4CS1yRCikSjhfoDo6k8yvA0tagqGW20/cNUiGPt0w0JZD/Ab7fVeWciG++0QeUYEb+rD890r8eXzDWxZ136DIw8abU/ugJMHmdRu78251gb4QiY4Olpe8OLDxUVIB7iBCzd7NQqToQXMTrbgQdLM4tgO/HiQUHt37ocjr2p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671912; c=relaxed/simple;
	bh=e8OXMmUx/Oalb9VLiAk8yI7zBF0cD0yUTcAOUFsP29U=;
	h=Date:To:From:Subject:Message-Id; b=OwoD9fC+6UbGKzWWUedVcWWF7CWOaxAW/Ulg5mk/JJakvnWB78lsWFsLvUoY1hwWQt9cyKetkUqgS7DEGyJGVhCXxMT3vnMBd7Gi89TMcVNiUCABUzt74dv0MNQ8liRGBqAAN5RLjuQK4XW5gk4lnqzmJ1VMlm7pyq2RmfVbGgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQjyBYY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQjyBYY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC4CC4CEF7;
	Sat, 28 Mar 2026 04:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671912;
	bh=e8OXMmUx/Oalb9VLiAk8yI7zBF0cD0yUTcAOUFsP29U=;
	h=Date:To:From:Subject:From;
	b=xQjyBYY/ZNbyrNksWMInDCw0buoPt4e5gpHFUl5vLaqmqb5Wu7Cy90casHHPQbrPx
	 XWq2P6lLLARhCEP/dk9ElSMiDijsz/93jPvbzQyQPZIqLdi+C6MKDggzthDdmJ3cmD
	 RLL4mU3fbNBJosGH75ENCkmlZvYvsgBtwx8891yY=
Date: Fri, 27 Mar 2026 21:25:11 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-math-polynomial-dont-use-proxy-headers.patch removed from -mm tree
Message-Id: <20260328042512.5FC4CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: math: polynomial: don't use 'proxy' headers
has been removed from the -mm tree.  Its filename was
     lib-math-polynomial-dont-use-proxy-headers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib: math: polynomial: don't use 'proxy' headers
Date: Mon, 2 Mar 2026 10:28:08 +0100

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lkml.kernel.org/r/20260302092831.2267785-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/polynomial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/math/polynomial.c~lib-math-polynomial-dont-use-proxy-headers
+++ a/lib/math/polynomial.c
@@ -10,7 +10,8 @@
  *
  */
 
-#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/polynomial.h>
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


