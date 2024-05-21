Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7138852F70;
	Tue, 21 May 2024 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716334214; cv=none; b=BGvSinq/k84KV7wW4HUY0+TCHSFEw7vKRkWUMspQjccb/1rpENeorEPMuax1IPgJgrx54AtwiR+KnRPldpYhTZoK8dhxGOnzle/w8DCMa2VegL9Cwv+NKA17Ig34T9E757vaDWyzm/xiv6w2xEP1M2QDI3iE6G1Wl+JLnxeZDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716334214; c=relaxed/simple;
	bh=8oLezZvMMlzUJMZexbnHMFCRKFIqWVPe4uWFf3j6BPw=;
	h=Date:To:From:Subject:Message-Id; b=K680IhGw0sTAyV1KilORux8Kxb1E1RLhsz+adpLNsQxHn+QcP+jCEcyD9QQ5hOeTMuMshYwkc8l087TNNFyKf7q9qU5LZt2ylEUgK6NGSNznJekuAZVThiOoojw93prXF989Grf2J0QqbBd2IXB0wDqmcPzk4ZzLhKJMvBcJLY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NorE2ApS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NorE2ApS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43DCC2BD11;
	Tue, 21 May 2024 23:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716334213;
	bh=8oLezZvMMlzUJMZexbnHMFCRKFIqWVPe4uWFf3j6BPw=;
	h=Date:To:From:Subject:From;
	b=NorE2ApSybUKGntDFN/s6cLwXhfgY3NO8k3euI4D+Br9mPKcUUSZsA9VSrex3i2hs
	 vTu6ZYgtq+8U9JQccBrZljXqhXusA2GhWovMP7zW10Y54Xy7+emR5YAUqM92gLuqyK
	 w4wb34IsU1jnwZPYpw6X98RefSsoZXwftREXaMhY=
Date: Tue, 21 May 2024 16:30:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,skhan@linuxfoundation.org,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-build-warnings-on-ppc64.patch added to mm-hotfixes-unstable branch
Message-Id: <20240521233013.B43DCC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix build warnings on ppc64
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-build-warnings-on-ppc64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-build-warnings-on-ppc64.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: selftests/mm: fix build warnings on ppc64
Date: Tue, 21 May 2024 13:02:19 +1000

Fix warnings like:

  In file included from uffd-unit-tests.c:8:
  uffd-unit-tests.c: In function `uffd_poison_handle_fault':
  uffd-common.h:45:33: warning: format `%llu' expects argument of type
  `long long unsigned int', but argument 3 has type `__u64' {aka `long
  unsigned int'} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Link: https://lkml.kernel.org/r/20240521030219.57439-1-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c    |    1 +
 tools/testing/selftests/mm/uffd-common.h |    1 +
 2 files changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-fix-build-warnings-on-ppc64
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -1,3 +1,4 @@
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <errno.h>
 #include <stdio.h>
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-fix-build-warnings-on-ppc64
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -8,6 +8,7 @@
 #define __UFFD_COMMON_H__
 
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <stdio.h>
 #include <errno.h>
 #include <unistd.h>
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

selftests-mm-fix-build-warnings-on-ppc64.patch

