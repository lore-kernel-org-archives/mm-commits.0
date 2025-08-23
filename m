Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F8F393DEA
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755968938; cv=none; b=FlDdfwqFptaXpLv1/i9To2x4Dr66a03e1KsSAnCtR3qieo9N6e5K6LE7nqYRO/L8kZ/KWUpyeoX2z13GPJohr4UXtTlE/4nB6km21iNa0aydeMjUBsnznKVX+abxPEq5VKogKeek/UEdZjOU41diUb6JHwB0HWBLoYYIN1l68bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755968938; c=relaxed/simple;
	bh=4D/I/D6kXUMFxH+d3KbD4xFj0M0VlvIp5ryH/wHFLCc=;
	h=Date:To:From:Subject:Message-Id; b=gfRpCfXntiwuVXjkElGJwUEO0VCFSv/8ir5d8SKHiMTqrdD63fD6ttumvAhkfXjlBUkNhe8hzzeq1ENR2wfCywz9Vdo3+od41wztZfoxEA8ftkM4poSu+zQwz8Bs9J/kVGQJAjG4uMspD1Lno42cMnPAPlrfAJ+v9Eq39EeJ1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mRlDmthI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mRlDmthI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B06C4CEE7;
	Sat, 23 Aug 2025 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755968937;
	bh=4D/I/D6kXUMFxH+d3KbD4xFj0M0VlvIp5ryH/wHFLCc=;
	h=Date:To:From:Subject:From;
	b=mRlDmthIwDBrgT7ZgjTdBfSahrfHfynSDBjlKDRJILWyobND3EOClpkHQiiEt0QtT
	 CDFprzqnUx9Tt6hcnKifoxc876ZDB1PiF5UQFelnWcqgTnhb+XI9e0m81WkovkdY4C
	 xpqo2laVTGAjOKUyYpjjFS3zvopRs493DfyENlmE=
Date: Sat, 23 Aug 2025 10:08:56 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,allyheev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-fix-typos-in-test_vmallocsh.patch added to mm-unstable branch
Message-Id: <20250823170857.69B06C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: fix typos in test_vmalloc.sh
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-mm-fix-typos-in-test_vmallocsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-fix-typos-in-test_vmallocsh.patch

This patch will later appear in the mm-unstable branch at
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
From: ally heev <allyheev@gmail.com>
Subject: kselftest: mm: fix typos in test_vmalloc.sh
Date: Sat, 23 Aug 2025 22:32:08 +0530

Link: https://lkml.kernel.org/r/20250823170208.184149-1-allyheev@gmail.com
Signed-off-by: ally heev <allyheev@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/test_vmalloc.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/test_vmalloc.sh~kselftest-mm-fix-typos-in-test_vmallocsh
+++ a/tools/testing/selftests/mm/test_vmalloc.sh
@@ -47,14 +47,14 @@ check_test_requirements()
 	fi
 }
 
-run_perfformance_check()
+run_performance_check()
 {
 	echo "Run performance tests to evaluate how fast vmalloc allocation is."
 	echo "It runs all test cases on one single CPU with sequential order."
 
 	modprobe $DRIVER $PERF_PARAM > /dev/null 2>&1
 	echo "Done."
-	echo "Ccheck the kernel message buffer to see the summary."
+	echo "Check the kernel message buffer to see the summary."
 }
 
 run_stability_check()
@@ -160,7 +160,7 @@ function run_test()
 		usage
 	else
 		if [[ "$1" = "performance" ]]; then
-			run_perfformance_check
+			run_performance_check
 		elif [[ "$1" = "stress" ]]; then
 			run_stability_check
 		elif [[ "$1" = "smoke" ]]; then
_

Patches currently in -mm which might be from allyheev@gmail.com are

kselftest-mm-fix-typos-in-test_vmallocsh.patch

