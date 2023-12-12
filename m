Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C067F57B
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qPT1Yfn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A3FC433C7;
	Tue, 12 Dec 2023 18:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407567;
	bh=LACyUrajab+SFyI73vasNWyTP0LC8Y1GqZaK3ZrUSN4=;
	h=Date:To:From:Subject:From;
	b=qPT1Yfn8iGlMHcbBFNX0xkobb1sDEImc3WitJMGcPdjbWYzfopocNpD1R6u9XZeHo
	 whPV1srX2M4c2XUmAwgP2Qso8eCTM8kCig4i/2Ksf0/lk+GG1zgGKjbz7U/NpEyTe2
	 WxDNbEmDcuvFsYMxq5AgndbKqfDLdziJ7xqNyQYY=
Date: Tue, 12 Dec 2023 10:59:26 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,jsavitz@redhat.com,david@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-dont-run-ksm_functional_tests-twice.patch removed from -mm tree
Message-Id: <20231212185927.22A3FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: dont run ksm_functional_tests twice
has been removed from the -mm tree.  Its filename was
     selftests-mm-dont-run-ksm_functional_tests-twice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: dont run ksm_functional_tests twice
Date: Wed, 29 Nov 2023 15:11:40 -0700

ksm functional test is already being run.  Remove the duplicate call to
./ksm_functional_tests.

Link: https://lkml.kernel.org/r/20231129221140.614713-1-npache@redhat.com
Fixes: 93fb70aa5904 ("selftests/vm: add KSM unmerge tests")
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: Joel Savitz <jsavitz@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-dont-run-ksm_functional_tests-twice
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -334,8 +334,6 @@ CATEGORY="ksm_numa" run_test ./ksm_tests
 
 CATEGORY="ksm" run_test ./ksm_functional_tests
 
-run_test ./ksm_functional_tests
-
 # protection_keys tests
 if [ -x ./protection_keys_32 ]
 then
_

Patches currently in -mm which might be from npache@redhat.com are


