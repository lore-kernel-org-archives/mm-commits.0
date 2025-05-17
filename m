Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180C18F5B
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747494421; cv=none; b=Bag9zpi4Bf2R22LHknhssa7bf9PADPJ41GBpwgZkK7/wcTvW6nw72azoJnsn6AbMG8Kb6PCkfaikCqylqiLWWCH0d/X479kjee8C/FqGrPHanTW7ndbYvCMuyf9jWMrUbtjkPWZhvFcppyzHO0bTYUgdqq8z8TZxHVEUuYfhMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747494421; c=relaxed/simple;
	bh=LEM8iFANKlJ41vIOb6ejwKzaRC5jvG3WensAk1Wo63Q=;
	h=Date:To:From:Subject:Message-Id; b=foiPbb7E2ReVWOBZ5fxP64RafcrndyPnpqh72d8TBh2Kga+X3Q7ln09/fRNokeg25zjUOWcTj6m7Iz9We5XcxQcHAQECnDWgIVfF+OyGEhx9O0myaQIotFCGrNJXA+5FTV7ydT3LgOZF+6qUo+v3VZdJO4HP13noPEZJP9elVvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMB3vFUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMB3vFUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62173C4CEE3;
	Sat, 17 May 2025 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747494420;
	bh=LEM8iFANKlJ41vIOb6ejwKzaRC5jvG3WensAk1Wo63Q=;
	h=Date:To:From:Subject:From;
	b=HMB3vFUYzPfUjYaiAaPgpeltDpM8Ue2Ku8bOZAl7e1yeJm2ULc9NGI9hw6NCxP9c6
	 XMCE9rty2X4+yt/GFIJ6ywTS2ikhsJP1qoiUnt5tJa+QT3QBi5deOZq7NWXayQzyNC
	 yj+JRtR+y6AxKvvqqLNXZAzcofBWuk0NSEbP8XPM=
Date: Sat, 17 May 2025 08:06:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch added to mm-new branch
Message-Id: <20250517150700.62173C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: deduplicate test logging in test_mlock_lock()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: deduplicate test logging in test_mlock_lock()
Date: Thu, 15 May 2025 11:27:14 +0200

The mlock2-tests test_mlock_lock() test reports two test results with an
identical string, one reporitng if it successfully locked a block of
memory and another reporting if the lock is still present after doing an
unlock (following a similar pattern to other tests in the same program). 
This confuses test automation since the test string is used to deduplicate
tests, change the post unlock test to report "Unlocked" instead like the
other tests to fix this.

Link: https://lkml.kernel.org/r/20250515-selftest-mm-mlock2-dup-v1-1-963d5d7d243a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-deduplicate-test-logging-in-test_mlock_lock
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -196,7 +196,7 @@ static void test_mlock_lock(void)
 		ksft_exit_fail_msg("munlock(): %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: Locked\n", __func__);
+	ksft_test_result(!unlock_lock_check(map), "%s: Unlocked\n", __func__);
 	munmap(map, 2 * page_size);
 }
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch

