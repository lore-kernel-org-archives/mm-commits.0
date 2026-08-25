Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29130F55F
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622827; cv=none; b=Gs8N2Bw7hsxWBxed5f/5ZlIBUHDUzgUqbX3jLlofmn/iCG6P7n95frniBJsxEZ6i3wwZ/VTioIVK8VwQetYJ/B2u1G6QVaQ8wirM0Z25A8TMqoLLWNJB7THDN7gS9phJC7xUJJaR8SJMNuO6v7BMZZVSBeSwEFlZ7ZWnqTxm/5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622827; c=relaxed/simple;
	bh=8JMnpC3mL2BO+lrP+/U925i1w0eXP4wawzbiVyqLW4I=;
	h=Date:To:From:Subject:Message-Id; b=aq18LXy2npB5RkoC5Npn9PjELR/IiVwXgSeAPrDgCGGqrALXq30Xy6Q9RSsTjmvUjsOxfQPDGIVql3CaUpVVJwfshCWaTSAuCiUkRVGoyQxhuetbpdC1DR2TMYGZgKmER4/QenpADKHF/cfOIb3DpK/YRdCUuBZsntEyJ/UWCEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GbCXE2Im; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GbCXE2Im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC2A1F00A3D;
	Tue, 25 Aug 2026 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622825;
	bh=MhAyU+wvtLdky5hZSdTD+8cV5CMKmaCuO0fjMuuGrQ8=;
	h=Date:To:From:Subject;
	b=GbCXE2ImPXXMdlqdkLgtOXqGbWXQWdEJXDFoZQepDq50YAhHyoy5AWM+KCo5OZBvW
	 UHXjCm0B+mhBx/h3ORpy95oFfAjSqWvtSR/UaoSbTU3891188w2a/AzN0jXcbnokvw
	 NSwxhjzsFPgyjIGF1NUk4cIj+UzHz9pmfBvKCJ2U=
Date: Mon, 24 Aug 2026 18:53:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-read-memory-information-without-popen.patch removed from -mm tree
Message-Id: <20260825015345.AEC2A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: read memory information without popen
has been removed from the -mm tree.  Its filename was
     selftests-mm-read-memory-information-without-popen.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
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


