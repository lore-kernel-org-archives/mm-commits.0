Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C8C74E26
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102846; cv=none; b=KS4Eir4TCTA+RO4H6zGOyL4e+I1jKedD7t0J7/NFSU8qpfADzDTyFxJivAO5Tt4oxo5mDCyIRjmMv/vqBCitnG+kgFY7nVdgJDQPIH/NHcHznFNMHodjg7CCuFswWU8JghmBrIm+DLKdj0xhft3yPiOGul3R7Nr17C34i84+JWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102846; c=relaxed/simple;
	bh=BZRqe3/UrRpwjt2Mj0eQN7gYtZvAgRi6/5UZvkFo/DQ=;
	h=Date:To:From:Subject:Message-Id; b=uI3obTAl6OfxJ4Dlm9wU9cTZheaN+chqNmoqedNd/cL/MM2MMPlzl73T3zFTjnf7FLGGLsfWfS6pIoJndM3+viRTWJ/tu9rzTvFIgBeeCwfr9CT5FCBoEWbudj5wzV026JwHYobC/N2aa/fTIWg7gNyo8NHJnpkT+N78A6LuEiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FwpW546X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FwpW546X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A21C113CD;
	Fri, 26 Apr 2024 03:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102845;
	bh=BZRqe3/UrRpwjt2Mj0eQN7gYtZvAgRi6/5UZvkFo/DQ=;
	h=Date:To:From:Subject:From;
	b=FwpW546X2/DwTHg0USzP0zgvOru9SxC1O9j98trpwC8CXDW9cMFikCp2sAgHIyheb
	 HQllIgLJraf8jqn31BGWlnOTjxIs4D06Uc9mwd9YF9NVYo5sEBLQLK9/olsiusv83Z
	 SBRtDzVsJZXwkOp1jVKZgQCBy/VDoDno15nl57QQ=
Date: Thu, 25 Apr 2024 20:40:45 -0700
To: mm-commits@vger.kernel.org,tujinjiang@huawei.com,shuah@kernel.org,david@redhat.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch removed from -mm tree
Message-Id: <20240426034045.A2A21C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix
has been removed from the -mm tree.  Its filename was
     selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch

This patch was dropped because it was folded into selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix
Date: Tue, 2 Apr 2024 09:15:37 +0100

There is a spelling mistake in a ksft_test_result_skip message. Fix it.

Link: https://lkml.kernel.org/r/20240402081537.1365939-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -502,7 +502,7 @@ static void test_child_ksm_err(int statu
 	else if (status == -2)
 		ksft_test_result_fail("Merge in child failed\n");
 	else if (status == -3)
-		ksft_test_result_skip("Merge in child skiped\n");
+		ksft_test_result_skip("Merge in child skipped\n");
 }
 
 /* Verify that prctl ksm flag is inherited. */
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch
ocfs2-remove-redundant-assignment-to-variable-status.patch

