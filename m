Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CDF320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560154; cv=none; b=go4VbdM/lNSTiQ05fM2WzZhc6HByEe/lbNwbD1UGO+LiSpdqoEWn0fr6F2LeTXZ55aUACte/A/7qTQM86fOVpjwE2n8xw9YUcSisFnBtIUgrFP+GWWhi8Gi4n6oz3Eb88uNnLrT1cmB+T0xxDKJAea3Jc3IfZsYQrAVReGf5nZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560154; c=relaxed/simple;
	bh=lzF/1Ltg4vqF3hb+3zsbo9GfC3q1qj0YujkgMU/f5/w=;
	h=Date:To:From:Subject:Message-Id; b=F2mBhUh72x+Uvs5uueyll3aKZQClTVk9CH5bVj5DFIXXZvXSrHve+2wixIdXUMbqAi+oXDDvvJUvd+ps/hfInbPhTaju0o2ci2oUryq87zCfoKPZNRZRQTrd/MEtJyuCahkN80AOwON6U7wOmCvYL+N5NryY9CvP59coRbPJlz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NvOhk81z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NvOhk81z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13F8C43390;
	Thu, 22 Feb 2024 00:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560154;
	bh=lzF/1Ltg4vqF3hb+3zsbo9GfC3q1qj0YujkgMU/f5/w=;
	h=Date:To:From:Subject:From;
	b=NvOhk81zleStmlmG6tjoxCA3xNEMZotbk4MbYayCaQJ05v1eu+otcMD3712XktfoQ
	 TLcTiSZU/Btbg9AJPKiLUfy0UKpljr91nMrSO9FFQJHD01MK++j6POWcpz3c4W4FTD
	 CeAg6+Fqxr5ClIrI5vlhRyk8q0jkFb/eOjsPdqFo=
Date: Wed, 21 Feb 2024 16:02:34 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-map_populate-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000234.A13F8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: map_populate: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-map_populate-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

