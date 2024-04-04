Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBA915EA6
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256937; cv=none; b=ekAmhAeTZZiyYX1yWjo/nYJ50/JqSUtccvMuLSn4MEPPmZH3UGj/yMy/fqy34rHKSVDFCaDukt/SH/HrgoAtLGt7p8Qsycp0feligqkY47L9kC/Rgy+a3xSteAw8bpL5QoSuLMNK/6Ec9wjWKJmE6nJTPzS8xOifS0Q4AHUJ9+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256937; c=relaxed/simple;
	bh=wuHa0c7m31piTf/3Eb6LiXB4VT3c5HZaCFk37oAClEo=;
	h=Date:To:From:Subject:Message-Id; b=pAicNNh28KeqeeMHsZ6E055pDkYbq9893jTrjYhxNTT5Sx9KXLKt19O0mLCeVzKpLB8AzLRziLzo6dCl6K8IWwxw7Zp6Q7IS+s9HzoS8Kx1I5Nt2QR/l5ic8Jm/CrmAxYD1sXGP4qiOrhjJNHZBhav2xL/Bj4thsU3VOPcoahz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KsNWHmgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KsNWHmgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F99C433F1;
	Thu,  4 Apr 2024 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712256936;
	bh=wuHa0c7m31piTf/3Eb6LiXB4VT3c5HZaCFk37oAClEo=;
	h=Date:To:From:Subject:From;
	b=KsNWHmgTCC/Fpe9mVfF5pzVswyVQZZ2lm9VrPt6ow9hEhOFLIKmO9XZ7pkMisU7mH
	 a/N3Vfs6PIOuaHQ8AFkPsLSlOfOQlA1re2CTU7ARgyumpLVyAHDHxgu8vFEiSlNsqm
	 52OJsyHGGhp2rk2nbtKk6SYbl3C6kvN5cZ/WOmWk=
Date: Thu, 04 Apr 2024 11:55:36 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,peterz@infradead.org,peterx@redhat.com,david@redhat.com,broonie@kernel.org,axelrasmussen@google.com,aarcange@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-break-the-dependency-upon-local-header-files.patch added to mm-unstable branch
Message-Id: <20240404185536.D3F99C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: break the dependency upon local header files
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-break-the-dependency-upon-local-header-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-break-the-dependency-upon-local-header-files.patch

This patch will later appear in the mm-unstable branch at
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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests: break the dependency upon local header files
Date: Wed, 27 Mar 2024 20:34:17 -0700

Patch series "Fix selftests/mm build without requiring "make headers"".

As mentioned in each patch, this implements the solution that we discussed
in December 2023, in [1].  This turned out to be very clean and easy.  It
should also be quite easy to maintain.

This should also make Peter Zijlstra happy, because it directly addresses
the root cause of his "NAK NAK NAK" reply [2].  :)

[1] https://lore.kernel.org/all/783a4178-1dec-4e30-989a-5174b8176b09@redhat.com/
[2] https://lore.kernel.org/lkml/20231103121652.GA6217@noisy.programming.kicks-ass.net/


This patch (of 2):

Use tools/include/uapi/ files instead.  These are obtained by taking a
snapshot: run "make headers" at the top level, then copy the desired
header file into the appropriate subdir in tools/uapi/.

This was discussed and solved in [1].

However, even before copying any additional files there, there are already
quite a few in tools/include/uapi already.  And these will immediately fix
a number of selftests/mm build failures.

So this patch:

a) Adds TOOLS_INCLUDES to selftests/lib.mk, so that all selftests can
   immediately and easily include the snapshotted header files.

b) Uses $(TOOLS_INCLUDES) in the selftests/mm build.  On today's Arch
   Linux, this already fixes all build errors except for a few
   userfaultfd.h (those will be addressed in a subsequent patch).

[1] https://lore.kernel.org/all/783a4178-1dec-4e30-989a-5174b8176b09@redhat.com/

Link: https://lkml.kernel.org/r/20240328033418.203790-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20240328033418.203790-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/lib.mk      |    9 +++++++++
 tools/testing/selftests/mm/Makefile |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/lib.mk~selftests-break-the-dependency-upon-local-header-files
+++ a/tools/testing/selftests/lib.mk
@@ -48,6 +48,15 @@ ifeq ($(KHDR_INCLUDES),)
 KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
 endif
 
+# In order to use newer items that haven't yet been added to the user's system
+# header files, add $(TOOLS_INCLUDES) to the compiler invocation in each
+# each selftest.
+# You may need to add files to that location, or to refresh an existing file. In
+# order to do that, run "make headers" from $(top_srcdir), then copy the
+# header file that you want from $(top_srcdir)/usr/include/... , to the matching
+# subdir in $(TOOLS_INCLUDE).
+TOOLS_INCLUDES := -isystem $(top_srcdir)/tools/include/uapi
+
 # The following are built by lib.mk common compile rules.
 # TEST_CUSTOM_PROGS should be used by tests that require
 # custom build rule and prevent common build rule use.
--- a/tools/testing/selftests/mm/Makefile~selftests-break-the-dependency-upon-local-header-files
+++ a/tools/testing/selftests/mm/Makefile
@@ -32,7 +32,7 @@ endif
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 LDLIBS = -lrt -lpthread -lm
 
 TEST_GEN_FILES = cow
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

huge_memoryc-document-huge-page-splitting-rules-more-thoroughly.patch
selftests-break-the-dependency-upon-local-header-files.patch
selftests-mm-fix-additional-build-errors-for-selftests.patch

