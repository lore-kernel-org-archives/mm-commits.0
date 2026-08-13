Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26823381B0C
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660970; cv=none; b=BpTznuz7uEftZIJPQuuqZR8H1DLClp4CNH+mj9UpX85ZSliwP7l+o3KJcTVuMIkXtk8fVjagkZZH75XqfB/Za9Tok/sKne2iNR/NicoCVGrBf46Pj3mmfXuz7vpbsPNRrsftLqWf0ve9YoK91rYyHRm9Swx3YM0Y4InLG5NM9Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660970; c=relaxed/simple;
	bh=NXn6VzxNYPAANWoNWju0sIpE7e1DmGNS80ijw8uUztU=;
	h=Date:To:From:Subject:Message-Id; b=mUCOlL7Av6h3tVjY5SyO5XivM7PatJxlBoZvg+ruTLkKKIgRMc4k7xOgO0NM4N9d47cjJIqQxXaHMGL2V3ikS9wDLwnH0s6tfjOgKOMHPuoVqPutEUj2xBpERXKU2DzPeDZoY9Wd/kjalQFng5kX6JsE9GRLcTg2VXtQNq/k8RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DG+GX4hs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DG+GX4hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00071F000E9;
	Thu, 13 Aug 2026 22:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660969;
	bh=93E+f1pkhAiUIGV/wAJcTD2eAR7cLts6Wt/HLzVSoao=;
	h=Date:To:From:Subject;
	b=DG+GX4hsEVtcojlTXUjJ3HmGFESohTQ4AAZcrfu4/TXFPM7Ts5/kiFUgpt16BriDp
	 WECiArdngIMu8xbaysotJZvpyOMyCa126YURZhBMbpmMAqkpkqRTb7ZjYQWTHGOaQL
	 Kw4BADnEuCTORRhSXdNEhSO2LwkPlyX80+H9oCZs=
Date: Thu, 13 Aug 2026 15:42:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch removed from -mm tree
Message-Id: <20260813224248.F00071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/prctl: fix non-anonymous VMA mapping in set-anon-vma-name test
has been removed from the -mm tree.  Its filename was
     selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ksm-update-comments-and-docs-to-reference-folio-mapping.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch

