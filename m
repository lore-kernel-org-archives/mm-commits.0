Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6794D259C9C
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 21:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772228078; cv=none; b=VKh4YUaQAZRoWrf6QClW570Cj3y6D7u6azXcZperiqF4zMf+ARqvE9vkZascqoJAUcoBSSYRwhna6bagxiyd0BoGvjaL8cd4SVt3mMCQ58FgUWa/h0sW0N0+p08rFfQK4lSP5VV3y8uE96WC7XGijsuWa8K37401J9hYuESUsWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772228078; c=relaxed/simple;
	bh=Eo3t6DuIeAWkqqbe6IXpjGKWXhxg6vT9OgiZz4vYQtU=;
	h=Date:To:From:Subject:Message-Id; b=TREl1SaLMNdGa5Oy0emgtgu28V+mkhG1+MCYudl4/9J9BCKfMv8cSkESOZMy1MaKJjfzOzb3L4hyGV1w2FTYuHnWW8i6LK8nZcxUSu3H7cUnH/QoSScPYP5B+WoJFhBb8V+vVoG4OjWzDx9ANTn43eY/X6tOlYv2vhBHv5EHQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OsCzxuki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OsCzxuki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFFC116C6;
	Fri, 27 Feb 2026 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772228078;
	bh=Eo3t6DuIeAWkqqbe6IXpjGKWXhxg6vT9OgiZz4vYQtU=;
	h=Date:To:From:Subject:From;
	b=OsCzxukiqwhdVobcByhXpmn2GH+3Z/kf3NSi676QAPzpLzmqCLB5AwI/YwcQzgsQB
	 xpEDwvd+/bAofpJhSf1wKkg2Wmpz85D22iRaZBhRWZ+G7LuksQ1pRWLgt96ab40BEU
	 AZAW7819FMZOQGrlkdTWJcMsqESOfIZh/RzSmBBM=
Date: Fri, 27 Feb 2026 13:34:37 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,brauner@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch added to mm-nonmm-unstable branch
Message-Id: <20260227213437.DFFFFC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/filesystems: assume that TIOCGPTPEER is defined
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/filesystems: assume that TIOCGPTPEER is defined
Date: Fri, 27 Feb 2026 15:20:35 +0000

The devpts_pts selftest has an ifdef in case an architecture does not
define TIOCGPTPEER, but the handling for this is broken since we need
errno to be set to EINVAL in order to skip the test as we should.  Given
that this ioctl() has been defined since v4.15 we may as well just assume
it's there rather than write handling code which will probably never get
used.

Link: https://lkml.kernel.org/r/20260227-selftests-filesystems-devpts-tiocgptpeer-v3-1-07db4d85d5aa@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/devpts_pts.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/filesystems/devpts_pts.c~selftests-filesystems-assume-that-tiocgptpeer-is-defined
+++ a/tools/testing/selftests/filesystems/devpts_pts.c
@@ -119,9 +119,7 @@ static int do_tiocgptpeer(char *ptmx, ch
 		goto do_cleanup;
 	}
 
-#ifdef TIOCGPTPEER
 	slave = ioctl(master, TIOCGPTPEER, O_RDWR | O_NOCTTY | O_CLOEXEC);
-#endif
 	if (slave < 0) {
 		if (errno == EINVAL) {
 			fprintf(stderr, "TIOCGPTPEER is not supported. "
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch

