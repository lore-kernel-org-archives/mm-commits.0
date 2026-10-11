Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B98D4052C2
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757209; cv=none; b=jsYAKa+IVGYaFJywdzguQJIa51YakqzEGJgyM3N00WfMjVVE+MZaTnkf3mExzLqMXn15tbSxc6sihgnf3woE19CdUQVET7gK4JmWRdF59SRaye0gO2sYGcCPU07/6VGQnKBegUPAsA3NL9/wRA05uWl0y3xoCsIG8ctJ1OyvrJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757209; c=relaxed/simple;
	bh=vnkllXQrJpapk7T/iG1TQT30Md9ZRDRqPHgSeshD27w=;
	h=Date:To:From:Subject:Message-Id; b=K8lfc+xi87yj1on++n8UjMvL2JO9RNWmFZwa8vo2DZS5SGpz69aGe3BRKYplCrfGLz7guIci4GbawXn7ZC0KzzMZm1muD4gxJuRYZM3PJZZeBEE8/+9bVu3sdlR6g4PVei4pZPtmNjN7vj0pGM6ogORTD9vSVZofH8Dfy8CqOcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oub1LVaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oub1LVaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDECA1F0089D;
	Sun, 11 Oct 2026 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757207;
	bh=8W1dSNyAjsCkv+MP3TDQlYQylL4F4JcAixbIRj6vjWQ=;
	h=Date:To:From:Subject;
	b=Oub1LVaRF++C+CHC1CX4HWYFvaX/7IXAWo9pVi7RzoNW33l3Z1TjnF792rrJ58wGg
	 gi3EU5kQ52AAEFMMk9Iw6YrRfWl8L56poWPgIg9ruE8+Ul30fYhmrLE3VOW7Vr8dJ5
	 cmbntt4whQ24UYO7kQ+Svc/atOr7mRJ3BzwbraiE=
Date: Sun, 11 Oct 2026 15:20:07 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,oberpar@linux.ibm.com,nsc@kernel.org,nathan@kernel.org,masahiroy@kernel.org,arnd@arndb.de,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch removed from -mm tree
Message-Id: <20261011222007.CDECA1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: use $(CFLAGS_GCOV) in the prefer-atomic try-run test
has been removed from the -mm tree.  Its filename was
     kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


