Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE626A0FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 22:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753223049; cv=none; b=HZkaHax4shvSSbHxeTFjJfDFmqQKnqIhABghGWQC4uuouZ9DMvMXaP3Qr2sLxO+6lb8Zq0pzZBE5GyXkbwJL9Q7Q30+v46dN/QcXVf+hmsVK4zVIvCzPYRgEPyDwK0d5DHRHCWlXhRdv7sOzzorw5FsxgL0bCHb8ogDrZQQFzVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753223049; c=relaxed/simple;
	bh=/P2xgV+9xBm5uSBxJrzABH7FuCDRWGfdy7TfX0sRA7c=;
	h=Date:To:From:Subject:Message-Id; b=otISphCOwO5Rc8QAFm6Ebe3k3PhmhkDgFNfxQ9Bw6pjh46kNbbw+AL9UimQfHsl0x68UVDR8KegMz2eLB7MI92Es12qdtnohEJQ8Xx2aIeozXPLNq+6/vhjz0zOBb0pwDHaLucSfYwm3T8FLKUBhB6NLv7L6VoAdvzhpJJSOKok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g0bILZGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g0bILZGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8278C4CEEB;
	Tue, 22 Jul 2025 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753223048;
	bh=/P2xgV+9xBm5uSBxJrzABH7FuCDRWGfdy7TfX0sRA7c=;
	h=Date:To:From:Subject:From;
	b=g0bILZGx3Y3o/P2GDPC9mClgmHTDRfbBv35tXhfBpDdqmDGuMsEm8HORFcE6SN+wq
	 Bq6ToEF4vzA/URXm04wXTEvO5d0yBvdl+QgrdwT1Lr0p3Sftv2143zghrudOwaZKIC
	 r1XQICQ0WRGGVWECN2lMpDvNzCw3enfIZNR+ykjI=
Date: Tue, 22 Jul 2025 15:24:08 -0700
To: mm-commits@vger.kernel.org,suresh.k.chandrappa@gmail.com,shuah@kernel.org,nphamcs@gmail.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20250722222408.A8278C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes
Date: Tue Jul 22 03:21:42 PM PDT 2025

ERROR: "foo* bar" should be "foo *bar"
#41: FILE: tools/testing/selftests/cachestat/test_cachestat.c:209:
+const char* file_type_str(enum file_type type) {

ERROR: open brace '{' following function definitions go on the next line
#41: FILE: tools/testing/selftests/cachestat/test_cachestat.c:209:
+const char* file_type_str(enum file_type type) {

ERROR: switch and case should be at the same indent
#42: FILE: tools/testing/selftests/cachestat/test_cachestat.c:210:
+	switch (type) {
+		case FILE_SHMEM:
[...]
+		case FILE_MMAP:
[...]
+		default:

ERROR: space required after that ',' (ctx:VxV)
#72: FILE: tools/testing/selftests/cachestat/test_cachestat.c:239:
+		ksft_print_msg("Unable to create %s file.\n",file_type_str(type));
 		                                            ^

ERROR: space required after that ',' (ctx:VxV)
#79: FILE: tools/testing/selftests/cachestat/test_cachestat.c:245:
+		ksft_print_msg("Unable to truncate %s file.\n",file_type_str(type));
 		                                              ^

ERROR: switch and case should be at the same indent
#88: FILE: tools/testing/selftests/cachestat/test_cachestat.c:249:
+	switch (type){
+		case FILE_SHMEM:
[...]
+		case FILE_MMAP:
[...]
+		default:

ERROR: space required before the open brace '{'
#88: FILE: tools/testing/selftests/cachestat/test_cachestat.c:249:
+	switch (type){

WARNING: Missing a blank line after declarations
#98: FILE: tools/testing/selftests/cachestat/test_cachestat.c:259:
+			char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+			if (map == MAP_FAILED) {

WARNING: braces {} are not necessary for single statement blocks
#103: FILE: tools/testing/selftests/cachestat/test_cachestat.c:264:
+			for (int i = 0; i < filesize; i++) {
+				map[i] = 'A';
+			}

WARNING: break is not useful after a goto
#111: FILE: tools/testing/selftests/cachestat/test_cachestat.c:272:
+			goto close_fd;
+			break;

total: 7 errors, 3 warnings, 108 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suresh K C <suresh.k.chandrappa@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |   62 +++++------
 1 file changed, 32 insertions(+), 30 deletions(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -206,14 +206,15 @@ out1:
 out:
 	return ret;
 }
-const char* file_type_str(enum file_type type) {
+const char *file_type_str(enum file_type type)
+{
 	switch (type) {
-		case FILE_SHMEM:
-			return "shmem";
-		case FILE_MMAP:
-			return "mmap";
-		default:
-			return "unknown";
+	case FILE_SHMEM:
+		return "shmem";
+	case FILE_MMAP:
+		return "mmap";
+	default:
+		return "unknown";
 	}
 }
 
@@ -236,7 +237,8 @@ bool run_cachestat_test(enum file_type t
 		fd = open(filename, O_RDWR | O_CREAT | O_TRUNC, 0666);
 
 	if (fd < 0) {
-		ksft_print_msg("Unable to create %s file.\n",file_type_str(type));
+		ksft_print_msg("Unable to create %s file.\n",
+				file_type_str(type));
 		ret = false;
 		goto out;
 	}
@@ -246,30 +248,30 @@ bool run_cachestat_test(enum file_type t
 		ret = false;
 		goto close_fd;
 	}
-	switch (type){
-		case FILE_SHMEM:
-			if (!write_exactly(fd, filesize)) {
-				ksft_print_msg("Unable to write to file.\n");
-				ret = false;
-				goto close_fd;
-			}
-			break;
-		case FILE_MMAP:
-			char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-			if (map == MAP_FAILED) {
-				ksft_print_msg("mmap failed.\n");
-				ret = false;
-				goto close_fd;
-			}
-			for (int i = 0; i < filesize; i++) {
-				map[i] = 'A';
-			}
-			break;
-		default:
-			ksft_print_msg("Unsupported file type.\n");
+	switch (type) {
+	case FILE_SHMEM:
+		if (!write_exactly(fd, filesize)) {
+			ksft_print_msg("Unable to write to file.\n");
 			ret = false;
 			goto close_fd;
-			break;
+		}
+		break;
+	case FILE_MMAP:
+		char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
+				 MAP_SHARED, fd, 0);
+
+		if (map == MAP_FAILED) {
+			ksft_print_msg("mmap failed.\n");
+			ret = false;
+			goto close_fd;
+		}
+		for (int i = 0; i < filesize; i++)
+			map[i] = 'A';
+		break;
+	default:
+		ksft_print_msg("Unsupported file type.\n");
+		ret = false;
+		goto close_fd;
 	}
 	syscall_ret = syscall(__NR_cachestat, fd, &cs_range, &cs, 0);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch
selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch
init-kconfig-restore-config_broken-help-text.patch

