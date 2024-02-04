Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C067D8F5C
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031251; cv=none; b=TEUa+3uNYuBaN6Byh3Fn/ZILR4h7WyM0pJiYVBWXJUhuSNaaxTFQvgpALDRZ4kHSP0NwNQeMOVPVD8sw2xHwlS+Wku9y8nLvbaGPjaHgMsxvsQqAmA7z21TULmGNWrzcDFtPp1mcdgW3AGUPJZ1WVJqFsTNUAR09JXhXgwA4sdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031251; c=relaxed/simple;
	bh=AItFQHDabG1pJvKRjRXT3q9LhgNxbhYb6mvG+NWpYP4=;
	h=Date:To:From:Subject:Message-Id; b=oZ6XSNJCpqFkpbtGOfMVtity0jcXp9Lv1A1jmLeaXOpuqXM7wpQZBqlltuo7udA8JzE214lIJ0mnq3rUkVYsqYYbvLWILcwlaZdnaa4LyGBB9XE0rl0duenM0BG5wkH5Cyck49HmjWz9Og/LqX8Am/FMq88B4+9TWdln6URe0XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uw7P+2b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uw7P+2b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89683C43394;
	Sun,  4 Feb 2024 07:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031251;
	bh=AItFQHDabG1pJvKRjRXT3q9LhgNxbhYb6mvG+NWpYP4=;
	h=Date:To:From:Subject:From;
	b=Uw7P+2b4ycnASL1rlXf49eE7+lIS4CxmHIJw/MmBKTfhBss2NiOlD3Xbg32sUsBrk
	 9WzyqSBCxZ/Q5u1Pc0oiqra1sAIJNbiZSnAqBVuqndLHwNOlWN2cLjRpsM7UM4MzdZ
	 pZENGXWp41NRgDI2NCxn441VrpvtT5RqH+OB5vv0=
Date: Sat, 03 Feb 2024 23:20:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-map_populate-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240204072051.89683C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: map_populate: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-map_populate-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-map_populate-conform-test-to-tap-format-output.patch

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
Subject: selftests/mm: map_populate: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:10 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages. 
Minor cleanups have also been included.

Link: https://lkml.kernel.org/r/20240202113119.2047740-4-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_populate.c |   37 ++++++++++++--------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-map_populate-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -16,19 +16,21 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include "../kselftest.h"
 
 #define MMAP_SZ		4096
 
-#define BUG_ON(condition, description)					\
-	do {								\
-		if (condition) {					\
-			fprintf(stderr, "[FAIL]\t%s:%d\t%s:%s\n", __func__, \
-				__LINE__, (description), strerror(errno)); \
-			exit(1);					\
-		}							\
+#define BUG_ON(condition, description)						\
+	do {									\
+		if (condition)							\
+			ksft_exit_fail_msg("[FAIL]\t%s:%d\t%s:%s\n",		\
+					   __func__, __LINE__, (description),	\
+					   strerror(errno));			\
 	} while (0)
 
-static int parent_f(int sock, unsigned long *smap, int child)
+#define TESTS_IN_CHILD 2
+
+static void parent_f(int sock, unsigned long *smap, int child)
 {
 	int status, ret;
 
@@ -43,9 +45,10 @@ static int parent_f(int sock, unsigned l
 	BUG_ON(ret <= 0, "write(sock)");
 
 	waitpid(child, &status, 0);
-	BUG_ON(!WIFEXITED(status), "child in unexpected state");
 
-	return WEXITSTATUS(status);
+	/* The ksft macros don't keep counters between processes */
+	ksft_cnt.ksft_pass = WEXITSTATUS(status);
+	ksft_cnt.ksft_fail = TESTS_IN_CHILD - WEXITSTATUS(status);
 }
 
 static int child_f(int sock, unsigned long *smap, int fd)
@@ -64,10 +67,11 @@ static int child_f(int sock, unsigned lo
 	ret = read(sock, &buf, sizeof(int));
 	BUG_ON(ret <= 0, "read(sock)");
 
-	BUG_ON(*smap == 0x22222BAD, "MAP_POPULATE didn't COW private page");
-	BUG_ON(*smap != 0xdeadbabe, "mapping was corrupted");
+	ksft_test_result(*smap != 0x22222BAD, "MAP_POPULATE COW private page\n");
+	ksft_test_result(*smap == 0xdeadbabe, "The mapping state\n");
 
-	return 0;
+	/* The ksft macros don't keep counters between processes */
+	return ksft_cnt.ksft_pass;
 }
 
 int main(int argc, char **argv)
@@ -76,6 +80,9 @@ int main(int argc, char **argv)
 	FILE *ftmp;
 	unsigned long *smap;
 
+	ksft_print_header();
+	ksft_set_plan(TESTS_IN_CHILD);
+
 	ftmp = tmpfile();
 	BUG_ON(!ftmp, "tmpfile()");
 
@@ -101,7 +108,9 @@ int main(int argc, char **argv)
 		ret = close(sock[0]);
 		BUG_ON(ret, "close()");
 
-		return parent_f(sock[1], smap, child);
+		parent_f(sock[1], smap, child);
+
+		ksft_finished();
 	}
 
 	ret = close(sock[1]);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

