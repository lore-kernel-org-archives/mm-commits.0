Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBE21946AA
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715833; cv=none; b=Dqny4JI9OsuMlWOLR/Zcmako5JQhdAHUgNRKmcZd3kR51xu2jGPpfDiajVM7r7DxsINFNsN2RYRlIZQa0E5brTpXs0eeuL/5Altcsdvd5gvxD57tNcSPEOVk+Zp94LhHbLVwlifbG9WfBiK+CDBbAki737BM6HVjH8dz7VXHrg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715833; c=relaxed/simple;
	bh=SQaK2rzgMfz6jLJspzIGyu94bJKgIWVPJQJtVDu6VS8=;
	h=Date:To:From:Subject:Message-Id; b=cLmjywd/10NWAeM013QHjDdl6+bkTtJYHXDoEVih3OrKgkRJ+ohT6oh9U1Q8ffDHqQyV7PqZR9glT7j+zb29GoK83HqU0Go9QGkJ/0yKM8y9l6ooUdDqkmxiR7U7FzO3NiX0iA0gTB11WgzPlZ0HMtZlP+6STrdP4YRr54nOdwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EhFlZvLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EhFlZvLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450A2C4CEC7;
	Mon, 30 Sep 2024 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727715833;
	bh=SQaK2rzgMfz6jLJspzIGyu94bJKgIWVPJQJtVDu6VS8=;
	h=Date:To:From:Subject:From;
	b=EhFlZvLwSACH99GvgSKQrNYUw/5SmvJtBT4QopnhlGPvtYdVGyNYSU5sPJR6kxPP2
	 mXjwBAV+iRokVuRyCHZDRkCERp1MrKrLxjnbqFESf2ViuDdUz0C8GdGXs2Fyc84tE6
	 EWLkwav8WJBvpmLJO5/BIHVr76y2iEyy5CwdjfRM=
Date: Mon, 30 Sep 2024 10:03:52 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,bajing@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-access_memory_even-remove-unused-variables.patch added to mm-unstable branch
Message-Id: <20240930170353.450A2C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/access_memory_even: remove unused variables
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-access_memory_even-remove-unused-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-access_memory_even-remove-unused-variables.patch

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
From: Ba Jing <bajing@cmss.chinamobile.com>
Subject: selftests/damon/access_memory_even: remove unused variables
Date: Tue, 24 Sep 2024 10:14:26 +0800

By reading the code, I found these variables are never referenced in the
code.  Just remove them.

Link: https://lkml.kernel.org/r/20240924021426.1980-1-bajing@cmss.chinamobile.com
Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/access_memory_even.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/damon/access_memory_even.c~selftests-damon-access_memory_even-remove-unused-variables
+++ a/tools/testing/selftests/damon/access_memory_even.c
@@ -14,10 +14,8 @@
 int main(int argc, char *argv[])
 {
 	char **regions;
-	clock_t start_clock;
 	int nr_regions;
 	int sz_region;
-	int access_time_ms;
 	int i;
 
 	if (argc != 3) {
_

Patches currently in -mm which might be from bajing@cmss.chinamobile.com are

selftests-damon-access_memory_even-remove-unused-variables.patch

