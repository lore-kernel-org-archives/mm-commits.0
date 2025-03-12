Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5659282F1
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 22:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741819669; cv=none; b=cNsPX6NrhlFwZyRL+mPPckMt+5kECyWtwIa+Sde/uoR4/fzI8y/3Mea5yh0hqtQkKgrX5fH6vIYJVI30YAyOffBwD6JUisE0OoBBoGRPbJBHpK0Z5PSXy5BgnbhMTWenLYV7gHKUT9nRoH1MpYdLoBhAdwcgd6aFjMWEYw8JAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741819669; c=relaxed/simple;
	bh=NKlaiR7Mx2tim71MEgZEdDk6oGJVOIqDwRlecU3khLc=;
	h=Date:To:From:Subject:Message-Id; b=Br009Pbu/qNShJOqR3Jy5ai9jqH1oTUvXtilX7LnUjFe2KPvMw37nIte1XCtpoQ032NpP/UX5doBxYj1y8b6Su6B0dwB30t8MCQgVhDr4PGxNyGBxKlnB9pCt8P81NgWUAYMf2yb3NcsNxNjanrHW1yE2jwOLz1E0VS07swgP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwqRt6hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwqRt6hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D6CC4CEDD;
	Wed, 12 Mar 2025 22:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741819669;
	bh=NKlaiR7Mx2tim71MEgZEdDk6oGJVOIqDwRlecU3khLc=;
	h=Date:To:From:Subject:From;
	b=iwqRt6hj+dbsAZwX239MSebqsmk02CH36JYSjst0oSZSw6MnIBTi61tXisE+GEXK3
	 hKCQgpr+wQRemxpuS+h2TJ6TKGiaN1eh7DAFs8+AikgtgXYq6M56l/SvBeeZecDj4c
	 Z9l/u+m1AtcwxrsSTeaf7i/dD3kHHvA/WePnAAYM=
Date: Wed, 12 Mar 2025 15:47:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,david@redhat.com,cyan.yang@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-fix-the-incorrect-error-handling.patch added to mm-unstable branch
Message-Id: <20250312224749.23D6CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/cow: fix the incorrect error handling
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-fix-the-incorrect-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-fix-the-incorrect-error-handling.patch

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
From: Cyan Yang <cyan.yang@sifive.com>
Subject: selftests/mm/cow: fix the incorrect error handling
Date: Wed, 12 Mar 2025 12:38:40 +0800

Error handling doesn't check the correct return value.  This patch will
fix it.

Link: https://lkml.kernel.org/r/20250312043840.71799-1-cyan.yang@sifive.com
Fixes: f4b5fd6946e244cdedc3bbb9a1f24c8133b2077a ("selftests/vm: anon_cow: THP tests")
Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-fix-the-incorrect-error-handling
+++ a/tools/testing/selftests/mm/cow.c
@@ -876,7 +876,7 @@ static void do_run_with_thp(test_fn fn,
 		mremap_size = thpsize / 2;
 		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
 				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-		if (mem == MAP_FAILED) {
+		if (mremap_mem == MAP_FAILED) {
 			ksft_test_result_fail("mmap() failed\n");
 			goto munmap;
 		}
_

Patches currently in -mm which might be from cyan.yang@sifive.com are

selftests-mm-cow-fix-the-incorrect-error-handling.patch

