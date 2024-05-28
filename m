Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C25117B434
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716929390; cv=none; b=J5KjuS0ms1WV/hifrZJE55tkUWJ4m/jPVX0F/0jcc2Rxi6f3KFRzZe1WQl3+AqNqhEpZAaUIjrKapFUnB961OwW5jpXTn8B5CuyFWTBYQV5HYFyi8ggP5U9Mj6WzMTdkegeU/uN0w5Jl9uxVn+P1ivaI7V4/0IAs4Lst+hjvbCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716929390; c=relaxed/simple;
	bh=xLfFBvfQk5nFLoPS5Zx/mIpXDpG5vdfwxltJqtSnb6c=;
	h=Date:To:From:Subject:Message-Id; b=pziStEaLd2ViYkWKPypHLH6vjnI31ByIDC5EjeyYZqWtFVr1bDKM0CRW08uhC7e0kGP4DJffR6QwQLHf87hY+Tig0yducnfHVjRWkV+eq9MNuk0LRLWIqyGsWqs0Td6e9UON5YYqpuYHfwF4FJfs1qSfC+H4szaNMrQXo8x17J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dRD5rmJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRD5rmJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96F4C3277B;
	Tue, 28 May 2024 20:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716929389;
	bh=xLfFBvfQk5nFLoPS5Zx/mIpXDpG5vdfwxltJqtSnb6c=;
	h=Date:To:From:Subject:From;
	b=dRD5rmJH5S3QDDfAN7LDFncWzcXRqievsfUZ1p2YsD1VisR3WAaIdIZHipMoBqoC9
	 sD05g+RjpRYvBSE3LC5ZFESiniyDh420/DvTcIGAb+XXsBNSy9XPD/KSErFMFdb64k
	 TdIx2Uqn4vMK9wuKzH7Mn1f30VlmroDb7BG0eBco=
Date: Tue, 28 May 2024 13:49:49 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,kernel@valentinobst.de,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch added to mm-nonmm-unstable branch
Message-Id: <20240528204949.B96F4C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mqueue: fix 5 warnings about signed/unsigned mismatches
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: selftests/mqueue: fix 5 warnings about signed/unsigned mismatches
Date: Mon, 27 May 2024 13:08:35 -0700

When building with clang, via:

    make LLVM=1 -C tools/testing/selftest

...clang warns about several cases of using a signed integer for the
priority argument to mq_receive(3), which expects an unsigned int.

Fix this by declaring the type as unsigned int in all cases.

Link: https://lkml.kernel.org/r/20240527200835.143682-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Valentin Obst <kernel@valentinobst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mqueue/mq_perf_tests.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mqueue/mq_perf_tests.c~selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches
+++ a/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -323,7 +323,8 @@ void *fake_cont_thread(void *arg)
 void *cont_thread(void *arg)
 {
 	char buff[MSG_SIZE];
-	int i, priority;
+	int i;
+	unsigned int priority;
 
 	for (i = 0; i < num_cpus_to_pin; i++)
 		if (cpu_threads[i] == pthread_self())
@@ -425,7 +426,8 @@ struct test test2[] = {
 void *perf_test_thread(void *arg)
 {
 	char buff[MSG_SIZE];
-	int prio_out, prio_in;
+	int prio_out;
+	unsigned int prio_in;
 	int i;
 	clockid_t clock;
 	pthread_t *t;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

