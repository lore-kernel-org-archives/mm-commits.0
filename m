Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D6828643C
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 21:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746020; cv=none; b=E0DPoXRrF+AH2YAbWUcdQ7eu+hEyqVaaeZ25e7h2xI8PqkZq7lSPcNktKrz13o4G4y4hWXnZ3nA5k7W/3Rk8nYVKGGgWVTtxdrPuFnIZJnGFqxb87dWZJFJ+uE19ifaIXw9lpreS5/6kNkKWKC8K35XpcYqVFYmfrepE2xFLKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746020; c=relaxed/simple;
	bh=Jm+9hVmkmpDnywpAjVTnw9CPzPsM6MgENgbAoGjfdq8=;
	h=Date:To:From:Subject:Message-Id; b=GZLLSbIwZ78kadAjFjDiB6vTiJ6sdqpPpKZrkXi7n6hIqa/mHNYBSx7YUYrgByt+uATgvbzhdmnNPKE2HnJJ2CV8UnCN2+tcrc9RSdfH7lWl9w6CLY1Rf1p4K5qLufcl+AuyIjvbHvv5zyYVoW4nPh9h19HboiagLlUaJElJN+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b+3bFt+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+3bFt+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA741F000E9;
	Mon, 25 May 2026 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779746019;
	bh=UYSDyCJ8DkRpOdtQDNOBI1aJNOYj/oaUk8JK9SXI4q0=;
	h=Date:To:From:Subject;
	b=b+3bFt+sjL2T0fkAhUeeDPpqSVFikwf1FhzypsM/4MylMwjVqtA9IsLWXS1pY4oCE
	 FctzIca4mPyV0SpHa5x3qBONA/Igw+z/5G35dRmf2/9+Tg7lBUDZV17YgC3GTlMjq5
	 sQRDuLNJLQxrlJorLRTblCzeXsw22+vP2gFnDRdY=
Date: Mon, 25 May 2026 14:53:38 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,aris@redhat.com,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch added to mm-new branch
Message-Id: <20260525215339.1AA741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd: remove unused variable 'sig' in fuse_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch

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
Subject: selftests/memfd: remove unused variable 'sig' in fuse_test
Date: Sun, 24 May 2026 22:35:57 +0300

  fuse_test.c: In function 'sealing_thread_fn':
  fuse_test.c:165:13: warning: unused variable 'sig' [-Wunused-variable]
    165 |         int sig, r;
        |             ^~~

Remove unused 'sig' to fix -Wunused-variable warning.

Link: https://lore.kernel.org/20260524193732.48853-3-eva.kurchatova@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/fuse_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/fuse_test.c~selftests-memfd-remove-unused-variable-sig-in-fuse_test
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -162,7 +162,7 @@ static void *global_p = NULL;
 
 static int sealing_thread_fn(void *arg)
 {
-	int sig, r;
+	int r;
 
 	/*
 	 * This thread first waits 200ms so any pending operation in the parent
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

selftests-memfd-fix-wmaybe-uninitialized-warning-in-memfd_test.patch
selftests-memfd-remove-unused-variable-sig-in-fuse_test.patch
gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

