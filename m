Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6232CA9
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754159829; cv=none; b=RSBCvehFUT7fbfs/+akEty7XONi7Q5j24cy2cWXC8AVsqpIsu+l/wOylhh+8qaQKWoJjW+8rCRm/Vg3VxGSnEGa5VF5yUFyFzhp3sJtWha4W4DiAbd2i3EEPKr0lqyKHAz7ISfo3DC2RCbRPzpkHroCW81HrCq3FlLAP4PqRfHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754159829; c=relaxed/simple;
	bh=ZOaoX0ct1y9sjS05EpJxXHfKoSSaj6nOZv9arNrgIf0=;
	h=Date:To:From:Subject:Message-Id; b=LVRli3ZfD08+g0yxEfRc7jRcj2qe8AtIkF/sxwGsoXE0b0n86czMnxW2PhXOVUtOUI92Bk5h5bezYnM+LOHPoPhsflZFiC7yCeGN4MTFiMoOUzTxIQ5wQz/C4z4vRHhYTu5blRhwsy0s35epMh1Im1syVGCfyvDkpQJm2CTzGT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tNenS/DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tNenS/DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8ECC4CEEF;
	Sat,  2 Aug 2025 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754159828;
	bh=ZOaoX0ct1y9sjS05EpJxXHfKoSSaj6nOZv9arNrgIf0=;
	h=Date:To:From:Subject:From;
	b=tNenS/DSTa+eb0KQs/+8YystYihjVMAY5Fi+kNGTluDx8prRlfqz8mJpII8pE18t8
	 JfPj6/anMK8fAbgrjurR6l1EtVPx1qdr7dny5EKJAi8z2Gl3fNUXDlpszVsHbDSf57
	 HndrfO4tldSzNvmzNe0kye2IJLbPoybnJ06JgHWE=
Date: Sat, 02 Aug 2025 11:37:07 -0700
To: mm-commits@vger.kernel.org,suresh.k.chandrappa@gmail.com,shuah@kernel.org,nphamcs@gmail.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20250802183708.9C8ECC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch

This patch was dropped because it was folded into selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch

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

selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch
mm-remove-mm-io-mappingc-fix.patch
init-kconfig-restore-config_broken-help-text.patch

