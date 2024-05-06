Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF42BAE5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 20:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715027700; cv=none; b=pbrRyDbhlFXtmTEQ7izWf7aty5l2v8GOCj5eKTUJsEl7o2ag6kFjsBkesKcglI5bbfBAb3XIoyP5NputFcVi1cq2QLNdKrzlmA80rJos34NSC4ROS8wG1U3QkVKuqLJUY2Wj58zKWYWOmlD2V4xbCkFyZ+UMAje/BoUwaWXWTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715027700; c=relaxed/simple;
	bh=iniAbJxWnCh+MM0sjmWDm/z7s2R2nGqrsK33VSFHJJY=;
	h=Date:To:From:Subject:Message-Id; b=YzVHPEo8lMwITm92RlrwtXPetZXT11FxH/D987nYytD2GgvxonbcALCqU3yG4iu/XLgQVQZchq4iOLE9cRa075UQexLE6vvF6kyNfYJhGgoCIjthkNfGPBwBoxm4H5/SD+3GhmlNGWlfj6C/4J5I7Tq2ktCslot9SkbWPcZLiJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Js6AFJ7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Js6AFJ7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9694DC116B1;
	Mon,  6 May 2024 20:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715027699;
	bh=iniAbJxWnCh+MM0sjmWDm/z7s2R2nGqrsK33VSFHJJY=;
	h=Date:To:From:Subject:From;
	b=Js6AFJ7jb2WM9lLOp0zcVINJKfLF4tSGRDhztSQFSi+ARX8i8dcU4Ch9WMZWSS6J+
	 fuLlLxT81RBff0t/ot6ZkP4wVHJLOLC/ZMXdXb99sZ1izhhlWgpxNbOT2XyxPhFK4M
	 2Fk8rYlvFb5aYhMbXBsQvXHO/PJ/v7uJSa3IkFL0=
Date: Mon, 06 May 2024 13:34:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,kernel@valentinobst.de,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch added to mm-nonmm-unstable branch
Message-Id: <20240506203459.9694DC116B1@smtp.kernel.org>
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
Date: Sun, 5 May 2024 15:13:59 -0700

When building with clang, via:

    make LLVM=1 -C tools/testing/selftest

...clang warns about several cases of using a signed integer for the
priority argument to mq_receive(3), which expects an unsigned int.

Fix this by declaring the type as unsigned int in all cases.

Link: https://lkml.kernel.org/r/20240505221359.65258-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
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

