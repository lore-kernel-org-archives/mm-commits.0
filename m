Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F428C874
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957832; cv=none; b=fGGBBSFJj2HFsH8S+gyrKIgIyKdOM0GJtJAmeTu0M4eGs6oByQMz4yBf9W6fdXyM2WK9Rp5KofZ44rSxchbK1w7azZ4XzPR3ubmLviuFFOuwOsQgL08BB04dEka9Dywf2CBVxYYDXkA3ECWwAQNIcX6JTt664YQXmdJbLGQPWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957832; c=relaxed/simple;
	bh=wDVPUiYvM/0UoCNAbNMSg6Eo8engUExMmCQ+tdxEzcM=;
	h=Date:To:From:Subject:Message-Id; b=Mj3SaPAlQjypmh5OqSF5To/6NTHMgodHIvsYJD0xJMFOY5S2Z+qH1DdFsitbO0fTpY0pTK9ok27wczoK9qiFKW4A3vm95+h4noCLOjmC41jXfnGi1C/aeZk4UxlysDZewa+QU5FCuJN4tUH8plM59EZPF2z75rfJtjSBqTwJajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ej8sxgFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ej8sxgFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3881F00A3A;
	Thu,  2 Jul 2026 02:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957831;
	bh=5PzW9L4VYydazt8TVX9gNt5k9EKEO2jP3QfAjOyDzm8=;
	h=Date:To:From:Subject;
	b=Ej8sxgFOU3+s7GMa+CH5OCvPgeT20BXAqDXjFurlw1VThGUHdJncjTs/ujFRgLJnb
	 7ebgkuNuqMs2reWXlz6Q54yI+mODmpQ4Z5IORcNAsr6EIoT/WLrPU/TuWa8qux8kbo
	 rtMIGysmVf6Hjv6i9IB4TDS1uPQQr/Mhy3C3xpoI=
Date: Wed, 01 Jul 2026 19:03:51 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,rppt@kernel.org,pabeni@redhat.com,mst@redhat.com,ljs@kernel.org,jasowang@redhat.com,eperezma@redhat.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-include-include-stdinth-for-size_max-in-overflowh.patch removed from -mm tree
Message-Id: <20260702020351.7D3881F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/include: include stdint.h for SIZE_MAX in overflow.h
has been removed from the -mm tree.  Its filename was
     tools-include-include-stdinth-for-size_max-in-overflowh.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/include: include stdint.h for SIZE_MAX in overflow.h
Date: Mon, 29 Jun 2026 10:21:24 +0800

tools/include/linux/overflow.h uses SIZE_MAX in its size helper functions.

Include stdint.h so tools users that include overflow.h without another
SIZE_MAX provider can build.

Link: https://lore.kernel.org/20260629022124.131894-3-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/overflow.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/linux/overflow.h~tools-include-include-stdinth-for-size_max-in-overflowh
+++ a/tools/include/linux/overflow.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 OR MIT */
+#include <stdint.h>
 #ifndef __LINUX_OVERFLOW_H
 #define __LINUX_OVERFLOW_H
 
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch

