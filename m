Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D452BE057
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334181; cv=none; b=BVOTemBVmfMiyBsr2cDHoWfeAOZWs8cY+OUQdLSq/zWYs6aRnsq2o0kehGobAkBNo/qiotb/HKbBNkrEzxQgpCNiAoFoJ0ffq87xaTnoJebUUA6Ticv0clptjFfXqzSkLwfST1Jhv3i120/jyfuPAn1exqq/iTMLUdZNpliJBH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334181; c=relaxed/simple;
	bh=+Cadcvb8nF/4/Loe3bIpcDVghC39QBq5kbS0uNRvPqU=;
	h=Date:To:From:Subject:Message-Id; b=ecmkqscEqiY5z/T7gBWNdwuSYAh4P/Je2fuqxnMDxaPwDbJ36ml5iPy1pKASBguFFIoLDZCZpmykF8TAxLQCpMAJKygXpzkGPLaDDq0LTWpDnW+1vxMIvecbIGjUF095ue3xnwQbHR2lnDdThQArDYXNqmGrrHNcsblp50bmPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ccgOuT/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ccgOuT/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F961F0089C;
	Wed,  7 Oct 2026 00:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334180;
	bh=0CsUnXRsh4GG+Ja7hq7iNHfbXJvJIxSsnYHt2yJVL44=;
	h=Date:To:From:Subject;
	b=ccgOuT/cGW2aYvDQJ4YSaghvBUkMFQF3lchsn+X1wNIab+NXLupKpGVtjk0scGKsF
	 /mx0hE71bn4Xsm9qqZwinnvgE9mWJl/PEkMBdZ2alF6S6D5scvhCUlILTQPoAHK4Dm
	 L1UG0JTSu1noOodGX5DHTQOfi+v3eaZHt+l3gEcg=
Date: Tue, 06 Oct 2026 17:49:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch removed from -mm tree
Message-Id: <20261007004940.19F961F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
Date: Tue, 25 Aug 2026 16:57:56 +0800

hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1
and 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
finishes, silently disabling soft offlining for the whole system after the
run.

Save the original value before the test and restore it from an atexit()
handler, as hugepage_restore_settings_atexit() in hugepage_settings.c
already does.  Use read_num()/write_num() from vm_util instead of
hand-rolled popen()/fopen() helpers.

The restore handler must not call write_num(): on failure it re-enters
exit() through ksft_exit_fail_msg(), which is undefined behavior from
inside an atexit handler.  A non-root run hits it directly - the restore
write fails the same way the write that triggered the exit did.  Restore
with plain open()/write(), best effort.

Link: https://lore.kernel.org/20260825085756.63030-4-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/hugetlb-soft-offline.c |   49 ++++++------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -11,6 +11,7 @@
 
 #define _GNU_SOURCE
 #include <errno.h>
+#include <fcntl.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -23,6 +24,7 @@
 #include <sys/types.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 #include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
@@ -31,6 +33,8 @@
 
 #define EPREFIX " !!! "
 
+#define ENABLE_SOFT_OFFLINE_PATH "/proc/sys/vm/enable_soft_offline"
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -77,26 +81,29 @@ untruncate:
 	return ret;
 }
 
-static int set_enable_soft_offline(int value)
-{
-	char cmd[256] = {0};
-	FILE *cmdfile = NULL;
-
-	if (value != 0 && value != 1)
-		return -EINVAL;
+static unsigned long orig_enable_soft_offline = -1UL;
 
-	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
-	cmdfile = popen(cmd, "r");
+/*
+ * Runs from an atexit handler, so it must not call anything that
+ * exits on failure: write_num() would re-enter exit() through
+ * ksft_exit_fail_msg().
+ */
+static void restore_enable_soft_offline(void)
+{
+	char buf[24];
+	int fd, len;
 
-	if (cmdfile)
-		ksft_print_msg("enable_soft_offline => %d\n", value);
-	else {
-		ksft_perror(EPREFIX "failed to set enable_soft_offline");
-		return errno;
-	}
+	if (orig_enable_soft_offline == -1UL)
+		return;
 
-	pclose(cmdfile);
-	return 0;
+	len = snprintf(buf, sizeof(buf), "%lu", orig_enable_soft_offline);
+	fd = open(ENABLE_SOFT_OFFLINE_PATH, O_WRONLY);
+	if (fd < 0)
+		return;
+	if (write(fd, buf, len) != len)
+		ksft_print_msg("failed to restore enable_soft_offline: %s\n",
+			       strerror(errno));
+	close(fd);
 }
 
 static int create_hugetlbfs_file(struct statfs *file_stat)
@@ -145,10 +152,7 @@ static void test_soft_offline_common(int
 	hugepagesize_kb = file_stat.f_bsize / 1024;
 	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	if (set_enable_soft_offline(enable_soft_offline) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
-	}
+	write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
 
 	nr_hugepages_before = hugetlb_nr_default_pages();
 
@@ -192,6 +196,9 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(2);
 
+	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
+	atexit(restore_enable_soft_offline);
+
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
_

Patches currently in -mm which might be from husong@kylinos.cn are


