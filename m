Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857922DB788
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790902313; cv=none; b=mRJk+hIO73zJlTFwQYPKlKcLmDujxrVNoyi5bF8T4RlJtHJZER70lyttlZQoQcjKEcgpZogXfuh3kPIa6egSHAwcuxUnqC58zWGEHyzsraRhbjSjkDQlBYOdopI6f9hxIM5yozYpRtnQ8ctYrPGgPsB/arWYX6lq+IstesqciPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790902313; c=relaxed/simple;
	bh=rI4akYqSTTVRRAVSN7osfzuJcm2snp5zraNiNKXzmRY=;
	h=Date:To:From:Subject:Message-Id; b=PdlNCZ0t8MQlu6FXU2zKZl2OfU4w4PqzCbXrgFC0cuiTsC6MNfCmBHMdcnFSU0SW2HncP3g9Wl9rBsrRp3H3iAyngmMk/7j/+d0QZzWMIi50bMtwRx2g/LJ9aZkzk8HZ2hh3zBFyH0QeSj/V4mjAHhC44nMgHF8Ngj5Bq1yb+n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kj/PrBlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kj/PrBlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082281F00893;
	Fri,  2 Oct 2026 00:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790902312;
	bh=OIforvvvAwxOU8ToK8975Im6KjjoKIm7cs0VBLUqMQw=;
	h=Date:To:From:Subject;
	b=kj/PrBljy3U7T8Tyfun2LKkVLFHQgyijRjV42OmV3gI+xz91Jl1npg51KaRCQ3Iqm
	 dibGsJSFfVWu4VyTOHDbwvDNVizRR6KJYcgOwMUAFx6gtNs6e0bH4EPEbtXCW3DB6v
	 vxjeH5uGctWPVwxuZCNXCM8lbqoh/epQkGPYRnkc=
Date: Thu, 01 Oct 2026 17:51:51 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,oberpar@linux.ibm.com,nsc@kernel.org,nathan@kernel.org,masahiroy@kernel.org,arnd@arndb.de,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-move-gcov-flags-to-scripts-makefilegcov.patch added to mm-nonmm-unstable branch
Message-Id: <20261002005152.082281F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: move GCOV flags to scripts/Makefile.gcov
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-move-gcov-flags-to-scripts-makefilegcov.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-move-gcov-flags-to-scripts-makefilegcov.patch

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
Subject: kbuild: move GCOV flags to scripts/Makefile.gcov
Date: Thu, 01 Oct 2026 18:57:12 +0200

 * split the CFLAGS_GCOV block out of the top-level Makefile into
   scripts/Makefile.gcov
 * include it via include-$(CONFIG_GCOV_KERNEL) like neighbour
   KASAN/KCOV/UBSAN makefiles do
 * keep the include before scripts/Makefile.gcc-plugins: the try-run
   must not get -fplugin= options, plugins do not exist on clean builds

CFLAGS_GCOV is no longer defined when CONFIG_GCOV_KERNEL is off:
 * its user in scripts/Makefile.lib is guarded by the CONFIG_GCOV_KERNEL
 * in i915/xe header an empty value is harmless

The try-run compiler invocations also stop running on builds without
GCOV.

Link: https://lore.kernel.org/20261001-b4-prep-gcov-v1-2-794792e06f24@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
---

 MAINTAINERS           |    1 +
 Makefile              |   22 +---------------------
 scripts/Makefile.gcov |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 21 deletions(-)

--- a/MAINTAINERS~kbuild-move-gcov-flags-to-scripts-makefilegcov
+++ a/MAINTAINERS
@@ -10898,6 +10898,7 @@ M:	Peter Oberparleiter <oberpar@linux.ib
 S:	Maintained
 F:	Documentation/dev-tools/gcov.rst
 F:	kernel/gcov/
+F:	scripts/Makefile.gcov
 
 GDB KERNEL DEBUGGING HELPER SCRIPTS
 M:	Jan Kiszka <jan.kiszka@siemens.com>
--- a/Makefile~kbuild-move-gcov-flags-to-scripts-makefilegcov
+++ a/Makefile
@@ -1176,27 +1176,6 @@ endif
 # Ensure compilers do not transform certain loops into calls to wcslen()
 KBUILD_CFLAGS += -fno-builtin-wcslen
 
-CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
-ifdef CONFIG_CC_IS_GCC
-CFLAGS_GCOV	+= -fno-tree-loop-im
-# Use atomic counter updates to avoid concurrent-access crashes in GCOV.
-# Only enable if -fprofile-update=prefer-atomic does not introduce new
-# undefined symbols (e.g. libatomic calls that the kernel cannot link).
-CFLAGS_GCOV	+= $(call try-run,\
-	echo 'long long x; void f(void){x++;}' | \
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w $(CFLAGS_GCOV) \
-	-x c - -c -o "$$TMP.base" && \
-	echo 'long long x; void f(void){x++;}' | \
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w $(CFLAGS_GCOV) \
-	-fprofile-update=prefer-atomic \
-	-x c - -c -o "$$TMP" && \
-	$(NM) "$$TMP.base" | grep ' U ' > "$$TMP.ubase" || true ; \
-	$(NM) "$$TMP" | grep ' U ' > "$$TMP.utest" || true ; \
-	cmp -s "$$TMP.ubase" "$$TMP.utest",\
-	-fprofile-update=prefer-atomic)
-endif
-export CFLAGS_GCOV
-
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += -fmacro-prefix-map=$(srcroot)/=
@@ -1214,6 +1193,7 @@ include-$(CONFIG_KCSAN)		+= scripts/Make
 include-$(CONFIG_KMSAN)		+= scripts/Makefile.kmsan
 include-$(CONFIG_UBSAN)		+= scripts/Makefile.ubsan
 include-$(CONFIG_KCOV)		+= scripts/Makefile.kcov
+include-$(CONFIG_GCOV_KERNEL)	+= scripts/Makefile.gcov
 include-$(CONFIG_RANDSTRUCT)	+= scripts/Makefile.randstruct
 include-$(CONFIG_KSTACK_ERASE)	+= scripts/Makefile.kstack_erase
 include-$(CONFIG_AUTOFDO_CLANG)	+= scripts/Makefile.autofdo
diff --git a/scripts/Makefile.gcov a/scripts/Makefile.gcov
new file mode 100644
--- /dev/null
+++ a/scripts/Makefile.gcov
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0-only
+CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
+ifdef CONFIG_CC_IS_GCC
+CFLAGS_GCOV	+= -fno-tree-loop-im
+# Use atomic counter updates to avoid concurrent-access crashes in GCOV.
+# Only enable if -fprofile-update=prefer-atomic does not introduce new
+# undefined symbols (e.g. libatomic calls that the kernel cannot link).
+CFLAGS_GCOV	+= $(call try-run,\
+	echo 'long long x; void f(void){x++;}' | \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w $(CFLAGS_GCOV) \
+	-x c - -c -o "$$TMP.base" && \
+	echo 'long long x; void f(void){x++;}' | \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w $(CFLAGS_GCOV) \
+	-fprofile-update=prefer-atomic \
+	-x c - -c -o "$$TMP" && \
+	$(NM) "$$TMP.base" | grep ' U ' > "$$TMP.ubase" || true ; \
+	$(NM) "$$TMP" | grep ' U ' > "$$TMP.utest" || true ; \
+	cmp -s "$$TMP.ubase" "$$TMP.utest",\
+	-fprofile-update=prefer-atomic)
+endif
+export CFLAGS_GCOV
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

selftests-core-fix-unshare_test-with-large-fsnr_open.patch
kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch
kbuild-move-gcov-flags-to-scripts-makefilegcov.patch

