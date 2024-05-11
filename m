Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B638200C7
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467655; cv=none; b=sWRyD6IzZoicYfROinLTLXm8RPiyxZXeH8AGPbaxpDyI1/0x8a2RtkJn3OvwshDerbNtroyHSGrefkvNpwtdilVPI40GMql1dfZJPzNMSfsZHYjM6uMO3UvHCuJmQYmUYMDjItWKnpPhcncwHGuARgx/FXGAQglICsmxv6opxa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467655; c=relaxed/simple;
	bh=1hQrXNtSwktv09P3aWm1u1VPh4fhXK285CBOXvyVFaA=;
	h=Date:To:From:Subject:Message-Id; b=lJxcMMVNywyKGb2sXYkFTnbtaGuiyuvdHOoBe1pUwmDTS+er70m6zfLE0OcDxnmCHz4A1C+PP5BkChqiJfADrFRX2GvKeOuJRUV/+n/jw8cEQtewKZuHD4ByWJ3xrvg8MuQpLefU4eC8cMfZH8jxBhxQQBuqTc7eLdnnA2QvISE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J8v6uROz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J8v6uROz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44203C2BBFC;
	Sat, 11 May 2024 22:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467655;
	bh=1hQrXNtSwktv09P3aWm1u1VPh4fhXK285CBOXvyVFaA=;
	h=Date:To:From:Subject:From;
	b=J8v6uROzTARn15JZFgS7YTAQDSy+9TTsNjbzzpgCJZgCiXOyaIXPowt52+RTvqFVF
	 KobL17k1+WG6qhoc1OwfcE+IWKokUJc48ylIX8gHM1TFNzN1jt+s+yA9EOy79bshAG
	 Lm2jD1mfLYImEwQDkCnJIwfLqcPhS6UrS+P7FJrQ=
Date: Sat, 11 May 2024 15:47:34 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,kernel@valentinobst.de,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch removed from -mm tree
Message-Id: <20240511224735.44203C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mqueue: fix 5 warnings about signed/unsigned mismatches
has been removed from the -mm tree.  Its filename was
     selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

This patch was dropped because an updated version will be merged

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
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
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


