Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2E48CD70
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785864905; cv=none; b=rMJPacZBngpch8rtKS28XfevciYUyE/6K/R4TAATEoVt815Oyw5aRlMsO0AhZMfLHQVKHt0c5S+d46XbMG2lDv/GxshvOJsbOzEDxgVWiegdGOtG4L7zpoAs73LVKPsxdBibMlgpsU4VUVLqs7taxqnIAzzCig9/rQ8WENMIdg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785864905; c=relaxed/simple;
	bh=YWRoGFFGCq8snU5k1bQc1cAoRVEj+rzzgFJ4NQ3OA2c=;
	h=Date:To:From:Subject:Message-Id; b=ah/l88leDbNwRxjk8DcMvRrDWXcZclSjs5Ra8DlczZ3q3PecJ3nOusKV6tWlh8RJcxIGlaPR4/PGfnizAoIG6P7IQZwB390BbOTkt4MJOZUX9U7neNVw/b+h5kR5nJNELzmBhGci5KQfk/otYCmZYwoJqJrOPg6tajQsfpf8IAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=isA0l4wG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="isA0l4wG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2EA1F000E9;
	Tue,  4 Aug 2026 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785864903;
	bh=QV/yJgncuFzmSrBeBBfLxSv2aTOoHYNwKfwlSdGTKyw=;
	h=Date:To:From:Subject;
	b=isA0l4wGsL5pDkAYk9UN8qOoMIXjwuMLIn73eTZlAIZYCOokzDb/OlJNE5cQXApy/
	 0eG7B2hPQ4DMaLSL9/N9LkakeAtOfONXRo0EBCC/2mfzG900i/kakMVehPcy0D4P0s
	 pZMs6ZvrUo5zwDnYsJkS3U5/W6kfWwPHKtPYTxmI=
Date: Tue, 04 Aug 2026 10:35:03 -0700
To: mm-commits@vger.kernel.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-read-memory-information-without-popen.patch removed from -mm tree
Message-Id: <20260804173503.9D2EA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: read memory information without popen
has been removed from the -mm tree.  Its filename was
     selftests-mm-read-memory-information-without-popen.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Warren Xiong <warren.xiong@ugreen.com>
Subject: selftests/mm: read memory information without popen
Date: Mon, 3 Aug 2026 09:30:15 +0800

read_memory_info() invokes two shell pipelines to obtain MemFree and
Hugepagesize from /proc/meminfo.  It does not check whether popen()
returns NULL before passing the result to fgets(), and it does not call
pclose() when fgets() fails.

Open /proc/meminfo directly and obtain both values in a single pass.  This
removes the unchecked NULL path, closes the file on all paths, and avoids
dependencies on external commands.

The compaction test continues to pass after this change.

Link: https://lore.kernel.org/1785720615-5826-1-git-send-email-warren.xiong@ugreen.com
Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   47 ++++++++++-------
 1 file changed, 29 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-read-memory-information-without-popen
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -7,6 +7,7 @@
  * allocated.
  */
 
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
@@ -29,30 +30,40 @@ struct map_list {
 
 int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
 {
-	char  buffer[256] = {0};
-	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
-	FILE *cmdfile = popen(cmd, "r");
-
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
+	char buffer[256];
+	bool memfree_found = false;
+	bool hugepagesize_found = false;
+	FILE *file;
+	int ret = -1;
+
+	file = fopen("/proc/meminfo", "r");
+	if (!file) {
+		ksft_print_msg("Failed to open /proc/meminfo: %s\n",
+			       strerror(errno));
 		return -1;
 	}
 
-	pclose(cmdfile);
-
-	*memfree = atoll(buffer);
-	cmd = "cat /proc/meminfo | grep -i hugepagesize | grep -o '[0-9]*'";
-	cmdfile = popen(cmd, "r");
-
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
-		return -1;
+	while (fgets(buffer, sizeof(buffer), file)) {
+		if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1)
+			memfree_found = true;
+		else if (sscanf(buffer, "Hugepagesize: %lu kB",
+				hugepagesize) == 1)
+			hugepagesize_found = true;
+
+		if (memfree_found && hugepagesize_found) {
+			ret = 0;
+			break;
+		}
 	}
 
-	pclose(cmdfile);
-	*hugepagesize = atoll(buffer);
+	if (ferror(file))
+		ksft_print_msg("Failed to read /proc/meminfo: %s\n",
+			       strerror(errno));
+	else if (ret)
+		ksft_print_msg("Failed to parse /proc/meminfo\n");
 
-	return 0;
+	fclose(file);
+	return ret;
 }
 
 int prereq(void)
_

Patches currently in -mm which might be from warren.xiong@ugreen.com are

tools-mm-prevent-page_owner_sort-from-truncating-input.patch

