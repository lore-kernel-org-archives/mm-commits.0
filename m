Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C1156F9
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zk+hKYzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BC9C433C8;
	Tue,  2 Jan 2024 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704219664;
	bh=LTBOmtRS/Z4SISXDd33jpeOV7SkWM3izsK3eUGPBtHU=;
	h=Date:To:From:Subject:From;
	b=zk+hKYzZ/qmTkNHID3Dr72myQm39U+e+h80EOYqa+aJZA0k0WXV5jXnP4GmTNsSJH
	 GX6LXCGBLySPLgJkoZ7jET/gTTV+AF9W3TopLI1deqH6Xk5D5IhnSI75ES/GIqSD2Z
	 +Hy4s/H/uxho4hf8hk4bnUrKo4EWgU5aREFoxa5s=
Date: Tue, 02 Jan 2024 10:21:03 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_test-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240102182104.30BC9C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: gup_test: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-gup_test-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_test-conform-test-to-tap-format-output.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: gup_test: conform test to TAP format output
Date: Tue, 2 Jan 2024 10:38:06 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240102053807.2114200-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c |   65 ++++++++++++------------
 1 file changed, 33 insertions(+), 32 deletions(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_test-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -50,39 +50,41 @@ static char *cmd_to_str(unsigned long cm
 void *gup_thread(void *data)
 {
 	struct gup_test gup = *(struct gup_test *)data;
-	int i;
+	int i, status;
 
 	/* Only report timing information on the *_BENCHMARK commands: */
 	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
 	     (cmd == PIN_LONGTERM_BENCHMARK)) {
 		for (i = 0; i < repeats; i++) {
 			gup.size = size;
-			if (ioctl(gup_fd, cmd, &gup))
-				perror("ioctl"), exit(1);
+			status = ioctl(gup_fd, cmd, &gup);
+			if (status)
+				break;
 
 			pthread_mutex_lock(&print_mutex);
-			printf("%s: Time: get:%lld put:%lld us",
-			       cmd_to_str(cmd), gup.get_delta_usec,
-			       gup.put_delta_usec);
+			ksft_print_msg("%s: Time: get:%lld put:%lld us",
+				       cmd_to_str(cmd), gup.get_delta_usec,
+				       gup.put_delta_usec);
 			if (gup.size != size)
-				printf(", truncated (size: %lld)", gup.size);
-			printf("\n");
+				ksft_print_msg(", truncated (size: %lld)", gup.size);
+			ksft_print_msg("\n");
 			pthread_mutex_unlock(&print_mutex);
 		}
 	} else {
 		gup.size = size;
-		if (ioctl(gup_fd, cmd, &gup)) {
-			perror("ioctl");
-			exit(1);
-		}
+		status = ioctl(gup_fd, cmd, &gup);
+		if (status)
+			goto return_;
 
 		pthread_mutex_lock(&print_mutex);
-		printf("%s: done\n", cmd_to_str(cmd));
+		ksft_print_msg("%s: done\n", cmd_to_str(cmd));
 		if (gup.size != size)
-			printf("Truncated (size: %lld)\n", gup.size);
+			ksft_print_msg("Truncated (size: %lld)\n", gup.size);
 		pthread_mutex_unlock(&print_mutex);
 	}
 
+return_:
+	ksft_test_result(!status, "ioctl status %d\n", status);
 	return NULL;
 }
 
@@ -170,7 +172,7 @@ int main(int argc, char **argv)
 			touch = 1;
 			break;
 		default:
-			return -1;
+			ksft_exit_fail_msg("Wrong argument\n");
 		}
 	}
 
@@ -198,11 +200,12 @@ int main(int argc, char **argv)
 		}
 	}
 
+	ksft_print_header();
+	ksft_set_plan(nthreads);
+
 	filed = open(file, O_RDWR|O_CREAT);
-	if (filed < 0) {
-		perror("open");
-		exit(filed);
-	}
+	if (filed < 0)
+		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
 
 	gup.nr_pages_per_call = nr_pages;
 	if (write)
@@ -213,27 +216,24 @@ int main(int argc, char **argv)
 		switch (errno) {
 		case EACCES:
 			if (getuid())
-				printf("Please run this test as root\n");
+				ksft_print_msg("Please run this test as root\n");
 			break;
 		case ENOENT:
-			if (opendir("/sys/kernel/debug") == NULL) {
-				printf("mount debugfs at /sys/kernel/debug\n");
-				break;
-			}
-			printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
+			if (opendir("/sys/kernel/debug") == NULL)
+				ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+			ksft_print_msg("check if CONFIG_GUP_TEST is enabled in kernel config\n");
 			break;
 		default:
-			perror("failed to open " GUP_TEST_FILE);
+			ksft_print_msg("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
 			break;
 		}
-		exit(KSFT_SKIP);
+		ksft_test_result_skip("Please run this test as root\n");
+		return ksft_exit_pass();
 	}
 
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (p == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 	gup.addr = (unsigned long)p;
 
 	if (thp == 1)
@@ -264,7 +264,8 @@ int main(int argc, char **argv)
 		ret = pthread_join(tid[i], NULL);
 		assert(ret == 0);
 	}
+
 	free(tid);
 
-	return 0;
+	return ksft_exit_pass();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

mm-selftests-hugepage-mremap-conform-test-to-tap-format-output.patch
selftests-mm-gup_test-conform-test-to-tap-format-output.patch

