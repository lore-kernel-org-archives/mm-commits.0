Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F4B25771
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505261; cv=none; b=Hr2sHzHexnYKK4mcgrVYgX3MJ9yrln6W1Kcdr38i7pcuKTCZQ7P7rw5XPDfNXwlovpBoUk9dOPtQdRrt5BZRRlR3JRE7x2nAj4JnNXz+rv6Ln1aRplDltkwnStWBqR18sdV3dkq70FKMlcZTEJ8qEnxZChgui9lkRJdUFRLQ+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505261; c=relaxed/simple;
	bh=NZaZGsyjWQF7yxvi7VRs8XAxFhyXw3UFxDfBT4iEmco=;
	h=Date:To:From:Subject:Message-Id; b=KVTZZ80J1I8sXJNSC11FRQ9wGzl5ZYVQ8bPFKfc1pczCK57j8DdNPJUfTiIQAztAngW0zZiJXcmNeLyo2RfR9Jb/23M1RZ15dM31dA4TwE8kEq1Ga8REia5Xp2jyhycbOurwh/4sUH7ZSgrmB0Fw9dmxtN3PNUBJ3y8W0dfSx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mHtzYf+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mHtzYf+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711E01F000E9;
	Wed, 12 Aug 2026 03:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786505259;
	bh=CHkXonnlxrhCUNNWsULt5pZ44RJr97p5lTh2KJ1D16A=;
	h=Date:To:From:Subject;
	b=mHtzYf+NcRrWN7IGSaAxbNwcSnR263mhRfIxTab3945XJHp91hEfazJ0WfS9/dso+
	 sB7sAoqNhI3pJi2a+W6iCx1ZUMUgrnUplmhEuLxekLMRKsMUdO2Tkv+YVAemtDWDQw
	 +IUUIygFVkw6FNd/b2nhwXnCaLHKEGRW613Q074Y=
Date: Tue, 11 Aug 2026 20:27:39 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch removed from -mm tree
Message-Id: <20260812032739.711E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix
has been removed from the -mm tree.  Its filename was
     kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch

This patch was dropped because it was folded into kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch

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

alloc_tag-expose-boot-time-compression-configuration.patch
alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch
alloc_tag-add-size-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch
kselftest-alloc_tag-extend-the-allocinfo-ioctl-kselftest.patch

