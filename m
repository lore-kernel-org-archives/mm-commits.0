Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBAB2DC783
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778642765; cv=none; b=Dequnm2LaJpWok41s7Fpery38G/cbHB3SOhyWHtbNnmNB0wJTo6lCbw59K2b5noEkQ09Xcrf4cwl6o07uU4kmpI/ETAgSfWEyvsD/5N2LMxnqeLin6mnzavWLBEmJqfI3vFllRQlQgmqWKhVwbEKBPZEbiAXpMd2giIXxfz25PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778642765; c=relaxed/simple;
	bh=iFold9YchIChzbUeBUb53yxVBJRPrL9yagZhzgAFiTs=;
	h=Date:To:From:Subject:Message-Id; b=JiwfM8wiNizKFd3j/OOW4XD3AarqB66LNyZ8Uuu9lom39CxYYnh3ZHKIHTcGp1LRY7dTuO4hnw3y0BMOwb7jzueh5S/KNM67XmVHm3W+EqucdOdk9op3dsf9l8Jnb4A3ZimBzUBlKLvTciiqqWMgAnJnfyGx1K+3AC2QyIf1Dlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J2W5AK2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J2W5AK2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E254BC2BCB0;
	Wed, 13 May 2026 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778642765;
	bh=iFold9YchIChzbUeBUb53yxVBJRPrL9yagZhzgAFiTs=;
	h=Date:To:From:Subject:From;
	b=J2W5AK2GBsBuSz/bGJqaZH5F4WVCzC3K51Dkl9oJ/m78idJ3kEKgOZ66sJUlMwKFT
	 S/+AZrfBitjZbfTfVtFN1bEFO+r8ueGTxEPJoZWT6T0q+qINp/EB5+6a4/kXc7bJzS
	 BD/9HL2afylCPl1Py3pGKp44QoS9ll45twLjeS44=
Date: Tue, 12 May 2026 20:26:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch added to mm-new branch
Message-Id: <20260513032604.E254BC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: ksm-functional-tests: fix partial write handling
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: selftests/mm: ksm-functional-tests: fix partial write handling
Date: Mon, 4 May 2026 13:43:13 +0530

Update write() checks to properly detect and handle partial writes.

Previously, the write() calls used <= 0 to detect failure.  This condition
is never true for partial writes (ret > 0 but ret < len), so partial
writes were silently treated as success.

Fix this by verifying that write() returns the full expected length and
treating any mismatch as failure.

Link: https://lore.kernel.org/20260504081638.683223-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   21 ++++++------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-ksm-functional-tests-fix-partial-write-handling
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -498,6 +498,7 @@ static void test_prctl_fork(void)
 static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 {
 	int ksm_fd;
+	size_t len;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -506,11 +507,13 @@ static int start_ksmd_and_set_frequency(
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
-		return -errno;
-
-	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
-		return -errno;
+	len = strlen(pages_to_scan);
+	if (write(pages_to_scan_fd, pages_to_scan, len) != len)
+		return -1;
+
+	len = strlen(sleep_ms);
+	if (write(sleep_millisecs_fd, sleep_ms, len) != len)
+		return -1;
 
 	return 0;
 }
@@ -526,11 +529,11 @@ static int stop_ksmd_and_restore_frequen
 	if (write(ksm_fd, "2", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, "100", 3) <= 0)
-		return -errno;
+	if (write(pages_to_scan_fd, "100", 3) != 3)
+		return -1;
 
-	if (write(sleep_millisecs_fd, "20", 2) <= 0)
-		return -errno;
+	if (write(sleep_millisecs_fd, "20", 2) != 2)
+		return -1;
 
 	return 0;
 }
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch
mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch
mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch
selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch

