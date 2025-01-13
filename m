Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B78C1527B1
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742131; cv=none; b=FrRbebxOSDy6AUWR8sqo71PISFPO3iXJggO7zfTPtpzgu02wYo4pDHsc+XmisQZi8rEwYlnca2XZentxRjMLPIgLOXjj+Q2PQTKkfaqdHPRNbv6FCVQgSgMMliS0wlFwpTvXKeEGGGDZ6USzYoYC1EJ7eOQ4h3sV29R62MD+kU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742131; c=relaxed/simple;
	bh=RHNvC4thFjBjPoKbi8WKF1nlOHNLJEry0fnzAE/zolo=;
	h=Date:To:From:Subject:Message-Id; b=E2Yr3Jj9Xa8Yid7C/TUWbneBD1zo9OFsV0jMrK9c6zGwxtuYD1fRINJFT3XJ+EyH5Xx8qLuglIav5PwJWnDHWG3Ey5hpYhcEXEtNJo03KjW4NIhNnjlyyoeAbXTu6ZrSmT5RPjEFnZj3v7C9l+gqytoIkBS0H+2R3WKFfKOj3fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IqqMHkoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IqqMHkoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED44C4CED6;
	Mon, 13 Jan 2025 04:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742130;
	bh=RHNvC4thFjBjPoKbi8WKF1nlOHNLJEry0fnzAE/zolo=;
	h=Date:To:From:Subject:From;
	b=IqqMHkohxhIOR7UbfvfMK7DhPn6r+UDX80zhP4O3gRN0VUfd8RwkHEfFenk9tWbow
	 rWIoUmwm1Iov3BMRughi9Yws2L0XpMeuKvju/eicPJErrP7X4GayQKu8cbZmoLPAuZ
	 CQ+Gi7HVD0wbmdRnV1qkhvcePwpvGGg3Dv/oso9g=
Date: Sun, 12 Jan 2025 20:22:09 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,geert@linux-m68k.org,corbet@lwn.net,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-brief-introduction-to-min-heap-api.patch removed from -mm tree
Message-Id: <20250113042209.DED44C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add brief introduction to Min Heap API
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-brief-introduction-to-min-heap-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add brief introduction to Min Heap API
Date: Sat, 30 Nov 2024 02:12:21 +0800

A short description of the Min Heap API is added to the min_heap.h,
explaining its purpose for managing min-heaps and emphasizing the use of
macro wrappers instead of direct function calls.  For more details, users
are directed to the documentation at Documentation/core-api/min_heap.rst.

Link: https://lkml.kernel.org/r/20241129181222.646855-4-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-brief-introduction-to-min-heap-api
+++ a/include/linux/min_heap.h
@@ -6,6 +6,17 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+/*
+ * The Min Heap API provides utilities for managing min-heaps, a binary tree
+ * structure where each node's value is less than or equal to its children's
+ * values, ensuring the smallest element is at the root.
+ *
+ * Users should avoid directly calling functions prefixed with __min_heap_*().
+ * Instead, use the provided macro wrappers.
+ *
+ * For further details and examples, refer to Documentation/core-api/min_heap.rst.
+ */
+
 /**
  * Data structure to hold a min-heap.
  * @nr: Number of elements currently in the heap.
_

Patches currently in -mm which might be from visitorckw@gmail.com are


