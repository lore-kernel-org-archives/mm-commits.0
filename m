Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFD633C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293191; cv=none; b=p0FRm4XrrcLIFTduRBxrPMkhv9gzsSMwgu7TOBhkx0J4LaHkTTAueoSwDsm2B0q0KKCov9LxzJnc/ipWDrhLwTovdx9M9fS6TYaOVjJ8DFZtWo6FZsqiyvQiXHHYhwOMZm5x4Fp8NwaYy1cuRfkNzUcQZi/IviJVhTm12qKX0is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293191; c=relaxed/simple;
	bh=T+Ib+wtKHoWbCsqAHcKjT8K3Z9PALt9s3T6LJ8hprkw=;
	h=Date:To:From:Subject:Message-Id; b=pjtrLNjsBjhjZaoLnk3a2V1FMRsdjMme9TsmvRHBl84R7Dnu4fFZ++SVQKme1sEmHWsSpT0jBi/PEJXPHzBiDrvHt/zzk1zBUsPEoGmSEfH/6Z0AVqaQPDswoj+CcszrCpc8irgEMdes7xTaQY6KBGZYcf4fmjiCoxaxSE9GN9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCp3zgXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCp3zgXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21934C32782;
	Tue, 25 Jun 2024 05:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293191;
	bh=T+Ib+wtKHoWbCsqAHcKjT8K3Z9PALt9s3T6LJ8hprkw=;
	h=Date:To:From:Subject:From;
	b=XCp3zgXxrDGaVsA34k+Qw9F1ScpfJAf3gWnNlIP7yQAzLnf7Ek6CnMre7FXlxtdbf
	 2xNVLEoWkILgwDvsgytpgBJi8hG5YXsQvPQ7n+CIhgWDIWGzNMZxUef/Qmnk23nIaO
	 Wo2v1+uS55Qbz3hwx06oDGjAUKGXIe3MmWiXwTxk=
Date: Mon, 24 Jun 2024 22:26:30 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,kernel@valentinobst.de,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch removed from -mm tree
Message-Id: <20240625052631.21934C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mqueue: fix 5 warnings about signed/unsigned mismatches
has been removed from the -mm tree.  Its filename was
     selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-remove-local-__nr_-definitions.patch

