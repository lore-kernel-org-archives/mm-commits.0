Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02126059D
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783284542; cv=none; b=oCE/WHC2asXJIZ8SOo4YFVIBV7I+mGe5Od3W5OcGdpP6xtYh3cj9OplS6ikfd/7S1TsAUgVmeSk32sO4Am9z1/4Z/VhhZ0h64qOYDxrg1H/VsSMGsEqiK5EHhZDVqMgRihaXMgOYFtWA8Ln2xDH3DOTfFFJNqhnfklKLUeHrOcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783284542; c=relaxed/simple;
	bh=ez9t9K5MDQvq9uSLtI8x1YEIQZirguX82O/Lr4KK6rc=;
	h=Date:To:From:Subject:Message-Id; b=JVHQasgrlCOyuxD09YLSrWdWqrAtyKmiqhGoYwkXD4waUUUqHmyBZvwM42JChxZFOOLMHp2WfIJgMYtqrjI1jQNSE5fY4c4/RObLpVsDdDF9S5jxTx6R/hkLJdIuDk9A4J4q73lbIwpgLECfjLwfxesy9NomMHZfcKI+Brzup38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l5ln3AMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l5ln3AMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3013A1F000E9;
	Sun,  5 Jul 2026 20:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783284541;
	bh=3vmMylacou6SRx8TcK8EtXBJifx8yrfCgMS2xSy4mtc=;
	h=Date:To:From:Subject;
	b=l5ln3AMarUfqQfCotW6dYHo9Z0qPE4PZocwGvf08Duhmpv51tdMmhfJyDSPLabok4
	 8XP3ofdqXaYOU1FIGcC2u6xsYC2kX65PWmOj19BAkqG82jWTLgAabIJ4LhkhfOA+/q
	 hMbYUz4n+lpdpHLIVRJdgFJhRmArK94W/GHI2V4A=
Date: Sun, 05 Jul 2026 13:49:00 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch added to mm-unstable branch
Message-Id: <20260705204901.3013A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch

This patch will later appear in the mm-unstable branch at
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
Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Thu, 2 Jul 2026 14:23:30 +0800

Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.  The
old path only printed an error and continued; the test now exits via
pkey_assert() on failure so it does not hang or proceed with an invalid
child.

Link: https://lore.kernel.org/20260702062332.911786-4-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -329,7 +329,7 @@ static void test_sigsegv_handler_with_di
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -502,7 +502,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

