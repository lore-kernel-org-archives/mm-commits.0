Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3F2EBE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560213; cv=none; b=Tgktr852k61C/6I6p+7W1SuqknKNwNw2Pq6gQg2vB46AhVReAL8EjH8QYkx0xz7EHfoN1pU9WVe1aM86LhwvBhwO+/kfF4SHNJ5OX5FjjGzOTgI92XB/lq/5LehMKQz8Mt62zDyv9Q3qGPH3wMtpvvEOdaZr5fl0xQvY9rUiunQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560213; c=relaxed/simple;
	bh=a0xUVxRGkJizWfC6AjB2ce2+DJGo4OJVVBwL1OMY7T4=;
	h=Date:To:From:Subject:Message-Id; b=Os2CD4i/5dzKlBqQLFC7ILIXehDTMMWpdl/PdUUbBxYdmTikvX9QIn9+2K9DNwih6vJ56y3MtxclIF+jp4+JtpXjLx8MMacDDwRnl2cnES67xCq99af/1ZuPLIDO9OxdnjA63Tvuj5Q7079NMSMpwxlvZAtlz+7Ayi2AEzBV8kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jv1B9ywj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jv1B9ywj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A487C433C7;
	Thu, 22 Feb 2024 00:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560213;
	bh=a0xUVxRGkJizWfC6AjB2ce2+DJGo4OJVVBwL1OMY7T4=;
	h=Date:To:From:Subject:From;
	b=Jv1B9ywjEJPM0zw7/kLKBPZKd+xwkuYS5vXsWHuTj/3I8IqHKtdnigKx43SFY+K88
	 X9oh0LCmnF/hzhBTC9WA94OibGz1u7ebPeyR+XsmFH25d5BuGR88Y5WBJY1ivNKDjo
	 T8vRmhZud/jDBZ1hVR2sUwAD7SpQZurdKMG3sesQ=
Date: Wed, 21 Feb 2024 16:03:33 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-log-skipped-compaction-test-as-a-skip.patch removed from -mm tree
Message-Id: <20240222000333.9A487C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: log skipped compaction test as a skip
has been removed from the -mm tree.  Its filename was
     selftests-mm-log-skipped-compaction-test-as-a-skip.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: log skipped compaction test as a skip
Date: Fri, 09 Feb 2024 14:30:03 +0000

Patch series "selftests/mm: Output cleanups for the compaction test".

A couple of small updates for the check_compaction selftest which make
it play more nicely with test automation systems.


This patch (of 2):

When the compaction test is run it checks to make sure that prerequistives
the test requires are available and skips the tests if not.  When this
happens we log the test as a pass rather than a skip, log as a skip so
that the distinction is clear and automation can see unexpected skips.

Link: https://lkml.kernel.org/r/20240209-kselftest-mm-cleanup-v1-0-a3c0386496b5@kernel.org
Link: https://lkml.kernel.org/r/20240209-kselftest-mm-cleanup-v1-1-a3c0386496b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-log-skipped-compaction-test-as-a-skip
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -174,7 +174,7 @@ int main(int argc, char **argv)
 	ksft_print_header();
 
 	if (prereq() || geteuid())
-		return ksft_exit_pass();
+		return ksft_exit_skip("Prerequisites unsatisfied\n");
 
 	ksft_set_plan(1);
 
_

Patches currently in -mm which might be from broonie@kernel.org are


