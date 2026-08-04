Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27927469849
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785864953; cv=none; b=LFgydlUX6PiWnqRXu/6ZOiw++F20Qmp5egnSQjDJBPThmLhRljS2+btPTXt7GI6Dgd5a8++Dwr2HBM8Rb0sjFKuvigN9yHfgKb2ecRq4pXkJVkqh3T+o5ASQxuPsLL3+fYtjDRHW9sN9LVzyeH4TVXyul8K6GNTQDwNUwWhtzHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785864953; c=relaxed/simple;
	bh=uMzwHd/79KnfXb1CvQ5QbhnBnqHsMVZMK60wQWtnkpY=;
	h=Date:To:From:Subject:Message-Id; b=HpFwMxuAYUL2od5NBPxxQ3Ko8hvTfp/vjNpgzPGLpe62sBf4vTU+sI6LIOm4OCDr7dK25N3JzsWpWXwqSaXPhtoNEFo19VLAl7xso8FBLAYINnDZO4Zwf2pU3JKIzpAaTPeZTAriCX73QX0XdEnLFTUASI6XYg29BoVTFgZoB14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cDzKqO36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cDzKqO36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A719A1F000E9;
	Tue,  4 Aug 2026 17:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785864951;
	bh=CvFV8JMq7oci5X7U1XjwP0Ov4hSKDJg7dhrZuumo0Rw=;
	h=Date:To:From:Subject;
	b=cDzKqO36xH3hxR+fI6sSpcFlc1G7/Jp8XTXqr/IjxqPdHONmqQJ33FvQ9fnMzoaOV
	 rtgFORFpMiggydFirm8BXkgW8Lo5z1QrZl+3q4NfPotNhxcu9ovAgw73eSOPZ85CRL
	 5+a0wZZTv90eigI5N4xpEfd71QSI7EEQyJJEkhJg=
Date: Tue, 04 Aug 2026 10:35:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-read-memory-information-without-popen.patch added to mm-new branch
Message-Id: <20260804173551.A719A1F000E9@smtp.kernel.org>
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

selftests-mm-read-memory-information-without-popen.patch
tools-mm-prevent-page_owner_sort-from-truncating-input.patch

