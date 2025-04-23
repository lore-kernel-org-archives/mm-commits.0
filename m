Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4AF1FC7D2;
	Wed, 23 Apr 2025 21:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745445187; cv=none; b=VgE3eo2udSW2BQJjVbG3fkYFWsrvP7L20BZtF6erJY+WbG9UPS2MX5cwi9lo0cyqGDjJH0XvNbtb1GUoVIv515pFlGIk6bvCan5jYu/bJ2bBt+ICsDnou6wF38caJoQVzjuWWnPohlidNPhEaso3+7rvhoQeqJYW1tFeOw/drX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745445187; c=relaxed/simple;
	bh=OZravTJspm302dQGfjFXDHp0urDyZwGSfB6/zSH4I/c=;
	h=Date:To:From:Subject:Message-Id; b=U1OZXKDJ5jVD5Jf9eYHl21HQ9G0ErBKw/I30ppQTsK4/3Eqe57xXEsWyoxel1FsuZ2L3ji+LuTG5e9xJgdD2LVf7sceVoA4fVSS99mCY5N5nuPecGdFHb0lcO3xR+V1fb0oI2U5AqNTWCaLShSFft2Ni6hM03zb+pBGgEDTpyrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8jkB8Uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8jkB8Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1042C4CEE2;
	Wed, 23 Apr 2025 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745445187;
	bh=OZravTJspm302dQGfjFXDHp0urDyZwGSfB6/zSH4I/c=;
	h=Date:To:From:Subject:From;
	b=M8jkB8UjEiw/UJEjrD2wne5a08KjZrdIwcjYo4Rg7gb9/Qx0T1zrzXSwKRSJDWVda
	 eNBUMEgg8X91btbXVWDqZ8FiJTRBnJ7Mnjbf9EyxNHfI7CxlVXHyAbUsX5B0WUuhkt
	 fL+vT0b8fiMV1/nYPfu9B5mo33AbPQy5DMJY/Jks=
Date: Wed, 23 Apr 2025 14:53:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjayaram@akamai.com,shuah@kernel.org,dev.jain@arm.com,baolin.wang@linux.alibaba.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20250423215306.E1042C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: compaction_test: support platform with huge mount of memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory.patch

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
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: selftests/mm: compaction_test: support platform with huge mount of memory
Date: Wed, 23 Apr 2025 18:36:45 +0800

When running mm selftest to verify mm patches, 'compaction_test' case
failed on an x86 server with 1TB memory.  And the root cause is that it
has too much free memory than what the test supports.

The test case tries to allocate 100000 huge pages, which is about 200 GB
for that x86 server, and when it succeeds, it expects it's large than 1/3
of 80% of the free memory in system.  This logic only works for platform
with 750 GB ( 200 / (1/3) / 80% ) or less free memory, and may raise false
alarm for others.

Fix it by changing the fixed page number to self-adjustable number
according to the real number of free memory.

Link: https://lkml.kernel.org/r/20250423103645.2758-1-feng.tang@linux.alibaba.com
Fixes: bd67d5c15cc19 ("Test compaction of mlocked memory")
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   19 ++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -90,6 +90,8 @@ int check_compaction(unsigned long mem_f
 	int compaction_index = 0;
 	char nr_hugepages[20] = {0};
 	char init_nr_hugepages[24] = {0};
+	char target_nr_hugepages[24] = {0};
+	int slen;
 
 	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
 		 "%lu", initial_nr_hugepages);
@@ -106,11 +108,18 @@ int check_compaction(unsigned long mem_f
 		goto out;
 	}
 
-	/* Request a large number of huge pages. The Kernel will allocate
-	   as much as it can */
-	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
-		ksft_print_msg("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
+	/*
+	 * Request huge pages for about half of the free memory. The Kernel
+	 * will allocate as much as it can, and we expect it will get at least 1/3
+	 */
+	nr_hugepages_ul = mem_free / hugepage_size / 2;
+	snprintf(target_nr_hugepages, sizeof(target_nr_hugepages),
+		 "%lu", nr_hugepages_ul);
+
+	slen = strlen(target_nr_hugepages);
+	if (write(fd, target_nr_hugepages, slen) != slen) {
+		ksft_print_msg("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
+			       nr_hugepages_ul, strerror(errno));
 		goto close_fd;
 	}
 
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory.patch

