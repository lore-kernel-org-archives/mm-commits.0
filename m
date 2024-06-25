Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435BE13D289
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291586; cv=none; b=QU09D9EGm51frxk/ByJZDt8d7KHeExFbeBV753mgIit55DjduZlmUMIbJuL8TxncGP+cp/G2TrTsDRi7LIq6rDZ3Gxy0xDDnLxFtnmdQDn5gdXesJMxtKdQ7cMIUHKv9Cdd21L9xB9Qn8UhuAZpSs10nWBNfU40RZk43NPLR/3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291586; c=relaxed/simple;
	bh=3sVrACeRFYPuX5JnnAf7J1gSZ0zpdK3Ki0Kxzz5GhMg=;
	h=Date:To:From:Subject:Message-Id; b=FdAQwwbt16AAjk+j5XEVryPm0onA15i/kFMDZOe4EukEnGlR0mYECi9mDklJ3dKON4s0cYv5CxQeqICMkpbRD6CD2S2NdJ1Y1YPVA1LP578MmEIFmpRSg8QK/k1CEu+5NeBkjUqi+80XUYwbbPsgyfv/gjrZyAAN0LjOcnlP4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+lJxWFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+lJxWFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18774C32782;
	Tue, 25 Jun 2024 04:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291586;
	bh=3sVrACeRFYPuX5JnnAf7J1gSZ0zpdK3Ki0Kxzz5GhMg=;
	h=Date:To:From:Subject:From;
	b=h+lJxWFkbAIIF0YvjRY2V3sV4e0sMzjv27lRR/x3NQGJjynmK7aDrPoQI03Y3DhGb
	 HZufAzIjPqIukcMcWiPPAYEowir4+oJB6hXiB1TRmwi08ggVhbSZV4o8x/6G5PCYML
	 E5CvTK0szb7ztYdZ2zq3kwj/dgM+RmEULZUYcAj4=
Date: Mon, 24 Jun 2024 21:59:45 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dmapool-add-module_description.patch removed from -mm tree
Message-Id: <20240625045946.18774C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/dmapool: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     mm-dmapool-add-module_description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: mm/dmapool: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:39 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/dmapool_test.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-2-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/dmapool_test.c~mm-dmapool-add-module_description
+++ a/mm/dmapool_test.c
@@ -144,4 +144,5 @@ static void dmapool_exit(void)
 
 module_init(dmapool_checks);
 module_exit(dmapool_exit);
+MODULE_DESCRIPTION("dma_pool timing test");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

