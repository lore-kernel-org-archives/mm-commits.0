Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F613DDAE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756820; cv=none; b=SeWmF7DRSOvupMPBi0QIY+s5dH0HaYuTDYcPWzVEqnhN1ZW1lfiTTEEc02zLhgbU3yXI9Gr9o1mLDhV/QvAoBPoSLBFdFPfj6MuGNlPHGXYgiAiCA6FNkKUg9RyKBg2KPX13CsNYT/nrj8kZikXSSCQp4bYGbO4J4E7oy9CdmfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756820; c=relaxed/simple;
	bh=B0XHfutyJUvZupge/YSkghumJot8uHKxG5dDENvya6U=;
	h=Date:To:From:Subject:Message-Id; b=gKMtjAiHjC+EzPaZpebPmv/2YglVuyyMefQztkdYmAQhPOs1TiHyfA89CdRY2znyq+HSc8yEr1MS0Oh+kStHIIEm4Md796iz7Z9WOE+sbNce1Nrhedk8l+ktWpADVUcQFU8Kn/Dl5icTWTUTLdq1EZwTgYwuoFE/Lrz95GQySVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XY3F+rmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XY3F+rmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8551C4CEED;
	Sun,  1 Jun 2025 05:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756819;
	bh=B0XHfutyJUvZupge/YSkghumJot8uHKxG5dDENvya6U=;
	h=Date:To:From:Subject:From;
	b=XY3F+rmkhCiLbjOEkv+TlyEalaKjOiMhmw4pseYvUWWVrWGKQhZwFyH2W5Ga/reHF
	 ZvnEiqPrc4A5hMEwMAXeFzmZPJ3pxr9xeTs7XghXnxgva+WwAyDUP143d4fZLNYKu4
	 WPZbRwoj1VJyRcWCsBj6uJiOcGYsyvOWiDaZ46rE=
Date: Sat, 31 May 2025 22:46:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch removed from -mm tree
Message-Id: <20250601054659.B8551C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: deduplicate test logging in test_mlock_lock()
has been removed from the -mm tree.  Its filename was
     selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


