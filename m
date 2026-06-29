Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1A73CF034
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 23:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782777571; cv=none; b=kjX07IhADA7q4R7O8hyaLOgfCEmo5+I+AWrUiAFxhUKWXE+x1f5WM7b8xU+ZNRfwcIffdhnjCMtTp5oqmsuXbLAswaOtILHZ2mxfsWBBu/5uKvo9nEXxjV2mFYcvjPXRNy+/d82Lx1I1idm4Oaiji+ZXy8NwjNpdZHFb/2QUGds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782777571; c=relaxed/simple;
	bh=SpBLXtPOTr3C6ifslINN1q5EnfM97o1kfmKGSyuHgl0=;
	h=Date:To:From:Subject:Message-Id; b=EwcZtqk8HlDYfsuavcF/rPhim1YN9RuxL1MhhvhS2Wth/fBSX4+2L6bv6BIFcTXvsyFGIo5WwW3yuCiT+HkC1bqSAem/TDyIztTvYi29ckK5B6mXItaGfaFqGR2kgBXp37jnFzeHma49RWJaknf2MlqApNMmM9JxGMHdYjxMMBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UaoeGXvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UaoeGXvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7611F000E9;
	Mon, 29 Jun 2026 23:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782777569;
	bh=7/HyTpJ7uBZBEA19F1nDtPpESc0y9APBCF5iR5PGU40=;
	h=Date:To:From:Subject;
	b=UaoeGXvnHAEeqgJSgiS7vz0a4vPnaP17MAjymqeSokh9C1TThhJOy0zQlrn+y/Rmc
	 90tTR7tshGxFB2sca4wtRTbhQEUq27P0zYU8qfQR0pdAzyJ9HwrdAfslX/7aZh+iIR
	 sTVYpkFwGR0x8cdVtPpUtnSE4bJ9Ypd3mPIuYR0A=
Date: Mon, 29 Jun 2026 16:59:29 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,rppt@kernel.org,pabeni@redhat.com,mst@redhat.com,ljs@kernel.org,jasowang@redhat.com,eperezma@redhat.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-include-include-stdinth-for-size_max-in-overflowh.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629235929.9D7611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/include: include stdint.h for SIZE_MAX in overflow.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-include-include-stdinth-for-size_max-in-overflowh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-include-include-stdinth-for-size_max-in-overflowh.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

tools-virtio-add-missing-compat-definitions-for-vhost_net_test.patch
tools-include-include-stdinth-for-size_max-in-overflowh.patch
tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch

