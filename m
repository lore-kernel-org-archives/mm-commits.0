Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A265228643C
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 21:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746018; cv=none; b=okeYkxwwkkQ95M7AOWqg7gQKxJO+Jw+pgzkbxVUp/p/d0WyF3x3tEzruKCP4DiOp+SvLq9juC+QA+k6Zzj2HF3CgISdXYSTN3VuvGBSLB48EV8082MuxiRSrU2WQfDMJDiEGhDEZ0RkoT28MJysqvouOerPQl67fdVDF9xDRlpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746018; c=relaxed/simple;
	bh=oa2ZE/3rtqc6+ZkviXEF0rNWjuKoU3jdICg21uuw3/o=;
	h=Date:To:From:Subject:Message-Id; b=munp4NF4N7/M68h4EeSm+JFOnnzez3qv5j2PIFRzK/PtXUXR+lt8FeqJMYeZeuc1i18ITchqIrRHOkEtqQVLc+9u2XyC7JqGqvtF42PQHt9e5+blpnThjpahcS5AFo45Gx1WVa/JWcZWQLg27/VHteTW9j1Z84hNsgHtRKscfuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PMl9UwML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PMl9UwML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396BE1F000E9;
	Mon, 25 May 2026 21:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779746017;
	bh=C+zSTrMRggceTCPL2pGr8nVYQMpQAeXml9DeEA3bMIk=;
	h=Date:To:From:Subject;
	b=PMl9UwML1Ru4EsQTFZkU3F15HETapZrnoVCOmDhhT8WARnVM1foBb3cquu67vDANm
	 r//oWfHmbZkD5PetcXXCGRHVOEQFWxDQpPEE579wltZU5NCdoaX1VXPCgXAMZodEyt
	 ibr7lfp/bA1WlhAXb81IGttdOoxLLEMA1g9p8uUs=
Date: Mon, 25 May 2026 14:53:36 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,eva.kurchatova@virtuozzo.com,aris@redhat.com,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch added to mm-new branch
Message-Id: <20260525215337.396BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd: fix -Wmaybe-uninitialized warning in memfd_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: selftests/memfd: fix -Wmaybe-uninitialized warning in memfd_test
Date: Sun, 24 May 2026 22:35:56 +0300

Patch series "selftests/memfd: fix compilation warnings".

This patchset fixes warnings about unused but initialized variables, and
unused dummy buffer passed to pwrite() syscall in the tests.


This patch (of 2):

  memfd_test.c: In function 'mfd_fail_grow_write.part.0':
  memfd_test.c:685:13: warning: '<unknown>' may be used uninitialized
  [-Wmaybe-uninitialized]
    685 |         l = pwrite(fd, buf, mfd_def_size * 8, 0);
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

pwrite() is declared with attribute 'access (read_only, 2, 3)', so GCC
knows it reads from the buffer.  malloc() returns uninitialized memory,
hence the warning.  Use calloc() to zero-initialize the buffer.  The
actual contents don't matter here since the test verifies that pwrite()
fails on a sealed memfd.

Link: https://lore.kernel.org/20260524193732.48853-1-eva.kurchatova@virtuozzo.com
Link: https://lore.kernel.org/20260524193732.48853-2-eva.kurchatova@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -688,9 +688,9 @@ static void mfd_assert_grow_write(int fd
 	if (hugetlbfs_test)
 		return;
 
-	buf = malloc(mfd_def_size * 8);
+	buf = calloc(1, mfd_def_size * 8);
 	if (!buf) {
-		printf("malloc(%zu) failed: %m\n", mfd_def_size * 8);
+		printf("calloc(1, %zu) failed: %m\n", mfd_def_size * 8);
 		abort();
 	}
 
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch
selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch
gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

