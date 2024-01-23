Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A49954BD2;
	Tue, 23 Jan 2024 00:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970606; cv=none; b=Ca8+TMH3gnG01Lo8dYjzJRpjYiXfPOpHQneG6KTym0oPPiWzlJedlsb2GRl+0jiT3lgkWkNSwVfyNOW8F2131krEg11xOIIlDd2t/KRwmS9kvi80Su3a0CfXx4lfSQplgGV0HVdJ3wXjv1p+vFsL9qqVZKvSjbN3QVyOLCwh+48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970606; c=relaxed/simple;
	bh=DarTQDS2EqlDOvv1Kd8o0FMx/asimx2EljmyVNjzxaU=;
	h=Date:To:From:Subject:Message-Id; b=fuphgSqgR18FW1TxYP3rt61I+f05WaTV3pqHG4wGLmNbSpUaaXmNSqNfajx4ayLttluHyfNb3hviDMEQnX6sxr5svuu2w5pHAx2CtjLx3RF4jKz11n+iNox/G9vYRLllHnezZk6leMyTGXCUYAppOQcsR11C2C4DWSl8gw6CanI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYMbh/Sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYMbh/Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60651C433C7;
	Tue, 23 Jan 2024 00:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970605;
	bh=DarTQDS2EqlDOvv1Kd8o0FMx/asimx2EljmyVNjzxaU=;
	h=Date:To:From:Subject:From;
	b=EYMbh/SzXLpiYNfHAoB58NC4U+s/uKg457QeYgbBk7MVioI9kCCAcuMALnNMuEFYh
	 MQO+ZvoQSezLdKj4l2Ma09RXlvVM6bG+opOcngC5AhBNHY7tGSQfZEjRA9iTaGdo+l
	 vynaeIGLZn7kLuCXrpokRkLM0wpe4v7hRbTabYIA=
Date: Mon, 22 Jan 2024 16:43:22 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,pedrodemargomes@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004325.60651C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
Date: Mon, 22 Jan 2024 12:05:54 +0000

ksm_tests was previously mmapping a region of memory, aligning the
returned pointer to a PMD boundary, then setting MADV_HUGEPAGE, but was
setting it past the end of the mmapped area due to not taking the pointer
alignment into consideration.  Fix this behaviour.

Up until commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries"), this buggy behavior was (usually) masked because the
alignment difference was always less than PMD-size.  But since the
mentioned commit, `ksm_tests -H -s 100` started failing.

Link: https://lkml.kernel.org/r/20240122120554.3108022-1-ryan.roberts@arm.com
Fixes: 325254899684 ("selftests: vm: add KSM huge pages merging time test")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -566,7 +566,7 @@ static int ksm_merge_hugepages_time(int
 	if (map_ptr_orig == MAP_FAILED)
 		err(2, "initial mmap");
 
-	if (madvise(map_ptr, len + HPAGE_SIZE, MADV_HUGEPAGE))
+	if (madvise(map_ptr, len, MADV_HUGEPAGE))
 		err(2, "MADV_HUGEPAGE");
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch
tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch

