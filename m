Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AE243CE55
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 23:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785887550; cv=none; b=OSnM+04V+y+Ijg8M+67OrxQlKa4yODttjWXip5rdTsPeYOCKx5dlnb4PcG1Mt+Pu5xkllVF7KZd/L+cM4P09+FOIi8E8K3A3XQwA5pl2TmVZ8ornrvbxv7UrcktFoBW97iC/lTzcI5Os7Mq5qHvW0fyWjBIKJF6lRNlf4AsuY24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785887550; c=relaxed/simple;
	bh=/EUumg9uPPDzkj1bRRlLr7oBx9zd5sm3PMFGk/TCRpU=;
	h=Date:To:From:Subject:Message-Id; b=Xcrhx/boN5bB5Pq+CEu7TKvWmJmzYE2VWqi7v+8rTTRWW6ICbjMR6FamXpVuV2dXSPgx90s7aohVO+ZmuPd/wSin4BnX6Ic+o5ZakqCq0/wihzdhD99XUn0EbhEcHQuvF2jidUcquh1nDcX/+ottodjh1nhxzBdEskNiG8Ckvic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i67TD8CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i67TD8CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138CC1F000E9;
	Tue,  4 Aug 2026 23:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785887549;
	bh=RbZcmecxc3AgZOpf8r3IcXtdD9vXuuoV5ZxzxDTCU44=;
	h=Date:To:From:Subject;
	b=i67TD8CPEPmSEyr4dmw41yIMhFOfxEvF58v92xOAXezJ4AOCHzL2Ckv9hYIa6CHaE
	 F5n7+Q/IZpHm9msibsN01SNSF/CDtVxLCFcbHvkqEb+rNm0XG+OZTU7mQH7gpArbS+
	 /Z9rUrTMlJQ1WLzjPtyf1vLAMIaIVAvD4ttOu4ME=
Date: Tue, 04 Aug 2026 16:52:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-read-memory-information-without-popen.patch removed from -mm tree
Message-Id: <20260804235229.138CC1F000E9@smtp.kernel.org>
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
Date: Tue, 4 Aug 2026 20:16:58 +0800

read_memory_info() invokes two shell pipelines to obtain MemFree and
Hugepagesize from /proc/meminfo.  It does not check whether popen()
returns NULL before passing the result to fgets(), and it does not call
pclose() when fgets() fails.

Open /proc/meminfo directly and obtain both values in a single pass.  This
removes the unchecked NULL path, closes the file on all paths, and avoids
dependencies on external commands.

The compaction test continues to pass after this change.

Link: https://lore.kernel.org/1785845818-3131-1-git-send-email-warren.xiong@ugreen.com
Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   40 +++++++++--------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-read-memory-information-without-popen
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -29,30 +29,34 @@ struct map_list {
 
 int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
 {
-	char  buffer[256] = {0};
-	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
-	FILE *cmdfile = popen(cmd, "r");
-
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
+	char buffer[256];
+	int found = 0;
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
+	while (fgets(buffer, sizeof(buffer), file) && found != 2) {
+		if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1 ||
+		    sscanf(buffer, "Hugepagesize: %lu kB", hugepagesize) == 1)
+			found++;
 	}
 
-	pclose(cmdfile);
-	*hugepagesize = atoll(buffer);
+	if (ferror(file))
+		ksft_print_msg("Failed to read /proc/meminfo: %s\n",
+			       strerror(errno));
+	else if (found != 2)
+		ksft_print_msg("Failed to parse /proc/meminfo\n");
+	else
+		ret = 0;
 
-	return 0;
+	fclose(file);
+	return ret;
 }
 
 int prereq(void)
_

Patches currently in -mm which might be from warren.xiong@ugreen.com are

tools-mm-prevent-page_owner_sort-from-truncating-input.patch

