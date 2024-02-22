Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5ACFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645212; cv=none; b=Qy/ED2FAosskV+lQIV9sNloMaHoH9YEOcDRXhBUlFlfHvFe1uz2+7X0ka1G0LNu5wcj4vr+PHvlD3EjWjcEYmAK3cykLIHoVbTt87QkCzvBaOkkeEIXeghVlRWTb5xBwLeEnN42KMqOTKlQOhEkGAHSqz/3PjzuNUb0aBrbp87Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645212; c=relaxed/simple;
	bh=Acxi8kV/6qI+HrKnpw8yZmC/gBbd6yFsrY47UWofMM8=;
	h=Date:To:From:Subject:Message-Id; b=CJATBsgmba/0nlkBhMDkejKDA3etRMULdx2Z39+YmFAVHSZ6MdYjL+uqviKq7fXvZF3WOL+VLafrOBEbAoqweGiWyfvmqoILfnvjdEOtcRRtXwC837vzcqvH6w+iT75Hc2FNvE3XxMMp0MLwZIi2U9p32cXb3AFxsDdJi5yWkn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gBSBV4N6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gBSBV4N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31205C433C7;
	Thu, 22 Feb 2024 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645212;
	bh=Acxi8kV/6qI+HrKnpw8yZmC/gBbd6yFsrY47UWofMM8=;
	h=Date:To:From:Subject:From;
	b=gBSBV4N6sovnVa21bimQ319GeiQt/dWf96wuo7g94RsCMdTssTmD+6fauGU1VgtUg
	 EbwedccHRTDX61fM8gsV+lJyCj3w4I6amA67+YshhrvGoj/V1sm0v3cahj6IM9Dwpf
	 ws7deZGOLpfcCWRa7IKeWB1PV5r3KGhXIo+1nT0o=
Date: Thu, 22 Feb 2024 15:40:11 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch removed from -mm tree
Message-Id: <20240222234012.31205C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests: remove sudo and conform to tap
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: run_vmtests: remove sudo and conform to tap
Date: Thu, 25 Jan 2024 20:46:05 +0500

Remove sudo as some test running environments may not have sudo available.
Instead skip the test if root privileges aren't available in the test.

[usama.anjum@collabora.com: on-fault-limit: run test without root privileges otherwise skip]
  Link: https://lkml.kernel.org/r/20240201130538.1404897-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20240125154608.720072-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/on-fault-limit.c |   38 ++++++++----------
 tools/testing/selftests/mm/run_vmtests.sh   |    7 ++-
 2 files changed, 24 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/on-fault-limit.c~selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap
+++ a/tools/testing/selftests/mm/on-fault-limit.c
@@ -5,40 +5,38 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include "../kselftest.h"
 
-static int test_limit(void)
+static void test_limit(void)
 {
-	int ret = 1;
 	struct rlimit lims;
 	void *map;
 
-	if (getrlimit(RLIMIT_MEMLOCK, &lims)) {
-		perror("getrlimit");
-		return ret;
-	}
-
-	if (mlockall(MCL_ONFAULT | MCL_FUTURE)) {
-		perror("mlockall");
-		return ret;
-	}
+	if (getrlimit(RLIMIT_MEMLOCK, &lims))
+		ksft_exit_fail_msg("getrlimit: %s\n", strerror(errno));
+
+	if (mlockall(MCL_ONFAULT | MCL_FUTURE))
+		ksft_exit_fail_msg("mlockall: %s\n", strerror(errno));
 
 	map = mmap(NULL, 2 * lims.rlim_max, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+
+	ksft_test_result(map == MAP_FAILED, "The map failed respecting mlock limits\n");
+
 	if (map != MAP_FAILED)
-		printf("mmap should have failed, but didn't\n");
-	else {
-		ret = 0;
 		munmap(map, 2 * lims.rlim_max);
-	}
-
 	munlockall();
-	return ret;
 }
 
 int main(int argc, char **argv)
 {
-	int ret = 0;
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	if (!getuid())
+		ksft_test_result_skip("The test must be run from a normal user\n");
+	else
+		test_limit();
 
-	ret += test_limit();
-	return ret;
+	ksft_finished();
 }
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -291,7 +291,12 @@ echo "$nr_hugepgs" > /proc/sys/vm/nr_hug
 
 CATEGORY="compaction" run_test ./compaction_test
 
-CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+if command -v sudo &> /dev/null;
+then
+	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+else
+	echo "# SKIP ./on-fault-limit"
+fi
 
 CATEGORY="mmap" run_test ./map_populate
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


