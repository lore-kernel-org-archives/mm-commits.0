Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D98918026
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628305; cv=none; b=o6IdTxSDlriahq9pBi9SraiVlUEYqZqYATXKDomGNUZjpBGIW3xRiTEJY5/LdYH+MOJDVkjHdgqqPJ/Q9jSKH+uMl1+LUaAHAw3zr2m3cnKDNUsJvJCzxdoz8GnihgkkZF9j6OI5FtJOKdjh5BTSyKIlwcXw+Gvvm98mkrCZe0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628305; c=relaxed/simple;
	bh=CRKSbcMXILfZ4YhLBTuZgzQ3F2glJpJr39IV9okHw+g=;
	h=Date:To:From:Subject:Message-Id; b=taoiGiFfVlzmbbD8rMTR805I0knWLZbqgrwkIPQPItGPx6L4eqfNlhxOsNmcbv6wr1wA0m0aOV1/tb7LYf253iIQtHtZJH7CqoneJKp0ZlHk9Fw5xSB+R8qjXzBYOrrEdYOaxANwAjz6NXGwghK/pspVEIQBPuQB7lZcxXpYeQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmP8WCW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmP8WCW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B6C116B1;
	Sat, 29 Jun 2024 02:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628305;
	bh=CRKSbcMXILfZ4YhLBTuZgzQ3F2glJpJr39IV9okHw+g=;
	h=Date:To:From:Subject:From;
	b=UmP8WCW6Nro7cLw2KCl42u/QAUe6KU6QPjYzVNkqqZV4jz0cN8HFyGXGW/330cCcp
	 R5EMeQTevdlnCjiUJf7ohPrNG1Jnz4JLc4wWcu8PfGutOe+0Jby+kkBl087q0Ka1CH
	 E0evLDgbgm2LuQ5X7q9YbSNEtdVvmuJmsVddy+nk=
Date: Fri, 28 Jun 2024 19:31:44 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-access_memory-use-user-defined-region-size.patch removed from -mm tree
Message-Id: <20240629023145.076B6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/access_memory: use user-defined region size
has been removed from the -mm tree.  Its filename was
     selftests-damon-access_memory-use-user-defined-region-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

