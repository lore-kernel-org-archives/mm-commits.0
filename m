Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3552F2914
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790902312; cv=none; b=kDWBS5SH9nvIVy9FjaeiZS3LQHaS8jfMlhBZ1TsvnMAd8Rnquu1nYxQP2hwAWcMzOIxaniJWJj0IKAiZYzr9z5gZ4zFM1IMP3VpqAuqZd9EcrKT2HoE0qtH2SfULbeDSAaXI8kICwPFK2U1VUMctGXxJ8WKkeFs/50XOfy1rNp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790902312; c=relaxed/simple;
	bh=SVhwxF0RSdN9BgM3rBfCPfymooWy+LYL1AZP8ngYEDk=;
	h=Date:To:From:Subject:Message-Id; b=MiNpfpSOn0vZcqN6QbtdiKsVMBv5FqA/jhBGHLBrSZUplgRvswFY5KA8QnFpEy11orNIIZY7t2FSuIsZDcuN6dAZa04ZcdSUQOF1rc2bUPYGwSPm/UieoWnX/rQywQpnmWAMazsTVOrUoZApjWCGVuDOLMlHZevRXy0tpZA3PTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQBsPVmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQBsPVmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211A91F000FF;
	Fri,  2 Oct 2026 00:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790902310;
	bh=/dSo5bc7Rdz4x59vzlEgW526w1X83dpa05HRE0MpzWo=;
	h=Date:To:From:Subject;
	b=NQBsPVmUTDOVaLQdRdPcg6KuqXqyWqxbs1Hr+lse4ocfaM43Xbp21mVXcA07Y6xQo
	 7qn0FTfp+4dCFHUw6S0oHHcB9zP/x3ZpT9xNtDJRuQLc5IN4stE4qKXp31W0Vhg/1I
	 nFrGag48K7gGaT1c0O9XisKCDQswbQom3YQFsbCc=
Date: Thu, 01 Oct 2026 17:51:49 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,oberpar@linux.ibm.com,nsc@kernel.org,nathan@kernel.org,masahiroy@kernel.org,arnd@arndb.de,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch added to mm-nonmm-unstable branch
Message-Id: <20261002005150.211A91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: use $(CFLAGS_GCOV) in the prefer-atomic try-run test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: kbuild: use $(CFLAGS_GCOV) in the prefer-atomic try-run test
Date: Thu, 01 Oct 2026 18:57:11 +0200

Patch series "kbuild: GCOV cleanups following the prefer-atomic fix".

Two cleanups Peter Oberparleiter suggested while reviewing commit
56cb9b7d96b2 ("gcov: use atomic counter updates to fix concurrent access
crashes"):

https://lore.kernel.org/e1b6e768-51af-468b-a729-0ed3fceef2f1@linux.ibm.com

Patch 1 makes the prefer-atomic try-run test reuse $(CFLAGS_GCOV) instead
of spelling the flags out again, so the test compiles with the exact GCOV
flags, -fno-tree-loop-im included.

Patch 2 moves the CFLAGS_GCOV block into scripts/Makefile.gcov, included
via include-$(CONFIG_GCOV_KERNEL) like the other instrumentation
makefiles.  The try-run also stops running on builds without GCOV.


This patch (of 2):

Reference $(CFLAGS_GCOV) in the try-run test introduced by
commit 56cb9b7d96b2 ("gcov: use atomic counter updates to fix
concurrent access crashes"), otherwise it can miss potential future
changes in the list of flags used for GCOV profiling like it misses
-fno-tree-loop-im at the moment.

The outcome of the test is unchanged: -fno-tree-loop-im does not affect
the undefined symbols the test compares.

Link: https://lore.kernel.org/20261001-b4-prep-gcov-v1-0-794792e06f24@virtuozzo.com
Link: https://lore.kernel.org/20261001-b4-prep-gcov-v1-1-794792e06f24@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
---

 Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Makefile~kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test
+++ a/Makefile
@@ -1184,11 +1184,11 @@ CFLAGS_GCOV	+= -fno-tree-loop-im
 # undefined symbols (e.g. libatomic calls that the kernel cannot link).
 CFLAGS_GCOV	+= $(call try-run,\
 	echo 'long long x; void f(void){x++;}' | \
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w -fprofile-arcs \
-	-ftest-coverage -x c - -c -o "$$TMP.base" && \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w $(CFLAGS_GCOV) \
+	-x c - -c -o "$$TMP.base" && \
 	echo 'long long x; void f(void){x++;}' | \
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w -fprofile-arcs \
-	-ftest-coverage -fprofile-update=prefer-atomic \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w $(CFLAGS_GCOV) \
+	-fprofile-update=prefer-atomic \
 	-x c - -c -o "$$TMP" && \
 	$(NM) "$$TMP.base" | grep ' U ' > "$$TMP.ubase" || true ; \
 	$(NM) "$$TMP" | grep ' U ' > "$$TMP.utest" || true ; \
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

selftests-core-fix-unshare_test-with-large-fsnr_open.patch
kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch
kbuild-move-gcov-flags-to-scripts-makefilegcov.patch

