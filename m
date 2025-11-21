Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70A287265
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742797; cv=none; b=HKJuaoJmx9QLurRVusL4S4XOocPDewI4VlmKzcTLFFEUJwrp7qkyS92B5iN4mqb5rvuy/eLkXB+MR4IJvSzwG6VyN+LmBGzTSx+iBzI8+OLfrIl9nRAgstGVpt2hrgLftQHDCG7UTnlI148O4eUubqOPzi689tW8S1iHZZhrHsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742797; c=relaxed/simple;
	bh=HV7WKoOx3wUHgz50jN02tCynDOki68HSh6C6tmZAvLw=;
	h=Date:To:From:Subject:Message-Id; b=nS2QhNOQn+hb7Ob8ptfkhL2ALwLcjuR3y8IscuFslSnjRCYvgkVBt8AKTPF7ovsTreYWveC+ra1eTu7Pi8jW+tYJYSDRT/8bKOBrQ5ozjf+3IwxwE76ctZ+QMMyIG++ivYtemo3c89lUuIQMYO516X6wdCqs+hKI8ajNYpzn+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x4CbHf7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x4CbHf7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418C5C4CEF1;
	Fri, 21 Nov 2025 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763742797;
	bh=HV7WKoOx3wUHgz50jN02tCynDOki68HSh6C6tmZAvLw=;
	h=Date:To:From:Subject:From;
	b=x4CbHf7r2ix9b/jxdQ3Fja/HiDnOsNQ4ozQ/KC0Wh/ekREt0OHfUBiKA+FZmB1XYW
	 ONODdBbtI8yuYU7bZqDa4O1ipql6LXwy7SRlp+bj2U6PEaVyPFSTsdnEJ9NGTS3kBc
	 36p3uQ1b6HGS1KuIndi7PRG3ckq+GQFDowlcGf8A=
Date: Fri, 21 Nov 2025 08:33:16 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path.patch added to mm-new branch
Message-Id: <20251121163317.418C5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/sysfs-kunit: fix use after free on error path
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/damon/tests/sysfs-kunit: fix use after free on error path
Date: Fri, 21 Nov 2025 16:36:38 +0300

Re-order these frees to avoid dereferencing "sysfs_target" after it has
been freed.

Link: https://lkml.kernel.org/r/aSBq5uSPIqsqH8zO@stanley.mountain
Fixes: ee131696794c ("mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/sysfs-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/sysfs-kunit.h~mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path
+++ a/mm/damon/tests/sysfs-kunit.h
@@ -76,8 +76,8 @@ static void damon_sysfs_test_add_targets
 	if (!ctx) {
 		kfree(sysfs_targets->targets_arr);
 		kfree(sysfs_targets);
-		kfree(sysfs_target);
 		kfree(sysfs_target->regions);
+		kfree(sysfs_target);
 		kunit_skip(test, "ctx alloc fail");
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path.patch

