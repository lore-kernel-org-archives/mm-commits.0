Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C617C23D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342482; cv=none; b=GpDsH7Mqw8gwefnndQhEa1/zalwq3mkThtz4ryVLab/3QPBC5m9o2/3DmeDRj9lmIdFpC0uk9P3z5HZiIv+uW4w4iMgYVeediYTNx1DKzK0qfQaeiCrWFrrZ1bIA8reM9ttpYWyXUH0/9zHwqZA8davhpY3BlNMjiLq5yvadbtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342482; c=relaxed/simple;
	bh=DIhCTzqxZbpGNXwBrC+vSh97viUCcux/A1y1v0Bsb5o=;
	h=Date:To:From:Subject:Message-Id; b=boeVGuJzKMv6bbr8FV69eLDoNMH3X1qDTDTO2trtNmVEWMFmpgkkOs3YIQlxXvCGIH8DJAha9D8c1ZJXHWwIcc4rQUY/jgX8goLagHPKFaCoeY9q/0RTIhRZvTSyVQ9HlGxLADpXYiacnNigydwGWF3NvdBDJOI1HbVv2OcQCPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tERp5IIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tERp5IIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E387EC32781;
	Tue, 25 Jun 2024 19:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342482;
	bh=DIhCTzqxZbpGNXwBrC+vSh97viUCcux/A1y1v0Bsb5o=;
	h=Date:To:From:Subject:From;
	b=tERp5IIS5MeR2hbsheMR0IwTlcvGBckVx75DEWULddvAsH+jmTQSZIoYAV2o/OQOI
	 l2weKn9e5p2BTwj57XzJZrr+XcDd2HVM/3u6079I4WcJARfVeU2dOrVqSXlah48tGx
	 nS242Ikxdju5687YlfYKPfmWpS+sujRemu8ujY24=
Date: Tue, 25 Jun 2024 12:08:01 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-access_memory-use-user-defined-region-size.patch added to mm-unstable branch
Message-Id: <20240625190801.E387EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/access_memory: use user-defined region size
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-access_memory-use-user-defined-region-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-access_memory-use-user-defined-region-size.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/access_memory: use user-defined region size
Date: Tue, 25 Jun 2024 11:05:31 -0700

Patch series "selftests/damon: test DAMOS tried regions and
{min,max}_nr_regions".

This patch series fix a minor issue in a program for DAMON selftest, and
implement new functionality selftests for DAMOS tried regions and
{min,max}_nr_regions.  The test for max_nr_regions also test the recovery
from online tuning-caused limit violation, which was fixed by a previous
patch [1] titled "mm/damon/core: merge regions aggressively when
max_nr_regions is unmet".

The first patch fixes a minor problem in the articial memory access
pattern generator for tests.  Following 3 patches (2-4) implement schemes
tried regions test.  Then a couple of patches (5-6) implementing static
setup based {min,max}_nr_regions functionality test follows.  Final two
patches (7-8) implement dynamic max_nr_regions update test.

[1] https://lore.kernel.org/20240624210650.53960C2BBFC@smtp.kernel.org


This patch (of 8):

'access_memory' is an artificial memory access pattern generator for DAMON
tests.  It creates and accesses memory regions that the user specified the
number and size via the command line.  However, real access part of the
program ignores the user-specified size of each region.  Instead, it uses
a hard-coded value, 10 MiB.  Fix it to use user-defined size.

Note that all existing 'access_memory' users are setting the region size
as 10 MiB.  Hence no real problem has happened so far.

Link: https://lkml.kernel.org/r/20240625180538.73134-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240625180538.73134-2-sj@kernel.org
Fixes: b5906f5f7359 ("selftests/damon: add a test for update_schemes_tried_regions sysfs command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/access_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/access_memory.c~selftests-damon-access_memory-use-user-defined-region-size
+++ a/tools/testing/selftests/damon/access_memory.c
@@ -35,7 +35,7 @@ int main(int argc, char *argv[])
 		start_clock = clock();
 		while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC <
 				access_time_ms)
-			memset(regions[i], i, 1024 * 1024 * 10);
+			memset(regions[i], i, sz_region);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

