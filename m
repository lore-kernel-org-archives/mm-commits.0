Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF772EEAA
	for <mm-commits@vger.kernel.org>; Sun, 30 Mar 2025 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743370174; cv=none; b=e8oMnrG5DDuXB9UU0wrdPs9xjqdxpL/sZC1wJ6Dz359pHrrZesbviDmFdsqGIuf/cU+BWrSzt9hOUvbCudXZqCeVvvLOj5wl7MlijonzFmpakVRgbGVg7dHNJtRASaQ1+ILwWZBLsXlMlrTtgQ15S3npZQbtHlaTWLVOXFJw6Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743370174; c=relaxed/simple;
	bh=d4fl+KQwyrc+gWQAQ+x1idix6TtWHqcnXXpwYpb2lhs=;
	h=Date:To:From:Subject:Message-Id; b=mM9t/5IptwwWmTXNshFEqVg/qSeyS7sVpjWWKJD5CTeOVeHDYZIpxSmZTj8WoB+aFvqEiTDToKFoGr7rUmChUTq0e9baXdfgDq8v6KvEecXq9FqUE3On/AiRJd8sO0pqV4i15QIag7q/WG7Ktr1wOVzD1uRbhwZJ4dC2J6ggSCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWHyGD72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWHyGD72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F898C4CEDD;
	Sun, 30 Mar 2025 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743370174;
	bh=d4fl+KQwyrc+gWQAQ+x1idix6TtWHqcnXXpwYpb2lhs=;
	h=Date:To:From:Subject:From;
	b=tWHyGD72XPUPY8QOnET69mNlYqMKnLYWBczjGU/fbdFaOn2ifZORpnCfjMYmLDHVV
	 EIjvMpLbasaajQJGptJMQXwkdhJbbdfM6Eov4b2a6ll37zPTKbSzXDbHSUgjBSHdba
	 Kdzd2A1gjwWD8znHqjlL8IxHRTpMH/hBZQzhKeH4=
Date: Sun, 30 Mar 2025 14:29:33 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,davidgow@google.com,acarmina@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bug-kunit-core-support-for-suppressing-warning-backtraces-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250330212934.3F898C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: fix compilation error on s390
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bug-kunit-core-support-for-suppressing-warning-backtraces-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bug-kunit-core-support-for-suppressing-warning-backtraces-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alessandro Carminati <acarmina@redhat.com>
Subject: kunit: fix compilation error on s390
Date: Sat, 29 Mar 2025 15:03:20 +0000

The current implementation of suppressing warning backtraces uses
__func__, which is a compile-time constant only for non -fPIC compilation.
GCC's support for this situation in position-independent code varies
across versions and architectures.

On the s390 architecture, -fPIC is required for compilation, and support
for this scenario is available in GCC 11 and later.

Link: https://lkml.kernel.org/r/20250329150320.331018-1-acarmina@redhat.com
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Acked-by: David Gow <davidgow@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/kunit/Kconfig~bug-kunit-core-support-for-suppressing-warning-backtraces-fix
+++ a/lib/kunit/Kconfig
@@ -17,6 +17,7 @@ if KUNIT
 
 config KUNIT_SUPPRESS_BACKTRACE
 	bool "KUnit - Enable backtrace suppression"
+	depends on (!S390 && CC_IS_GCC) || (CC_IS_GCC && GCC_VERSION >= 110000)
 	default y
 	help
 	  Enable backtrace suppression for KUnit. If enabled, backtraces
_

Patches currently in -mm which might be from acarmina@redhat.com are

bug-kunit-core-support-for-suppressing-warning-backtraces-fix.patch
kunit-add-test-cases-for-backtrace-warning-suppression-fix.patch

