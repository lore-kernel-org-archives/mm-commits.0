Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E72C38E8A4
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 23:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798887; cv=none; b=TQ2bOiEwm8I6eaCjpLGF51gYbig5m5aM6415MSEoMDgq38z6jxHxmlpr+X9ieBOYqtWMnojUCc1ocs1G5CI1zoYNzmoUAka52Lv3HQGgewGq0k24MvViuxElM4+xjHBFP6NH2MAdZO1Z4PVuyw7NGducSt/LGPWcj2od7Twati0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798887; c=relaxed/simple;
	bh=UUOmrRUr07vJpAf6eQ32513XOQtKWO5F9xs7Fjmpyvg=;
	h=Date:To:From:Subject:Message-Id; b=dRiSw/0MFb96Oayz5sUmIFnK/9XemQDO62YvTyuY9uDtMRTyt7nPmHAp8QOize4YkKcsehmhdB2igfriRhUsLCLnkYtHOU8HOr0Qo3w8TKCgQMnH+QlTR6p4RfR1azaQWfJqZnoiSVfZ7P+678IexJyCbT4l4quGT94P4Q4+sjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYFj/iup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYFj/iup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5AE1F00A3A;
	Mon,  3 Aug 2026 23:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785798883;
	bh=untqt+UbNrRnWOqBYqUFhBEeyU8OOtKrLmW9mOVsV10=;
	h=Date:To:From:Subject;
	b=BYFj/iupoIWppZ10ORdlpWBMAXMy1k1gAij/LegCaz9l8KyalLMl23LQED/mLrvoA
	 MWfGgo7NlFOjAkWdOmRc+XaLpZWOCB010SHThqJ4BvWuKQ/q5NI5eOWxyzbNCtDHKR
	 rorzd//nbWDefs833Uu1y09SCv5lTMks0GZ4VSJA=
Date: Mon, 03 Aug 2026 16:14:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-read-memory-information-without-popen.patch added to mm-new branch
Message-Id: <20260803231443.2B5AE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: read memory information without popen
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-read-memory-information-without-popen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-read-memory-information-without-popen.patch

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

selftests-mm-read-memory-information-without-popen.patch
tools-mm-prevent-page_owner_sort-from-truncating-input.patch

