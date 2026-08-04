Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A23E16A4
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785870261; cv=none; b=pNEj3p/3jchiIO9iGwJnBhNhYJgnkpclyRjCu0zNHebEwM4jkapnvviSSqF5uKvTqxbaThDz7J/DvxKQxxxJoLDy3UpcjbtuqrRDaNT+l6teb3xWQPIt/pTUOLvHSI/68uuSE/rOqT77+PuNYzI+bcQV10lky97hxB9lI0r6iQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785870261; c=relaxed/simple;
	bh=4WaN+fiySEcC1ZQ0oLiv7OxqV7ZPZQYGhxZ1WZ5CmNc=;
	h=Date:To:From:Subject:Message-Id; b=GrZr7GodiniTxofH9kdzdGxLvz2M0IN/1Tc9Mjp8aLBLWKjd/xAeuPfI6XXdgunOvL2C9F3SSpCskd3APwcpzZrvt2pduWRVKJQ7aS3VH8wyfMFGMFulmm5HhxdTTSazG055VPTzPTw1O5HQWkr7ureJmP04VB/nao/3QtpIwmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DD/f31aU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DD/f31aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B451F000E9;
	Tue,  4 Aug 2026 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785870260;
	bh=FLX/Aq8/4fnQNWcQ/cmfe8uulce2CpBQ6CwHsMbj8ls=;
	h=Date:To:From:Subject;
	b=DD/f31aURsUK29/7JEkk1L73cZ/WqnBHPShDoww1ZTx/AyUEVlWQAXugJQHCFYM1Z
	 KPGCjn4IdYK2WJIZ0CPAZyL9GFvbC6eYLOPMHrYmF771XR/WWao0hC13do3DnztHlf
	 xn0piqCCHUXXKRAlssHHUnz/fIXtp3w9Ey8plAd0=
Date: Tue, 04 Aug 2026 12:04:19 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch added to mm-unstable branch
Message-Id: <20260804190420.37B451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix
Date: Tue, 4 Aug 2026 18:24:14 +0000

fix a typo in the selftest

Link: https://lore.kernel.org/e4e49ec4a5960292aeeb9e196526c18dc95228a2.1785867739.git.abhishekbapat@google.com
Closes: https://sashiko.dev/#/patchset/cover.1783532853.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c~kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix
+++ a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 /* kselftest for allocinfo ioctl
- * allocinfo ioctl retrives allocinfo data through ioctl
+ * allocinfo ioctl retrieves allocinfo data through ioctl
  * Copyright (C) 2026 Google, Inc.
  */
 
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch
alloc_tag-add-size-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch
kselftest-alloc_tag-extend-the-allocinfo-ioctl-kselftest.patch

