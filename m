Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F100B33A9FC
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 21:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785791458; cv=none; b=qJxoSiE9sgCA4c1Z+A/sYtBDiLEgtYGBezhFxFYR/RWxIqLwCp+XWPwOV35N2yVMMbigH3JvC0US/8C3LcYHEA8JmKppldmkoFreDVu07tyjtwReT1pkyizzzReun2TjIDw+aNl9lFeZOnjrinafWZ6lgLXr4QvHhTn/nI49+B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785791458; c=relaxed/simple;
	bh=dedywzyAjQ6wYfakfILqTcHD7b61LR4/NWg2hXYHL7E=;
	h=Date:To:From:Subject:Message-Id; b=D8U3vBm9F84exSJurgDc90CtTFDfQtquoVLNnayYatZkhC9E4zMao4TjSTg7q2i4b4sXxI2vjduRuYLSC6a7FcUVARiP5OEc3jrTcZBn1daH8nPwPeU1RBERXsPBRQ3f74T2Iq2i+ONF1/qebv3PaFNsIr9E33pPqUHrXxddQm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BTIfnnps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BTIfnnps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4DE1F000E9;
	Mon,  3 Aug 2026 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785791456;
	bh=D59lJECgG3AC9vfc1iC43kdE5MgLTPtUu3oYUDFFyo0=;
	h=Date:To:From:Subject;
	b=BTIfnnpsj6mVjSzhxQD2XMKxSRUfVg3rPWWwc8pnZzbMUkmvI2LyGsHODCsu/aU0E
	 lnL705YYa+rDHJTeKXXpJWprpWOCSnp0gn65MtcKbsdUHLwtvMZLZeBlz/LxbBI/AS
	 GRwlHR6mTf6mPmhPE0xjczcsDTsWyNSJ1kQah5eY=
Date: Mon, 03 Aug 2026 14:10:56 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch added to mm-nonmm-unstable branch
Message-Id: <20260803211056.8B4DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/prctl: fix non-anonymous VMA mapping in set-anon-vma-name test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/prctl: fix non-anonymous VMA mapping in set-anon-vma-name test
Date: Mon, 3 Aug 2026 18:30:46 +0800

The test creates a non-anonymous VMA (ptr_not_anon) via mmap() with
MAP_PRIVATE but without MAP_ANONYMOUS, using fd=0 (stdin) as the file
descriptor.  This always fails because fd=0 is not a regular file, and the
failure was hidden because ASSERT_NE() incorrectly checked for NULL
instead of MAP_FAILED.

Fix by using mkstemp() + ftruncate() to create a real temporary file, then
mapping it with MAP_PRIVATE to obtain a genuine file-backed VMA.  Also fix
the mmap() error checks to use MAP_FAILED instead of NULL, and pass fd=-1
for the anonymous mapping for clarity.  The temp file is unlinked
immediately so it does not persist on disk.

Link: https://lore.kernel.org/20260803103046.14324-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/prctl/set-anon-vma-name-test.c |   21 +++++++---
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/prctl/set-anon-vma-name-test.c~selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test
+++ a/tools/testing/selftests/prctl/set-anon-vma-name-test.c
@@ -4,11 +4,13 @@
  */
 
 #include <errno.h>
+#include <fcntl.h>
 #include <sys/prctl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <string.h>
+#include <unistd.h>
 
 #include "kselftest_harness.h"
 
@@ -73,15 +75,24 @@ int was_renaming_successful(char *target
 
 FIXTURE(vma) {
 	void *ptr_anon, *ptr_not_anon;
+	int fd_not_anon;
 };
 
 FIXTURE_SETUP(vma) {
+	char template[] = "./set-anon-vma-test-XXXXXX";
+
 	self->ptr_anon = mmap(NULL, AREA_SIZE, PROT_READ | PROT_WRITE,
-					MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
-	ASSERT_NE(self->ptr_anon, NULL);
+					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(self->ptr_anon, MAP_FAILED);
+
+	self->fd_not_anon = mkstemp(template);
+	ASSERT_NE(self->fd_not_anon, -1);
+	unlink(template);
+	ASSERT_EQ(ftruncate(self->fd_not_anon, AREA_SIZE), 0);
 	self->ptr_not_anon = mmap(NULL, AREA_SIZE, PROT_READ | PROT_WRITE,
-					MAP_PRIVATE, 0, 0);
-	ASSERT_NE(self->ptr_not_anon, NULL);
+					MAP_PRIVATE, self->fd_not_anon, 0);
+	ASSERT_NE(self->ptr_not_anon, MAP_FAILED);
+	close(self->fd_not_anon);
 }
 
 FIXTURE_TEARDOWN(vma) {
@@ -98,7 +109,7 @@ TEST_F(vma, renaming) {
 	EXPECT_EQ(rename_vma((unsigned long)self->ptr_anon, AREA_SIZE, BAD_NAME), -EINVAL);
 
 	TH_LOG("Try to rename non-anonymous VMA");
-	EXPECT_EQ(rename_vma((unsigned long) self->ptr_not_anon, AREA_SIZE, GOOD_NAME), -EINVAL);
+	EXPECT_EQ(rename_vma((unsigned long) self->ptr_not_anon, AREA_SIZE, GOOD_NAME), -EBADF);
 }
 
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

