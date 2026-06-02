Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160863BD65D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439208; cv=none; b=sFktQUEC8VgFaOIXg9zwrh7fYfdkI6/El5F5e6mHFyogaSIgfdqz52u609UB1tFRcrC1/7QUnmsK9rConY7B4xAK54ca2evi0KFtrJ10RIX+8VwULVxNcNiIw0mgNrOo2NtX6LiGS+y0asSQCbBGrly4D9mjY7GzoecDECPne2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439208; c=relaxed/simple;
	bh=KOZT+Ks05TaPeRomUSoGxn1bPbpPfdL5uE0//1xfnaU=;
	h=Date:To:From:Subject:Message-Id; b=m9NcHHqaJMRRU2I/psteeSgfjyv/A+qfsqtCCIVu/2VhekF6NJXWsOkSUDLnq0eRkL6joLEMCe0oTlHzGJRvI3i48vLUp/iupmLgZCUZZk82bbk3zZkcQNHfCbM2jtHVYbHTqddEsOI0h6Z/o1XE98OCBA8YqnFRokCfbJytRq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=miggRDpf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="miggRDpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF92D1F00893;
	Tue,  2 Jun 2026 22:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439207;
	bh=yoyO01xDnYuhR25kit53X0PoTLghWsDKGvD2DjCBLOs=;
	h=Date:To:From:Subject;
	b=miggRDpfUsrixRR0dkPK2x/VvuH9xhnPBZKUtlnIvovn/L5mlh/pc0eQ/41v5Fr6G
	 6+jabgyxKSCxJFRUGZomZlvXCIMYCR5jb17Wr94Enx8Lm9PaS32EnIq/yZIP8F08W1
	 c49VB5A5pesn7g5sLdvYuwcllKtCPl+fGIyTEYdU=
Date: Tue, 02 Jun 2026 15:26:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,eva.kurchatova@virtuozzo.com,aris@redhat.com,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch removed from -mm tree
Message-Id: <20260602222646.DF92D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: fix -Wmaybe-uninitialized warning in memfd_test
has been removed from the -mm tree.  Its filename was
     selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


