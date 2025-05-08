Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCFD219A72;
	Thu,  8 May 2025 06:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686451; cv=none; b=eqO/8GWnC6G6R1d50BOQULFsB2xM3BV2AWk3Y2o+cbxO1c0xpxtqpjPQrIXC+O+NoQ4I64gJt2AdDPbwMXo8zRlIiUa6Hi8YakZ87XDOiNEFIekKYzOiNekDakV9SkaA1kp/m8yZfC0r/R6JJ4AlE/VToZCYwBp1jhTnt9V569Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686451; c=relaxed/simple;
	bh=JF41+ZUWpLBZXM8P/468uhHm+jXa4jRdv+/46rLWPf0=;
	h=Date:To:From:Subject:Message-Id; b=kvVYPRQo+QTD/aLyjJ9OXDqpZ43s8M1HqQ4CvFTwSE1g/B58VgJwEo4gwzL9KcvB4AuPwlFjT4iCDDLuT5u5sa4cmvW62kmq8yB7Eoivh0kIPg3EmCqJhgfzpp/etnOFnOaYQOq+TKAOPFBUrTnkjV2Fk1rxNx3sumuDfMWcp64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wMsHi55u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wMsHi55u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707A4C4CEF3;
	Thu,  8 May 2025 06:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686451;
	bh=JF41+ZUWpLBZXM8P/468uhHm+jXa4jRdv+/46rLWPf0=;
	h=Date:To:From:Subject:From;
	b=wMsHi55uy4KBuon3cKeYSZCsMTwucX+n6qmls7Jme8w/wf3pam2/+O8U56Ir7a7vl
	 F+n/q8wosOvxjmSg0pDXvKZLYexCGmF+nZa0yDGk/STj/N/IZJFOjrGHLE3DmKv1gy
	 RevI+smS3Fv71yevLY48KJ/Hk4qrSbxKIiT0Yjgo=
Date: Wed, 07 May 2025 23:40:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjayaram@akamai.com,shuah@kernel.org,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baolin.wang@inux.alibaba.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory.patch removed from -mm tree
Message-Id: <20250508064051.707A4C4CEF3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: compaction_test: support platform with huge mount of memory
has been removed from the -mm tree.  Its filename was
     selftests-mm-compaction_test-support-platform-with-huge-mount-of-memory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@inux.alibaba.com>
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


